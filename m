Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3LZOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:05:40 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57159 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3LZOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:05:27 -0500
Date: Thu, 26 Dec 2013 11:05:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/8] perf ui/tui: Split help message for perf top and
 report
Message-ID: <20131226140521.GB30980@ghostprotocols.net>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
 <1388036284-32342-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388036284-32342-3-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 02:37:58PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Some hotkeys don't work for perf top so split help messages for them.
> It'll be helpful to a future modification.  Also sort the message by
> alphabetical order of the hotkey.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 49 ++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index a440e03cd8c2..d43ec79ea4e3 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -1400,6 +1400,35 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  	char script_opt[64];
>  	int delay_secs = hbt ? hbt->refresh : 0;
>  
> +#define HIST_BROWSER_HELP_COMMON					\
> +	"h/?/F1        Show this window\n"				\
> +	"UP/DOWN/PGUP\n"						\
> +	"PGDN/SPACE    Navigate\n"					\
> +	"q/ESC/CTRL+C  Exit browser\n\n"				\
> +	"For multiple event sessions:\n\n"				\
> +	"TAB/UNTAB     Switch events\n\n"				\
> +	"For symbolic views (--sort has sym):\n\n"			\
> +	"->            Zoom into DSO/Threads & Annotate current symbol\n" \
> +	"<-            Zoom out\n"					\
> +	"a             Annotate current symbol\n"			\
> +	"C             Collapse all callchains\n"			\
> +	"d             Zoom into current DSO\n"				\
> +	"E             Expand all callchains\n"				\
> +
> +	/* help messages are sorted by lexical order of the hotkey */
> +	const char report_help[] = HIST_BROWSER_HELP_COMMON
> +	"P             Print histograms to perf.hist.N\n"
> +	"r             Run available scripts\n"
> +	"s             Switch to another data file in PWD\n"
> +	"t             Zoom into current Thread\n"
> +	"V             Verbose (DSO names in callchains, etc)\n"
> +	"/             Filter symbol by name";
> +	const char top_help[] = HIST_BROWSER_HELP_COMMON
> +	"P             Print histograms to perf.hist.N\n"
> +	"t             Zoom into current Thread\n"
> +	"V             Verbose (DSO names in callchains, etc)\n"
> +	"/             Filter symbol by name";
> +
>  	if (browser == NULL)
  		return -1;

This wastes space, why not have the HIST_BROWSER_HELP_COMMON as a

	const char common_help[] = ...

and then use:
		ui_browser_helo(..., "%s%s", common_help,
				is_report_browser(hbt) ? report_help : top_help);

?

- Arnaldo

>  
> @@ -1488,25 +1517,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  		case 'h':
>  		case '?':
>  			ui_browser__help_window(&browser->b,
> -					"h/?/F1        Show this window\n"
> -					"UP/DOWN/PGUP\n"
> -					"PGDN/SPACE    Navigate\n"
> -					"q/ESC/CTRL+C  Exit browser\n\n"
> -					"For multiple event sessions:\n\n"
> -					"TAB/UNTAB Switch events\n\n"
> -					"For symbolic views (--sort has sym):\n\n"
> -					"->            Zoom into DSO/Threads & Annotate current symbol\n"
> -					"<-            Zoom out\n"
> -					"a             Annotate current symbol\n"
> -					"C             Collapse all callchains\n"
> -					"E             Expand all callchains\n"
> -					"d             Zoom into current DSO\n"
> -					"t             Zoom into current Thread\n"
> -					"r             Run available scripts('perf report' only)\n"
> -					"s             Switch to another data file in PWD ('perf report' only)\n"
> -					"P             Print histograms to perf.hist.N\n"
> -					"V             Verbose (DSO names in callchains, etc)\n"
> -					"/             Filter symbol by name");
> +				is_report_browser(hbt) ? report_help : top_help);
>  			continue;
>  		case K_ENTER:
>  		case K_RIGHT:
> -- 
> 1.7.11.7
