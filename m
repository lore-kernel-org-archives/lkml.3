Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaBCV43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:56:29 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45321 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:56:28 -0500
Message-ID: <1391464583.7498.72.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Date: Mon, 03 Feb 2014 13:56:23 -0800
In-Reply-To: <20140203210636.GY5002@laptop.programming.kicks-ass.net>
References: <20140129115142.GE9636@twins.programming.kicks-ass.net>
	 <1391138977.6284.82.camel@j-VirtualBox>
	 <20140131140941.GF4941@twins.programming.kicks-ass.net>
	 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
	 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
	 <1391374883.3164.8.camel@j-VirtualBox>
	 <20140202211230.GX5002@laptop.programming.kicks-ass.net>
	 <1391452760.7498.26.camel@j-VirtualBox>
	 <20140203192525.GN8874@twins.programming.kicks-ass.net>
	 <1391460934.7498.49.camel@j-VirtualBox>
	 <20140203210636.GY5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 22:06 +0100, Peter Zijlstra wrote:
> On Mon, Feb 03, 2014 at 12:55:34PM -0800, Jason Low wrote:
> > On Mon, 2014-02-03 at 20:25 +0100, Peter Zijlstra wrote:
> > > XXX: anybody got a better name than m_spinlock?
> > 
> > So I was thinking something along the lines of
> > mcs_spin_lock_cancelable() as that's essentially what this function
> > does.
> 
> sure, but what do we call the data structure that goes with it? Can't
> have two struct mcs_spinlock :/

If this structure is only going to be used for cancelable mcs locking,
what do you think of "struct cancelable_mcs_spinlock"?


