Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3GXRxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:53:09 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:60813 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751619Ab3GXRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:53:07 -0400
Date: Wed, 24 Jul 2013 13:54:00 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, adrian.hunter@intel.com, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.51F01480.00D0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> Gitweb:     http://git.kernel.org/tip/a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Tue, 16 Jul 2013 17:09:07 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 23 Jul 2013 12:17:08 +0200
> 
> perf: Update perf_event_type documentation
> 
> Due to a discussion with Adrian I had a good look at the perf_event_type record
> layout and found the documentation to be somewhat unclear.

This code makes a lot of code changes considering it is "updating 
documentation".

Also, will code following this "documentation" be backward compatible?

Meaning, if you have code that depends on the new fields you've added
and run on older kernels, will you get sane results?  Or will the code
get garbage and/or segfault in the sample_id fields because you read
past the end of valid data?

 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20130716150907.GL23818@dyad.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/uapi/linux/perf_event.h | 18 +++++++++++++++++-
>  kernel/events/core.c            | 31 ++++++++++++++++---------------
>  2 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 0b1df41..00d8274 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -478,6 +478,16 @@ enum perf_event_type {
>  	 * file will be supported by older perf tools, with these new optional
>  	 * fields being ignored.
>  	 *
> +	 * struct sample_id {
> +	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
> +	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
> +	 * 	{ u64			id;       } && PERF_SAMPLE_ID
> +	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
> +	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
> +	 * } && perf_event_attr::sample_id_all
> +	 */
> +
> +	/*
>  	 * The MMAP events record the PROT_EXEC mappings so that we can
>  	 * correlate userspace IPs to code. They have the following structure:
>  	 *
> @@ -498,6 +508,7 @@ enum perf_event_type {
>  	 *	struct perf_event_header	header;
>  	 *	u64				id;
>  	 *	u64				lost;
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_LOST			= 2,
> @@ -508,6 +519,7 @@ enum perf_event_type {
>  	 *
>  	 *	u32				pid, tid;
>  	 *	char				comm[];
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_COMM			= 3,
> @@ -518,6 +530,7 @@ enum perf_event_type {
>  	 *	u32				pid, ppid;
>  	 *	u32				tid, ptid;
>  	 *	u64				time;
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_EXIT			= 4,
> @@ -528,6 +541,7 @@ enum perf_event_type {
>  	 *	u64				time;
>  	 *	u64				id;
>  	 *	u64				stream_id;
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_THROTTLE			= 5,
> @@ -539,6 +553,7 @@ enum perf_event_type {
>  	 *	u32				pid, ppid;
>  	 *	u32				tid, ptid;
>  	 *	u64				time;
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_FORK			= 7,
> @@ -549,6 +564,7 @@ enum perf_event_type {
>  	 *	u32				pid, tid;
>  	 *
>  	 *	struct read_format		values;
> +	 * 	struct sample_id		sample_id;
>  	 * };
>  	 */
>  	PERF_RECORD_READ			= 8,
> @@ -596,7 +612,7 @@ enum perf_event_type {
>  	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
>  	 *
>  	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
> -	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
> +	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
>  	 * };
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 5e2bce9..1274114 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4462,20 +4462,6 @@ void perf_output_sample(struct perf_output_handle *handle,
>  		}
>  	}
>  
> -	if (!event->attr.watermark) {
> -		int wakeup_events = event->attr.wakeup_events;
> -
> -		if (wakeup_events) {
> -			struct ring_buffer *rb = handle->rb;
> -			int events = local_inc_return(&rb->events);
> -
> -			if (events >= wakeup_events) {
> -				local_sub(wakeup_events, &rb->events);
> -				local_inc(&rb->wakeup);
> -			}
> -		}
> -	}
> -
>  	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
>  		if (data->br_stack) {
>  			size_t size;
> @@ -4511,16 +4497,31 @@ void perf_output_sample(struct perf_output_handle *handle,
>  		}
>  	}
>  
> -	if (sample_type & PERF_SAMPLE_STACK_USER)
> +	if (sample_type & PERF_SAMPLE_STACK_USER) {
>  		perf_output_sample_ustack(handle,
>  					  data->stack_user_size,
>  					  data->regs_user.regs);
> +	}
>  
>  	if (sample_type & PERF_SAMPLE_WEIGHT)
>  		perf_output_put(handle, data->weight);
>  
>  	if (sample_type & PERF_SAMPLE_DATA_SRC)
>  		perf_output_put(handle, data->data_src.val);
> +
> +	if (!event->attr.watermark) {
> +		int wakeup_events = event->attr.wakeup_events;
> +
> +		if (wakeup_events) {
> +			struct ring_buffer *rb = handle->rb;
> +			int events = local_inc_return(&rb->events);
> +
> +			if (events >= wakeup_events) {
> +				local_sub(wakeup_events, &rb->events);
> +				local_inc(&rb->wakeup);
> +			}
> +		}
> +	}
>  }
>  
>  void perf_prepare_sample(struct perf_event_header *header,
