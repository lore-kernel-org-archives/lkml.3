Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3KFTnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:43:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36557 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:43:19 -0500
Date: Wed, 6 Nov 2013 20:42:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131106194244.GL16117@laptop.programming.kicks-ass.net>
References: <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
 <20131104191127.GW16117@laptop.programming.kicks-ass.net>
 <20131104205344.GW3947@linux.vnet.ibm.com>
 <20131106123946.GJ10651@twins.programming.kicks-ass.net>
 <CAMuHMdXZjQJvT7R4ODbDNBgAVwPUBPjB6UoR66_sNuFx7opUDw@mail.gmail.com>
 <20131106135736.GK10651@twins.programming.kicks-ass.net>
 <20131106184848.GM18245@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106184848.GM18245@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:48:48AM -0800, Paul E. McKenney wrote:
> A few nits on Documentation/memory-barriers.txt and some pointless
> comments elsewhere.  With the suggested Documentation/memory-barriers.txt
> fixes:
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks, I think I'll cut the thing into a number of smaller patches with
identical end result. Will (hopefully) post a full new series tomorrow
somewhere.

I was thinking like:
 1 - aggressively employ asm-generic/barrier.h
 2 - Reformulate _The_ document to ACQUIRE/RELEASE
 3 - add the new store/load thingies

That should hopefully be slightly easier to look at.
