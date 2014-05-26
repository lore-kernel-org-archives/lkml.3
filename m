Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaEZR6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaEZR6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:58:17 -0400
Date: Mon, 26 May 2014 19:57:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 12/26] perf tools: Apply percent-limit to cumulative
 percentage
Message-ID: <20140526175744.GA9699@krava.brq.redhat.com>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
 <1400839463-21933-13-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400839463-21933-13-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 07:04:09PM +0900, Namhyung Kim wrote:

SNIP

> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 9f57991025a9..475d2f5c7e16 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -461,12 +461,12 @@ print_entries:
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> -		float percent = h->stat.period * 100.0 /
> -					hists->stats.total_period;
> +		float percent;
>  
>  		if (h->filtered)
>  			continue;
>  
> +		percent = hist_entry__get_percent_limit(h);
>  		if (percent < min_pcnt)
>  			continue;
>  
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index ce37f3f8edd9..ad955fbd194f 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -144,6 +144,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
>  			      struct hists *hists);
>  void hist_entry__free(struct hist_entry *);
>  
> +
>  void hists__output_resort(struct hists *hists);
>  void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);

nit.. extra hunk ;-) I'll squash it

jirka
