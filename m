Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaBYDgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:36:08 -0500
Received: from ozlabs.org ([203.10.76.45]:43201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaBYDd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:27 -0500
In-Reply-To: <1392415338-16288-3-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/11] perf core: export swevent hrtimer helpers
Message-Id: <20140225033326.7BB942C0228@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:26 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:06 UTC, Cody P Schafer wrote:
> Export the swevent hrtimer helpers currently only used in events/core.c
> to allow the addition of architecture specific sw-like pmus.

Peter, Ingo, can we get your ACK on this please?

cheers


> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h | 5 ++++-
>  kernel/events/core.c       | 8 ++++----
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2702e91..24378a9 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -559,7 +559,10 @@ extern void perf_pmu_migrate_context(struct pmu *pmu,
>  				int src_cpu, int dst_cpu);
>  extern u64 perf_event_read_value(struct perf_event *event,
>  				 u64 *enabled, u64 *running);
> -
> +extern void perf_swevent_init_hrtimer(struct perf_event *event);
> +extern void perf_swevent_start_hrtimer(struct perf_event *event);
> +extern void perf_swevent_cancel_hrtimer(struct perf_event *event);
> +extern int perf_swevent_event_idx(struct perf_event *event);
>  
>  struct perf_sample_data {
>  	u64				type;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 56003c6..feb0347 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5816,7 +5816,7 @@ static int perf_swevent_init(struct perf_event *event)
>  	return 0;
>  }
>  
> -static int perf_swevent_event_idx(struct perf_event *event)
> +int perf_swevent_event_idx(struct perf_event *event)
>  {
>  	return 0;
>  }
> @@ -6045,7 +6045,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  	return ret;
>  }
>  
> -static void perf_swevent_start_hrtimer(struct perf_event *event)
> +void perf_swevent_start_hrtimer(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
>  	s64 period;
> @@ -6067,7 +6067,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
>  				HRTIMER_MODE_REL_PINNED, 0);
>  }
>  
> -static void perf_swevent_cancel_hrtimer(struct perf_event *event)
> +void perf_swevent_cancel_hrtimer(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
>  
> @@ -6079,7 +6079,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
>  	}
>  }
>  
> -static void perf_swevent_init_hrtimer(struct perf_event *event)
> +void perf_swevent_init_hrtimer(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
>  
> -- 
> 1.8.5.4
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> 
