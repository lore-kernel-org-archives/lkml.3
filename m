Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaBTKyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:54:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbaBTKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:54:19 -0500
Date: Thu, 20 Feb 2014 11:54:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/8] perf ui/tui: Add 'F' hotkey to toggle percentage
 output
Message-ID: <20140220105402.GE11018@krava.brq.redhat.com>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
 <1392000446-14744-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392000446-14744-9-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:47:25AM +0900, Namhyung Kim wrote:
> Add 'F' hotkey to toggle relative and absolute percentage of filtered
> entries.
> 
> Suggested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 14ba6d524943..681c484c5c8e 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -1447,6 +1447,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  	"C             Collapse all callchains\n"			\
>  	"d             Zoom into current DSO\n"				\
>  	"E             Expand all callchains\n"				\
> +	"F             Toggle percentage of filtered entries\n"		\
>  
>  	/* help messages are sorted by lexical order of the hotkey */
>  	const char report_help[] = HIST_BROWSER_HELP_COMMON
> @@ -1552,6 +1553,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  			if (env->arch)
>  				tui__header_window(env);
>  			continue;
> +		case 'F':
> +			symbol_conf.filter_relative ^= 1;
> +			continue;
>  		case K_F1:
>  		case 'h':
>  		case '?':
> -- 
> 1.7.11.7
> 

when in relative mode i get 0 samples count
also in --stdio:

[jolsa@krava perf]$ ./perf report -s symbol --symbols=system_call,vfs_write --stdio --percentage=relative
Failed to open /tmp/perf-1063.map, continuing without symbols
# To display the perf.data header info, please use --header/--header-only options.
#
# Samples: 0  of event 'cycles'
# Event count (approx.): 6046797
#
# Overhead           Symbol
# ........  ...............
#
    57.05%  [k] system_call
    42.95%  [k] vfs_write  


jirka
