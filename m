Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaCGNUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaCGNT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:19:58 -0500
Date: Fri, 7 Mar 2014 14:19:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] perf, tools: Add --branch-history option to report v2
Message-ID: <20140307131940.GB13974@krava.brq.redhat.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393561352-23448-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:22:27PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a --branch-history option to perf report that changes all
> the settings necessary for using the branches in callstacks.
> 
> This is just a short cut to make this nicer to use, it does
> not enable any functionality by itself.
> 
> v2: Change sort order. Rename option to --branch-history to
> be less confusing.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-report.txt |  5 +++++
>  tools/perf/builtin-report.c              | 28 +++++++++++++++++++++++++---
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 349cd2a..5b270fe 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -228,6 +228,11 @@ OPTIONS
>  	branch stacks and it will automatically switch to the branch view mode,
>  	unless --no-branch-stack is used.
>  
> +--branch-history::
> +	Add the addresses of sampled taken branches to the callstack.
> +	This allows to examine the path the program took to each sample.
> +	The data collection must have used -b (or -j) and -g.
> +
>  --objdump=<path>::
>          Path to objdump binary.
>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index f7a9e3d..302c4e8 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -691,6 +691,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
>  }
>  
>  static int
> +parse_branch_call_mode(const struct option *opt __maybe_unused,
> +		  const char *str __maybe_unused, int unset)
> +{
> +	int *branch_mode = opt->value;
> +
> +	*branch_mode = !unset;
> +	return 0;
> +}

this is *same* as parse_branch_mode function and seems to be not needed,
I think both branch-stack and branch-history options could be handled
by OPT_BOOLEAN

jirka
