Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530Ab3DCRIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:08:05 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:50798 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722Ab3DCRIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:08:02 -0400
Date: Wed, 3 Apr 2013 14:07:54 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 09/10] perf hist browser: Use sort__has_sym
Message-ID: <20130403170754.GA7238@ghostprotocols.net>
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
 <1364991979-3008-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364991979-3008-10-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 03, 2013 at 09:26:18PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The TUI hist browser had a similar variable has_symbols for the same
> purpose.  Let's get rid of the duplication.

I'm ok with that, if it involves removing sort__has_sym, that is a
global variable, making it impossible to use different sort orders in
the same session, if we ever want to do that :-)

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index cad8e37f05d9..a4268cab1921 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -25,7 +25,6 @@ struct hist_browser {
>  	struct map_symbol   *selection;
>  	int		     print_seq;
>  	bool		     show_dso;
> -	bool		     has_symbols;
>  };
>  
>  extern void hist_browser__init_hpp(void);
> @@ -1155,10 +1154,6 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
>  		browser->b.refresh = hist_browser__refresh;
>  		browser->b.seek = ui_browser__hists_seek;
>  		browser->b.use_navkeypressed = true;
> -		if (sort__mode == SORT_MODE__BRANCH)
> -			browser->has_symbols = sort_sym_from.list.next != NULL;
> -		else
> -			browser->has_symbols = sort_sym.list.next != NULL;
>  	}
>  
>  	return browser;
> @@ -1386,7 +1381,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  			 */
>  			goto out_free_stack;
>  		case 'a':
> -			if (!browser->has_symbols) {
> +			if (!sort__has_sym) {
>  				ui_browser__warning(&browser->b, delay_secs * 2,
>  			"Annotation is only available for symbolic views, "
>  			"include \"sym*\" in --sort to use it.");
> @@ -1485,7 +1480,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  			continue;
>  		}
>  
> -		if (!browser->has_symbols)
> +		if (!sort__has_sym)
>  			goto add_exit_option;
>  
>  		if (sort__mode == SORT_MODE__BRANCH) {
> -- 
> 1.7.11.7
