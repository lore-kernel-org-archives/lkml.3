Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3DXOuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:50:44 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48794 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab3DXOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:50:24 -0400
Date: Wed, 24 Apr 2013 16:50:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux.com>, Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [GIT PULL] nohz: Adaptively stop the tick, finally
Message-ID: <20130424145017.GA6993@somewhere>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
 <20130424073259.GC1780@gmail.com>
 <20130424073852.GA10410@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424073852.GA10410@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 09:38:52AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > One detail: 'make oldconfig' gave me:
> > 
> >  Timer tick handling
> >    1. Periodic timer ticks (constant rate, no dynticks) (HZ_PERIODIC) (NEW)
> >  > 2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
> > 
> > I.e. CONFIG_NO_HZ_IDLE is picked by default. The default should really be 
> > CONFIG_HZ_PERIODIC - so that people can easily enable full dynticks but 
> > are not defaulted into it unknowingly.
> 
> Oh, I got confused by the artificial hiding of NO_HZ_FULL again. Why is it 
> still hidden? I have a fairly generic config, yet it was not offered. I 
> bet most people won't ever see it!
> 
> Sigh, it's due to the dependency mess that I pointed out twice already:
> 
>         depends on TREE_RCU || TREE_PREEMPT_RCU

Ok I just removed this one. This was the same as "depends on SMP" which we already
have.

>         depends on VIRT_CPU_ACCOUNTING_GEN
> 
> It should _really_ select both the RCU and the CPU time accounting model 
> automatically!

Yeah I know. I have yet to fix that in Kconfig (it's a Kconfig limitation).
It's high on my TODO list.

> 
> The selection of the dynticks mode certainly overrides RCU selection, and 
> it should for sure override some arcane, low level detail like the CPU 
> accounting model ...

Agreed, that was not intended to stay as is.

Thanks.
