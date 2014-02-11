Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaBKJSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:18:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaBKJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:18:33 -0500
Date: Tue, 11 Feb 2014 10:18:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
Message-ID: <20140211091805.GK27965@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.671232531@infradead.org>
 <1392066959.2051.2.camel@j-VirtualBox>
 <20140210213202.GX2936@laptop.programming.kicks-ass.net>
 <1392069862.2918.26.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392069862.2918.26.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:04:22PM -0800, Jason Low wrote:
> On Mon, 2014-02-10 at 22:32 +0100, Peter Zijlstra wrote:
> > Is adding that really much faster than the relatively straight path
> > oqs_wait_next() would walk to bit the same exit?
> > 
> > The only reason I pulled out the above cmpxchg() is because its the
> > uncontended fast path, which seems like a special enough case.
> 
> So it would avoid 2 extra checks (*lock == node) and (node->next) in the
> oqs_wait_next() path, which aren't necessary when node->next != NULL.
> 
> And I think node->next != NULL can be considered a special enough case
> after the cmpxchg() fails because in the contended case, we're expecting
> the node->next to be pointing at something. The only times node->next is
> NULL after cmpxchg() fails are during a very small race window with the
> osq_lock(), and when the next node is unqueuing due to need_resched,
> which is also a very small window.

True all; now if only we had a useful benchmark so we could test if it
makes a difference or not :-)
