Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaLaDwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:52:09 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59799 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaLaDwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:52:08 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 31 Dec 2014 12:53:22 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Taesoo Kim <tsgatesv@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, taesoo@gatech.edu,
        arnaldo.melo@gmail.com
Subject: Re: [PATCH 1/1] perf list: Fix --raw-dump option
Message-ID: <20141231035322.GA1766@sejong>
References: <1419997015-11071-1-git-send-email-tsgatesv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419997015-11071-1-git-send-email-tsgatesv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taesoo,

On Tue, Dec 30, 2014 at 10:36:55PM -0500, Taesoo Kim wrote:
> Currently, 'perf list --raw-dump' requires extra arguments
> (e.g., hw) to invoke, which breaks bash/zsh completion
> (perf-completion.sh).
> 
>   $ perf list --raw-dump
>     Error: unknown option `raw-dump'
> 
>      usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]
> 
> After,
> 
>   $ perf list --raw-dump
>   cpu-cycles instructions cache-references cache-misses ...
> 
> Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/builtin-list.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..198f3c3 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -19,7 +19,9 @@
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
> -	const struct option list_options[] = {
> +	bool raw_dump = false;
> +	struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> @@ -27,11 +29,18 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  		NULL
>  	};
>  
> +	set_option_flag(list_options, 0, "raw-dump", PARSE_OPT_HIDDEN);
> +
>  	argc = parse_options(argc, argv, list_options, list_usage,
>  			     PARSE_OPT_STOP_AT_NON_OPTION);
>  
>  	setup_pager();
>  
> +	if (raw_dump) {
> +		print_events(NULL, true);
> +		return 0;
> +	}
> +
>  	if (argc == 0) {
>  		print_events(NULL, false);
>  		return 0;
> @@ -53,8 +62,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  			print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
>  			print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
> -- 
> 2.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
