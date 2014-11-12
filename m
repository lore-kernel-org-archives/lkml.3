Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKLKLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:11:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaKLKLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:11:34 -0500
Date: Wed, 12 Nov 2014 11:10:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, alexander.duyck@gmail.com,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
Message-ID: <20141112101052.GI29390@twins.programming.kicks-ass.net>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
 <CA+55aFwo9f3tWaRqN1Xam9UkWv1B5F4YnRP1Qx3T78E4o=8YJQ@mail.gmail.com>
 <54627563.5000400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54627563.5000400@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:45:23PM -0800, Alexander Duyck wrote:
> 
> On 11/11/2014 11:40 AM, Linus Torvalds wrote:
> >On Tue, Nov 11, 2014 at 10:57 AM,  <alexander.duyck@gmail.com> wrote:
> >>
> >>
> >>On reviewing the documentation and code for smp_load_acquire() it occurred
> >>to me that implementing something similar for CPU <-> device interaction
> >>would be worth while.  This commit provides just the load/read side of this
> >>in the form of read_acquire().
> >
> >So I don't hate the concept, but. there's a couple of reasons to think
> >this is broken.
> >
> >One is just the name. Why do we have "smp_load_acquire()", but then
> >call the non-smp version "read_acquire()"? That makes very little
> >sense to me. Why did "load" become "read"?
> 
> The idea behind read vs load in the name was because smp_load_acquire is
> using a full smp_mb() whereas this just falls back to rmb() for the cases it
> is dealing with.  My main conern is that a full memory barrier would be more
> expensive so I didn't want to give the idea that this is as completed as
> smp_load_acquire().  The read_acquire() call is not strictly enforcing any
> limitations on writes/stores, although there are a few cases where the
> barriers used do leak that functionality over as a side-effect.

Then I object. We should not name it acquire if it does not in fact
provides acquire semantics.

Memory ordering is hard enough, we don't need random weird semantics
mixed in just because.
