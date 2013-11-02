Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3KCEEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 00:04:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44864 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3KCEEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 00:04:38 -0400
Date: Sat, 2 Nov 2013 10:49:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, tony.luck@intel.com
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131102174922.GD3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101161819.GV16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101161819.GV16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110304-0928-0000-0000-00000333DB7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 05:18:19PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 11:40:15PM -0700, Paul E. McKenney wrote:
> > The dependency you are talking about is via the "if" statement?
> > Even C/C++11 is not required to respect control dependencies.
> > 
> > This one is a bit annoying.  The x86 TSO means that you really only
> > need barrier(), ARM (recent ARM, anyway) and Power could use a weaker
> > barrier, and so on -- but smp_mb() emits a full barrier.
> > 
> > Perhaps a new smp_tmb() for TSO semantics, where reads are ordered
> > before reads, writes before writes, and reads before writes, but not
> > writes before reads?  Another approach would be to define a per-arch
> > barrier for this particular case.
> 
> Supposing a sane language where we can rely on control flow; would that
> change the story?
> 
> I'm afraid I'm now terminally confused between actual proper memory
> model issues and fucked compilers.

Power and ARM won't speculate stores, but they will happily speculate
loads.  Not sure about Itanium, perhaps Tony knows.  And yes, reordering
by the compilers and CPUs does sometimes seem a bit intertwined.

							Thanx, Paul

