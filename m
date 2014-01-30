Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaA3SRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:17:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaA3SRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:17:12 -0500
Date: Thu, 30 Jan 2014 19:16:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "will@willdeacon.co.uk" <will@willdeacon.co.uk>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140130181643.GJ5002@laptop.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
 <20140130154400.GB5126@laptop.programming.kicks-ass.net>
 <20140130175212.GM7575@mudshark.cambridge.arm.com>
 <20140130180533.GH5002@laptop.programming.kicks-ass.net>
 <20140130181136.GP7575@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130181136.GP7575@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 06:11:36PM +0000, Will Deacon wrote:
> On Thu, Jan 30, 2014 at 06:05:33PM +0000, Peter Zijlstra wrote:
> > On Thu, Jan 30, 2014 at 05:52:12PM +0000, Will Deacon wrote:
> > > It would be nice if these were default implementations of the unlock, then
> > > architectures just implement atomic_sub_release how they like.
> > 
> > Yes, I suppose that makes sense. Last time I proposed the primitive
> > nobody yelled at me, so I suppose that means people agree :-)
> 
> If it's useful for these qrwlocks, that's good enough for me!

There's the qspinlock that can also use it.

> Have you looked at the OpenCL atomic intrinsics at all?
> 
>   http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/atomicFunctions.html
> 
> There's a good chance that they can be implemented efficiently on any
> architectures that care about OpenCL. As you've noticed, composing them
> together can be more efficient on LL/SC-based architectures too.

Never looked at OpenCL, I'll have a look.

> Okey doke. If you need a stable (non-rebasing) branch, just holler.

Nah, who cares about those anyway :-)
