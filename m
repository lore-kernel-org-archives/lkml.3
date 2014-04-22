Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbaDVRLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbaDVRLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:11:15 -0400
Date: Tue, 22 Apr 2014 19:10:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/9] perf tools: Account entry stats when it's added to
 the output tree
Message-ID: <20140422171048.GL1104@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:45PM +0900, Namhyung Kim wrote:

SNIP

>  
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 1c77714f668d..f955ae5a41c5 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -344,9 +344,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>  		hists__calc_col_len(hists, h);
>  		hists->nr_non_filtered_entries++;
>  		hists->stats.total_non_filtered_period += h->stat.period;
> +		hists->stats.nr_non_filtered_samples += h->stat.nr_events;
>  	}
>  	hists->nr_entries++;
>  	hists->stats.total_period += h->stat.period;
> +	hists__add_nr_events(hists, PERF_RECORD_SAMPLE, h->stat.nr_events);

while at it.. could hists__remove_entry_filter call hists__inc_nr_entries too?

not sure about those 2 extra lines in hists__remove_entry_filter:

        if (h->ms.unfolded)
                hists->nr_non_filtered_entries += h->nr_rows;
        h->row_offset = 0;

maybe they should be added into hists__inc_nr_entries?


thanks,
jirka
