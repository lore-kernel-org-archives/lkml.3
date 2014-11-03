Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaKCKkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:40:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaKCKkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:40:35 -0500
Date: Mon, 3 Nov 2014 11:40:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH 1/1] perf tools: perf diff for different binaries
Message-ID: <20141103104016.GA19796@krava.brq.redhat.com>
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 05:06:12AM -0700, kan.liang@intel.com wrote:

SNIP

>     99.82%        1.005478  tchain_edit        [.] f3
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/builtin-diff.c |  5 ++++-
>  tools/perf/util/sort.c    | 26 ++++++++++++++++++++++++++
>  tools/perf/util/sort.h    |  3 +++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 25114c9..71183c1 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -743,7 +743,7 @@ static const struct option options[] = {
>  	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
>  		   "only consider these symbols"),
>  	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> -		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
> +		   "sort by key(s): pid, comm, dso, symbol, symbol_name, parent, cpu, srcline, ..."
>  		   " Please refer the man page for the complete list."),
>  	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
>  		   "separator for columns, no spaces will be added between "
> @@ -1164,6 +1164,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
>  	if (setup_sorting() < 0)
>  		usage_with_options(diff_usage, options);
>  
> +	if (sort__has_sym_name)
> +		tool.mmap2 = perf_event__process_mmap2;

why is the mmap2 callback set only for sort__has_sym_name?
Shouldn't we use/define it directly in the tool's definition?

jirka
