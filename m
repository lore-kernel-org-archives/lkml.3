Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaA3SND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:13:03 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37855 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbaA3SNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:13:00 -0500
Date: Thu, 30 Jan 2014 18:11:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20140130181136.GP7575@mudshark.cambridge.arm.com>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
 <20140130154400.GB5126@laptop.programming.kicks-ass.net>
 <20140130175212.GM7575@mudshark.cambridge.arm.com>
 <20140130180533.GH5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130180533.GH5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 06:05:33PM +0000, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 05:52:12PM +0000, Will Deacon wrote:
> > It would be nice if these were default implementations of the unlock, then
> > architectures just implement atomic_sub_release how they like.
> 
> Yes, I suppose that makes sense. Last time I proposed the primitive
> nobody yelled at me, so I suppose that means people agree :-)

If it's useful for these qrwlocks, that's good enough for me!

> > One thing worth mentioning: I have a fairly invasive set of changes pending
> > for arch/arm64/include/asm/atomic.h, so if you do decide to go with this,
> > I'm more than happy to take the sub_release part via the arm64 tree. I guess
> > it depends on when this is likely to get merged.
> 
> I suppose it depends on when I get enough courage to do: vim
> arch/*/include/asm/atomic*.h :-)

Hehe.

> There's a few other cleanups I want to do, like today I found
> atomic_{set,clear}_mask() instead of the more natural atomic_{or,and}()
> functions.

Have you looked at the OpenCL atomic intrinsics at all?

  http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/atomicFunctions.html

There's a good chance that they can be implemented efficiently on any
architectures that care about OpenCL. As you've noticed, composing them
together can be more efficient on LL/SC-based architectures too.

> I also think we can get rid of the {inc,dec} variants of
> smp_mb__{before,after}_atomic() since these barriers should be the same
> for _all_ atomic ops that do not already imply full mb semantics, and
> they're certainly the same for all current inc/dec.

Makes sense.

> If tomorrow is another slow day and I get through enough of the review
> backlog I might just give it a go.
> 
> Anyway, I'll base them on your arm64 changes, I know where to find
> those.

Okey doke. If you need a stable (non-rebasing) branch, just holler.

Cheers,

Will
