defmodule BorsNG.GitHub.Pr do
  @moduledoc """
  The structure of GitHub pull requests
  """

  @type tjson :: map
  @type t :: %BorsNG.GitHub.Pr{
          number: integer,
          title: bitstring | nil,
          body: bitstring | nil,
          state: :open | :closed,
          base_ref: bitstring,
          base_sha: bitstring,
          head_sha: bitstring,
          head_ref: bitstring,
          user: BorsNG.GitHub.User.t(),
          # not all PRs have this field populated
          mergeable: boolean | nil,
          draft: boolean
        }
  defstruct(
    number: 0,
    title: "",
    body: "",
    state: :closed,
    base_ref: "",
    base_sha: "",
    head_sha: "",
    user: nil,
    head_ref: "",
    head_repo_id: 0,
    base_repo_id: 0,
    merged: false,
    mergeable: nil,
    draft: false
  )

  @doc """
  Convert from Jason-decoded JSON to a Pr struct.
  """
  @spec from_json!(tjson) :: t
  def from_json!(json) do
    {:ok, pr} = from_json(json)
    pr
  end

  @doc """
  Convert from Jason-decoded JSON to a Pr struct.
  """
  @spec from_json(tjson) :: {:ok, t} | {:error, term}
  def from_json(
        pr = %{
          "number" => number,
          "title" => title,
          "body" => body,
          "state" => state,
          "base" => %{
            "ref" => base_ref,
            "sha" => base_sha,
            "repo" => %{
              "id" => base_repo_id
            }
          },
          "head" => %{
            "sha" => head_sha,
            "ref" => head_ref,
            "repo" => %{
              "id" => head_repo_id
            }
          },
          "user" => %{
            "id" => user_id,
            "login" => user_login,
            "avatar_url" => user_avatar_url
          },
          "merged_at" => merged_at,
          "mergeable" => mergeable
        }
      )
      when is_integer(number) do
    {:ok,
     %BorsNG.GitHub.Pr{
       number: number,
       title:
         case title do
           nil -> ""
           x -> x
         end,
       body:
         case body do
           nil -> ""
           x -> x
         end,
       state:
         case state do
           "open" -> :open
           "closed" -> :closed
         end,
       base_ref: base_ref,
       base_sha: base_sha,
       head_sha: head_sha,
       head_ref: head_ref,
       head_repo_id: head_repo_id,
       base_repo_id: base_repo_id,
       user: %BorsNG.GitHub.User{
         id: user_id,
         login: user_login,
         avatar_url: user_avatar_url
       },
       merged: not is_nil(merged_at),
       mergeable: mergeable,
       draft: if(is_nil(pr[:draft]), do: false, else: pr.draft)
     }}
  end

  def from_json(
        pr = %{
          "number" => number,
          "title" => title,
          "body" => body,
          "state" => state,
          "base" => %{
            "ref" => base_ref,
            "sha" => base_sha,
            "repo" => %{
              "id" => base_repo_id
            }
          },
          "head" => %{
            "sha" => head_sha,
            "ref" => head_ref,
            "repo" => %{
              "id" => head_repo_id
            }
          },
          "user" => %{
            "id" => user_id,
            "login" => user_login,
            "avatar_url" => user_avatar_url
          },
          "merged_at" => merged_at
        }
      )
      when is_integer(number) do
    from_json(%{
      "number" => number,
      "title" => title,
      "body" => body,
      "state" => state,
      "base" => %{
        "ref" => base_ref,
        "sha" => base_sha,
        "repo" => %{
          "id" => base_repo_id
        }
      },
      "head" => %{
        "sha" => head_sha,
        "ref" => head_ref,
        "repo" => %{
          "id" => head_repo_id
        }
      },
      "user" => %{
        "id" => user_id,
        "login" => user_login,
        "avatar_url" => user_avatar_url
      },
      "merged_at" => merged_at,
      "mergeable" => nil,
      "draft" => if(is_nil(pr[:draft]), do: false, else: pr.draft)
    })
  end

  def from_json(x) do
    {:error, x}
  end
end
