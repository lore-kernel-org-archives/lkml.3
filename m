Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3IMVaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:30:08 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:55527 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753708Ab3IMVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:30:07 -0400
Date: Fri, 13 Sep 2013 17:31:26 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, adrian.hunter@intel.com, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1309131728260.4174@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.523383DD.0084,ss=1,re=0.000,fgs=0
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
> 
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

So in Adrian Hunter's posted patches the PERF_RECORD_MMAP documentation
is also patched like all the others, with 

    struct sample_id                sample_id;

But in this tip message (and in the current linus-git kernel) somehow the
PERF_RECORD_MMAP line of the patch was dropped.

Was that intentional?

I'm trying to document this mess in the manpage, not fun.

Vince
