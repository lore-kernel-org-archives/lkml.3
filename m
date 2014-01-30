Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaA3SGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:06:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaA3SGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:06:10 -0500
Date: Thu, 30 Jan 2014 19:05:33 +0100
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
Message-ID: <20140130180533.GH5002@laptop.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
 <20140130154400.GB5126@laptop.programming.kicks-ass.net>
 <20140130175212.GM7575@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130175212.GM7575@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 05:52:12PM +0000, Will Deacon wrote:
> It would be nice if these were default implementations of the unlock, then
> architectures just implement atomic_sub_release how they like.

Yes, I suppose that makes sense. Last time I proposed the primitive
nobody yelled at me, so I suppose that means people agree :-)

> One thing worth mentioning: I have a fairly invasive set of changes pending
> for arch/arm64/include/asm/atomic.h, so if you do decide to go with this,
> I'm more than happy to take the sub_release part via the arm64 tree. I guess
> it depends on when this is likely to get merged.

I suppose it depends on when I get enough courage to do: vim
arch/*/include/asm/atomic*.h :-)

There's a few other cleanups I want to do, like today I found
atomic_{set,clear}_mask() instead of the more natural atomic_{or,and}()
functions.

I also think we can get rid of the {inc,dec} variants of
smp_mb__{before,after}_atomic() since these barriers should be the same
for _all_ atomic ops that do not already imply full mb semantics, and
they're certainly the same for all current inc/dec.

If tomorrow is another slow day and I get through enough of the review
backlog I might just give it a go.

Anyway, I'll base them on your arm64 changes, I know where to find
those.
