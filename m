Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3KMPSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:18:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3KMPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:18:35 -0500
Date: Wed, 13 Nov 2013 16:18:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] ARC: perf: ARC 700 PMU doesn't support sampling events
Message-ID: <20131113151822.GO21461@twins.programming.kicks-ass.net>
References: <1384355166-21409-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384355166-21409-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 04:06:06PM +0100, Mischa Jonker wrote:
> The ARC 700 does not have an interrupt associated with it, and as
> such it cannot trigger when a counter overflows. As the counters are
> 48 bit, it will usually take at least 100 days before a counter
> overflows, so for mere counting of events, there is no problem.
> Sampling is not supported though.

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Cc: Vineet Gupta <vgupta@synopsys.com>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> ---
>  arch/arc/kernel/perf_event.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
> index 759e5f3..e46d81f 100644
> --- a/arch/arc/kernel/perf_event.c
> +++ b/arch/arc/kernel/perf_event.c
> @@ -99,6 +99,10 @@ static int arc_pmu_event_init(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int ret;
>  
> +	/* ARC 700 PMU does not support sampling events */
> +	if (is_sampling_event(event))
> +		return -ENOENT;
> +
>  	switch (event->attr.type) {
>  	case PERF_TYPE_HARDWARE:
>  		if (event->attr.config >= PERF_COUNT_HW_MAX)
> -- 
> 1.7.9.5
> 
