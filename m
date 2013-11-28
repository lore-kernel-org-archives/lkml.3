Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab3K1PY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:24:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3K1PYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:24:52 -0500
Message-ID: <5297603D.6040300@suse.de>
Date: Thu, 28 Nov 2013 16:24:45 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130910 Thunderbird/17.0.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] sched: Remove PREEMPT_NEED_RESCHED from generic code
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org> <20131128132641.GP10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131128132641.GP10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 02:26 PM, Peter Zijlstra wrote:
> Subject: sched: Remove PREEMPT_NEED_RESCHED from generic code
>
> While hunting a preemption issue with Alexander, Ben noticed that the
> currently generic PREEMPT_NEED_RESCHED stuff is horribly broken for
> load-store architectures.
>
> We currently rely on the IPI to fold TIF_NEED_RESCHED into
> PREEMPT_NEED_RESCHED, but when this IPI lands while we already have
> a load for the preempt-count but before the store, the store will erase
> the PREEMPT_NEED_RESCHED change.
>
> The current preempt-count only works on load-store archs because
> interrupts are assumed to be completely balanced wrt their preempt_count
> fiddling; the previous preempt_count load will match the preempt_count
> state after the interrupt and therefore nothing gets lost.
>
> This patch removes the PREEMPT_NEED_RESCHED usage from generic code and
> pushes it into x86 arch code; the generic code goes back to relying on
> TIF_NEED_RESCHED.
>
> Boot tested on x86_64 and compile tested on ppc64.
>
> Reported-by: Alexander Graf <agraf@suse.de>
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Fixes the issue for me.

Tested-by: Alexander Graf <agraf@suse.de>


Alex

