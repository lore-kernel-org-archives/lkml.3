Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaFBQrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:47:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54258 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaFBQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:47:00 -0400
Date: Mon, 2 Jun 2014 09:46:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602164655.GT22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602163032.GI16155@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060216-9332-0000-0000-000000F80EDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:30:32PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
> > I'm almost inclined to just exclude parisc from using opt spinning.
> > 
> > That said, this patch still doesn't address the far more interesting
> > problem of actually finding these issues for these few weird archs.
> 
> So why do these archs provide xchg() and cmpxchg() at all? Wouldn't it
> be much simpler if archs that cannot sanely do this, not provide these
> primitives at all?

Such architectures would also need to avoid NO_HZ_FULL_SYSIDLE and
RCU_NOCB_CPU, but those are probably entirely reasonable restrictions.

							Thanx, Paul

