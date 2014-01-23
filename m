Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaAWRi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:38:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaAWRiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:38:54 -0500
Date: Thu, 23 Jan 2014 18:38:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v10 1/4] qrwlock: A queue read/write lock implementation
Message-ID: <20140123173812.GZ31570@twins.programming.kicks-ass.net>
References: <1390426438-31252-1-git-send-email-Waiman.Long@hp.com>
 <1390426438-31252-2-git-send-email-Waiman.Long@hp.com>
 <20140123100751.GS30183@twins.programming.kicks-ass.net>
 <52E14D67.4000202@hp.com>
 <CA+55aFzhx6K9A62ve6E5X4juvNPewED_g1nWwq+-EY0fd0A-0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzhx6K9A62ve6E5X4juvNPewED_g1nWwq+-EY0fd0A-0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:15:38AM -0800, Linus Torvalds wrote:
> On Thu, Jan 23, 2014 at 9:12 AM, Waiman Long <waiman.long@hp.com> wrote:
> >
> > I thought that all atomic RMW instructions are memory barrier.
> 
> On x86 they are. Not necessarily elsewhere.
> 
> > If they are not, what kind of barrier should be added?
> 
> smp_mb__before_atomic_xyz() and smp_mb__after_atomic_xyz() will do it,
> and are no-op (well, barriers - I don't think it matters) on x86.

Right, which on PPC are sync, whereas the release need only have lwsync.

And ARM can actually do atomic_sub_release() but cannot do it with an
additional smp_*__after() construct.

Do we care enough to introduce atomic_sub_release() for them?

