Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaESNN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaESNNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:13:23 -0400
Date: Mon, 19 May 2014 15:12:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@rehdat.com>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to
 hpp format routines
Message-ID: <20140519131257.GC20810@krava.brq.redhat.com>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
 <1400480762-22852-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400480762-22852-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:25:48PM +0900, Namhyung Kim wrote:

SNIP

> @@ -1104,27 +1104,35 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
>  				       struct hist_entry *he, FILE *fp)
>  {
>  	char s[8192];
> -	double percent;
>  	int printed = 0;
>  	char folded_sign = ' ';
> +	struct perf_hpp hpp = {
> +		.buf = s,
> +		.size = sizeof(s),
> +	};
> +	struct perf_hpp_fmt *fmt;
> +	bool first = true;
> +	int ret;
>  
>  	if (symbol_conf.use_callchain)
>  		folded_sign = hist_entry__folded(he);
>  
> -	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
> -	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
> -
>  	if (symbol_conf.use_callchain)
>  		printed += fprintf(fp, "%c ", folded_sign);
>  
> -	printed += fprintf(fp, " %5.2f%%", percent);
> -
> -	if (symbol_conf.show_nr_samples)
> -		printed += fprintf(fp, " %11u", he->stat.nr_events);
> +	perf_hpp__for_each_format(fmt) {
> +		if (perf_hpp__should_skip(fmt))
> +			continue;

this one is defined in later patch, so it breaks build in this one

jirka
