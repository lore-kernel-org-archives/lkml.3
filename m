Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaKLKPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:15:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:43072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKLKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:15:49 -0500
Date: Wed, 12 Nov 2014 11:15:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
Message-ID: <20141112101532.GJ29390@twins.programming.kicks-ass.net>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
 <20141111194734.GL16265@arm.com>
 <54627BC0.4020705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54627BC0.4020705@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:12:32PM -0800, Alexander Duyck wrote:
> >Minor nit on naming, but load_acquire would match what we do with barriers,
> >where you simply drop the smp_ prefix if you want the thing to work on UP
> >systems too.
> 
> The problem is this is slightly different, load_acquire in my mind would use
> a mb() call, I only use a rmb().  That is why I chose read_acquire as the
> name.

acquire is not about rmb vs mb, do read up on
Documentation/memory-barriers.txt. Its a distinctly different semantic.
Some archs simply lack the means of implementing this semantics and have
to revert to mb (stronger is always allowed).

Using the read vs load to wreck the acquire semantics is just insane.
