Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaAHPUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbaAHPUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:20:40 -0500
Date: Wed, 8 Jan 2014 13:20:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option
 for perf list.
Message-ID: <20140108152032.GE2626@infradead.org>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
 <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 30, 2013 at 10:26:41AM -0500, Dongsheng Yang escreveu:
> Ramkumar reported that perf list --raw-dump was broken by 44d742e.
> Fix by making raw-dump a proper argument.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Are you sure David Signed-off-by' this, isn't this just an Acked-by or
perhaps a Reviewed-by? David?

- Arnaldo

> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-list.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index fed6792..ec90d0a 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -19,8 +19,10 @@
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
> +	bool raw_dump = false;
>  	unsigned int count = 0;
>  	const struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> @@ -34,7 +36,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  	setup_pager();
>  
>  	if (argc == 0) {
> -		print_events(NULL, false);
> +		print_events(NULL, raw_dump);
>  		return 0;
>  	}
>  
> @@ -42,26 +44,24 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  		if (i)
>  			putchar('\n');
>  		if (strncmp(argv[i], "tracepoint", 10) == 0)
> -			count += print_tracepoint_events(NULL, NULL, false);
> +			count += print_tracepoint_events(NULL, NULL, raw_dump);
>  		else if (strcmp(argv[i], "hw") == 0 ||
>  			 strcmp(argv[i], "hardware") == 0)
> -			count += print_events_type(PERF_TYPE_HARDWARE);
> +			count += print_events_type(PERF_TYPE_HARDWARE, raw_dump);
>  		else if (strcmp(argv[i], "sw") == 0 ||
>  			 strcmp(argv[i], "software") == 0)
> -			count += print_events_type(PERF_TYPE_SOFTWARE);
> +			count += print_events_type(PERF_TYPE_SOFTWARE, raw_dump);
>  		else if (strcmp(argv[i], "cache") == 0 ||
>  			 strcmp(argv[i], "hwcache") == 0)
> -			count += print_hwcache_events(NULL, false);
> +			count += print_hwcache_events(NULL, raw_dump);
>  		else if (strcmp(argv[i], "pmu") == 0)
> -			count += print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			count += print_events(NULL, true);
> +			count += print_pmu_events(NULL, raw_dump);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
>  
>  			if (sep == NULL) {
> -				if(!(count += print_events(argv[i], false)))
> +				if(!(count += print_events(argv[i], raw_dump)))
>  					goto err_out;
>  				continue;
>  			}
> @@ -71,7 +71,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  				return -1;
>  
>  			s[sep_idx] = '\0';
> -			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, false)))
> +			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, raw_dump)))
>  				goto err_out;
>  			free(s);
>  		}
> -- 
> 1.8.2.1
