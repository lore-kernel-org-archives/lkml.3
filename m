Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaDHIGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:06:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58895 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaDHIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 08/15 V3] perf, c2c: Add stats to track data source bits and cpu to node maps
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-9-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 17:05:56 +0900
In-Reply-To: <1395689826-215033-9-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:59 -0400")
Message-ID: <87eh18w8ij.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:36:59 -0400, Don Zickus wrote:
> This patch adds a bunch of stats that will be used later in post-processing
> to determine where and with what frequency the HITMs are coming from.
>
> Most of the stats are decoded from the data source response.  Another
> piece of the stats is tracking which cpu the record came in on.
>
> Credit to Dick Fowles for determining which bits are important and how to
> properly track them.  Ported to perf by me.
> @@ -187,6 +354,14 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
>  		goto out_mem;
>  	}
>  
> +	err = c2c_decode_stats(&c2c->stats, he);
> +	if (err < 0) {
> +		err = 0;
> +		rb_erase(&he->rb_node_in, c2c->hists.entries_in);
> +		free(he);

Please use hist_entry__free() to free he->mem_info also.

Thanks,
Namhyung


> +		goto out;
> +	}
> +
>  	c2c->hists.stats.total_period += cost;
>  	hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
>  	return err;
