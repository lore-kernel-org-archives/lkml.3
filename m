Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3LZOM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:12:28 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41099 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3LZOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:12:27 -0500
Date: Thu, 26 Dec 2013 11:12:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/8] perf ui/tui: Split help message for perf top and
 report
Message-ID: <20131226141221.GC30980@ghostprotocols.net>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
 <1388036284-32342-3-git-send-email-namhyung@kernel.org>
 <20131226140521.GB30980@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226140521.GB30980@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 11:05:21AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Dec 26, 2013 at 02:37:58PM +0900, Namhyung Kim escreveu:
> > Some hotkeys don't work for perf top so split help messages for them.
> > It'll be helpful to a future modification.  Also sort the message by
> > alphabetical order of the hotkey.

> > +++ b/tools/perf/ui/browsers/hists.c
> > @@ -1400,6 +1400,35 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
> >  	char script_opt[64];
> >  	int delay_secs = hbt ? hbt->refresh : 0;
> >  
> > +#define HIST_BROWSER_HELP_COMMON					\
> > +	"h/?/F1        Show this window\n"				\
> > +	"UP/DOWN/PGUP\n"						\
> > +	"PGDN/SPACE    Navigate\n"					\
> > +	"q/ESC/CTRL+C  Exit browser\n\n"				\
> > +	"For multiple event sessions:\n\n"				\
> > +	"TAB/UNTAB     Switch events\n\n"				\
> > +	"For symbolic views (--sort has sym):\n\n"			\
> > +	"->            Zoom into DSO/Threads & Annotate current symbol\n" \
> > +	"<-            Zoom out\n"					\
> > +	"a             Annotate current symbol\n"			\
> > +	"C             Collapse all callchains\n"			\
> > +	"d             Zoom into current DSO\n"				\
> > +	"E             Expand all callchains\n"				\
> > +
> > +	/* help messages are sorted by lexical order of the hotkey */
> > +	const char report_help[] = HIST_BROWSER_HELP_COMMON
> > +	"P             Print histograms to perf.hist.N\n"
> > +	"r             Run available scripts\n"
> > +	"s             Switch to another data file in PWD\n"
> > +	"t             Zoom into current Thread\n"
> > +	"V             Verbose (DSO names in callchains, etc)\n"
> > +	"/             Filter symbol by name";
> > +	const char top_help[] = HIST_BROWSER_HELP_COMMON
> > +	"P             Print histograms to perf.hist.N\n"
> > +	"t             Zoom into current Thread\n"
> > +	"V             Verbose (DSO names in callchains, etc)\n"
> > +	"/             Filter symbol by name";
> > +
> >  	if (browser == NULL)
>   		return -1;
> 
> This wastes space, why not have the HIST_BROWSER_HELP_COMMON as a
> 
> 	const char common_help[] = ...
> 
> and then use:
> 		ui_browser__help(..., "%s%s", common_help,
> 				is_report_browser(hbt) ? report_help : top_help);
> 
> ?

Because ui__help_window doesn't support va_arg, ok, applying this one
and later we can remove this space wastage when we make it support
variadic arguments.

- Arnaldo
