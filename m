Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaDXJlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:41:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbaDXJlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:41:32 -0400
Date: Thu, 24 Apr 2014 11:40:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 04/11] perf hists: Add a couple of hists stat helper
 functions
Message-ID: <20140424094059.GA1110@krava.brq.redhat.com>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
 <1398327843-31845-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398327843-31845-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:23:56PM +0900, Namhyung Kim wrote:

SNIP

> -	hists->stats.total_period = 0;
> -	hists->stats.total_non_filtered_period = 0;
> +	hists__reset_stats(hists);
>  	hists__reset_col_len(hists);
>  
>  	while (next) {
> @@ -699,13 +716,13 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
>  	if (h->filtered)
>  		return;
>  
> -	++hists->nr_non_filtered_entries;
>  	if (h->ms.unfolded)
>  		hists->nr_non_filtered_entries += h->nr_rows;
>  	h->row_offset = 0;
> -	hists->stats.total_non_filtered_period += h->stat.period;
> +
>  	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
>  
> +	hists__inc_filter_stats(hists, h);
>  	hists__calc_col_len(hists, h);
>  }
>  
> @@ -726,9 +743,9 @@ void hists__filter_by_dso(struct hists *hists)
>  {
>  	struct rb_node *nd;
>  
> -	hists->nr_non_filtered_entries = 0;
> -	hists->stats.total_non_filtered_period = 0;
>  	hists->stats.nr_non_filtered_samples = 0;
> +
> +	hists__reset_filter_stats(hists);

maybe I'm missing some case, but why is not 'nr_non_filtered_samples'
reset/increased in hists__reset_filter_stats/hists__inc_filter_stats functions?

jirka
