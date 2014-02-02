Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBBWDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 17:03:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46891 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBBWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 17:03:05 -0500
Date: Sun, 2 Feb 2014 14:02:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140202220258.GF4333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <1391138977.6284.82.camel@j-VirtualBox>
 <20140131140941.GF4941@twins.programming.kicks-ass.net>
 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131200825.GS5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020222-0928-0000-0000-000005ED9269
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 09:08:25PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 12:01:37PM -0800, Jason Low wrote:
> > On Fri, Jan 31, 2014 at 6:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > I've downloaded AIM7 from sf.net and I hope I'm running it with 100+
> > > loads but I'm not entirely sure I got this thing right, its not really
> > > making progress with or without patch :/
> > 
> > Ingo's program http://lkml.org/lkml/2006/1/8/50 using the V option may
> > be able to generate similar mutex contention.
> > 
> > Currently still getting soft lockups with the updated version.
> 
> Bugger.. ok clearly I need to think harder still. I'm fairly sure this
> cancelation can work though, just seems tricky to get right :-)

We used to do something similar to avoid passing locks off to tasks that
had been interrupted while spinning, and it was a bit tricky.  But we
had it a bit easier, because we didn't actually have to remove the element
from the queue, just bypass it at lock-grant time.

							Thanx, Paul

> I'll give that proglet from Ingo a go, although that might be Monday ere
> I get to it.
> 

