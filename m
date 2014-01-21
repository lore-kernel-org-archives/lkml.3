Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaAUJsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:48:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaAUJst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:48:49 -0500
Date: Tue, 21 Jan 2014 10:47:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v7 6/6] MCS Lock: add Kconfig entries to allow
 arch-specific hooks
Message-ID: <20140121094756.GQ31570@twins.programming.kicks-ass.net>
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
 <1389917316.3138.16.camel@schen9-DESK>
 <20140120123030.GE31570@twins.programming.kicks-ass.net>
 <1390260717.3138.33.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390260717.3138.33.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:31:57PM -0800, Tim Chen wrote:
> On Mon, 2014-01-20 at 13:30 +0100, Peter Zijlstra wrote:

> > Then again, people seem to whinge if you don't keep these Kbuild files
> > sorted, but manually sorting 29 files is just not something I like to
> > do.

> Can you clarify what exactly needs to be sorted?  The Kbuild files
> spit out by git diff appears to be sorted already.

> > diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> > index f01fb505ad52..14cbbbcec01f 100644
> > --- a/arch/alpha/include/asm/Kbuild
> > +++ b/arch/alpha/include/asm/Kbuild
> > @@ -4,3 +4,4 @@ generic-y += clkdev.h
> >  generic-y += exec.h
> >  generic-y += trace_clock.h
> >  generic-y += preempt.h
> > +generic-y += mcs_spinlock.h

Last time I checked the Alphabet m came before p.

I generated this patch using:

for i in arch/*/include/asm/Kbuild
do
	echo "generic-y += mcs_spinlock.h" >> $i
done

Which simply appends the new header. However people want these generic-y
thingies sorted by header name. Hence the gawk script I sent which does
just that.
