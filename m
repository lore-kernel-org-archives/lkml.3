Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaBKJiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:38:19 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33016 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:38:15 -0500
Date: Tue, 11 Feb 2014 10:38:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org,
        Waiman Long <waiman.long@hp.com>, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
Message-ID: <20140211093805.GA28048@gmail.com>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.671232531@infradead.org>
 <1392066959.2051.2.camel@j-VirtualBox>
 <20140210213202.GX2936@laptop.programming.kicks-ass.net>
 <1392069862.2918.26.camel@j-VirtualBox>
 <20140211091805.GK27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211091805.GK27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Feb 10, 2014 at 02:04:22PM -0800, Jason Low wrote:
> > On Mon, 2014-02-10 at 22:32 +0100, Peter Zijlstra wrote:
> > > Is adding that really much faster than the relatively straight path
> > > oqs_wait_next() would walk to bit the same exit?
> > > 
> > > The only reason I pulled out the above cmpxchg() is because its the
> > > uncontended fast path, which seems like a special enough case.
> > 
> > So it would avoid 2 extra checks (*lock == node) and (node->next) in the
> > oqs_wait_next() path, which aren't necessary when node->next != NULL.
> > 
> > And I think node->next != NULL can be considered a special enough case
> > after the cmpxchg() fails because in the contended case, we're expecting
> > the node->next to be pointing at something. The only times node->next is
> > NULL after cmpxchg() fails are during a very small race window with the
> > osq_lock(), and when the next node is unqueuing due to need_resched,
> > which is also a very small window.
> 
> True all; now if only we had a useful benchmark so we could test if 
> it makes a difference or not :-)

Having useful 'perf bench lock' sub-test(s) that mimic the AIM7 
workload (and other workloads that excercise locking) would address 
that concern to a large degree.

Thanks,

	Ingo
