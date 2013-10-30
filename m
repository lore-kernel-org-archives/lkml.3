Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3J3Ms1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:48:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43368 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J3Ms0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:48:26 -0400
Date: Wed, 30 Oct 2013 13:48:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Vince Weaver <vince@deater.net>, Victor Kaplansky <VICTORK@il.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131030124800.GJ16117@laptop.programming.kicks-ass.net>
References: <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131029102131.GA16117@laptop.programming.kicks-ass.net>
 <20131029103057.GN2490@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1310291524240.6608@pianoman.cluster.toy>
 <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <5270F21C.3080805@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5270F21C.3080805@imgtec.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:48:44AM +0000, James Hogan wrote:
> Hi Peter,
> 
> On 30/10/13 10:42, Peter Zijlstra wrote:
> > Subject: perf, tool: Add required memory barriers
> > 
> > To match patch bf378d341e48 ("perf: Fix perf ring buffer memory
> > ordering") change userspace to also adhere to the ordering outlined.
> > 
> > Most barrier implementations were gleaned from
> > arch/*/include/asm/barrier.h and with the exception of metag I'm fairly
> > sure they're correct.
> 
> Yeh...
> 
> Short answer:
> For Meta you're probably best off assuming
> CONFIG_METAG_SMP_WRITE_REORDERING=n and just using compiler barriers.

Thanks, fixed it that way.

> Long answer:
> The issue with write reordering between Meta's hardware threads beyond
> the cache is only with a particular SoC, and SMP is not used in
> production on it.
> It is possible to make the LINSYSEVENT_WR_COMBINE_FLUSH register
> writable to userspace (it's in a non-mappable region already) but even
> then the write to that register needs odd placement to be effective
> (before the shmem write rather than after - which isn't a place any
> existing barriers are guaranteed to be placed). I'm fairly confident we
> get away with it in the kernel, and userland normally just uses linked
> load/store instructions for atomicity which works fine.

Urgh.. sounds like way 'fun' for you ;-)
