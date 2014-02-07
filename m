Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaBGIYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:24:43 -0500
Received: from verein.lst.de ([213.95.11.211]:42943 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaBGIYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:24:42 -0500
Date: Fri, 7 Feb 2014 09:24:37 +0100
From: Torsten Duwe <duwe@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207082437.GA26811@lst.de>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <20140206180826.GI5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206180826.GI5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 07:08:26PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2014 at 06:37:27PM +0100, Torsten Duwe wrote:
> > I must admit that I haven't tested the patch on non-pseries ppc64 nor on
> > ppc32. Only ppc64 has the ldarx and I tried to atomically replace the 
> > holder along with the locks. That might prove unneccessary.
> 
> But what is the holder for? Can't we do away with that field?

Scott, Peter: good questions.
The conditional is wrong because I confused pSeries with ppc64 CPUs with
64-bit kernels. I got deluded by the LOCK_TOKEN definition above. Is that
correctly ifdef'd, with PPC64? The holder field should be ifdef'd
CONFIG_PPC_SPLPAR, independent of ppc64.

It is an advisory performance hint, and doesn't need to be updated atomically
with the lock; this and the above are 2 reasons to drop the asm string
operand size voodoo as well.

Thanks,
	Torsten

