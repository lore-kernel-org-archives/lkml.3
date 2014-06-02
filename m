Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaFBUFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:05:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaFBUFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:05:46 -0400
Date: Mon, 2 Jun 2014 22:05:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, chegu_vinod@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602200525.GD13930@laptop.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
 <538CB56E.5010709@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CB56E.5010709@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:33:34PM -0400, Waiman Long wrote:
> On 06/02/2014 12:30 PM, Peter Zijlstra wrote:
> >On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
> >>I'm almost inclined to just exclude parisc from using opt spinning.
> >>
> >>That said, this patch still doesn't address the far more interesting
> >>problem of actually finding these issues for these few weird archs.
> >So why do these archs provide xchg() and cmpxchg() at all? Wouldn't it
> >be much simpler if archs that cannot sanely do this, not provide these
> >primitives at all?
> 
> I believe xchg() and cmpxchg() are used in quite a number of places within
> the generic kernel code. So kernel compilation will fail if those APIs
> aren't provided by an architecture.

Yep.. so this is going to be painful for a while. But given their
(parisc, sparc32, metag-lock1) constraints, who knows how many of those
uses are actually broken.

So the question is, do you prefer subtly broken code or hard compile
fails? Me, I go for the compile fail.

In any case, this all goes towards what hpa said, what are the minimal
requirements we have for running Linux.
