Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3H3QCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:02:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3H3QCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:02:21 -0400
Date: Fri, 30 Aug 2013 18:02:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v4
Message-ID: <20130830160215.GU31370@twins.programming.kicks-ass.net>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
 <1377128846-977-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377128846-977-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:47:23PM -0700, Andi Kleen wrote:
> @@ -1224,6 +1240,15 @@ again:
>  		x86_pmu.drain_pebs(regs);
>  	}
>  
> +	/*
> +	 * To avoid spurious interrupts with perf stat always reset checkpointed
> +	 * counters.
> +	 *
> +	 * XXX move somewhere else.
> +	 */
> +	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
> +		status |= (1ULL << 2);
> +
>  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>  		struct perf_event *event = cpuc->events[bit];
>  

I'm sure I commented on that XXX thing.. 

Yep, right here:

  http://marc.info/?l=linux-kernel&m=137638980210140

Sup?
