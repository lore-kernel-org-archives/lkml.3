Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3LJSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:01:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57399 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3LJSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:01:16 -0500
Date: Tue, 10 Dec 2013 19:00:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131210180054.GG13532@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
 <20131210171530.GO12849@twins.programming.kicks-ass.net>
 <1386696996.2731.18.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386696996.2731.18.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:36:36AM -0800, Davidlohr Bueso wrote:
> On Tue, 2013-12-10 at 18:15 +0100, Peter Zijlstra wrote:
> > - * The length of the list is tracked with atomic ops (hb->waiters),
> > - * providing the necessary memory barriers for the waiters. For the
> > - * waker side, however, we rely on get_futex_key_refs(), using either
> > - * ihold() or the atomic_inc(), for shared futexes. The former provides
> > - * a full mb on all architectures. For architectures that do not have an
> > - * implicit barrier in atomic_inc/dec, we explicitly add it - please
> > - * refer to futex_get_mm() and hb_waiters_inc/dec().
> 
> IMHO this text gives a nice summary instead of documenting each function
> with this things like '... implies MB (B)'. Anyway, I'll resend this
> patch with your corrections.

Right, I didn't much care for that. Once you know that you need them and
what for, the actual finding of the barriers is usually a 'trivial'
matter.


