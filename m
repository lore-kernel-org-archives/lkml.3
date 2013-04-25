Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3DYNlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:41:08 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52214 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3DYNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:41:06 -0400
Date: Thu, 25 Apr 2013 15:41:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: Kconfig doesn't support select on choices (was Re: [GIT PULL]
 nohz: Adaptively stop the tick, finally)
Message-ID: <20130425134101.GA16609@gmail.com>
References: <CAFTL4hxzpoy1wwmenhPaEg9tovfrXeMQ5QBC5gkW0L3z86VPAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxzpoy1wwmenhPaEg9tovfrXeMQ5QBC5gkW0L3z86VPAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/4/25 Ingo Molnar <mingo@kernel.org>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> >         depends on VIRT_CPU_ACCOUNTING_GEN
> >> >
> >> > It should _really_ select both the RCU and the CPU time accounting model
> >> > automatically!
> >>
> >> Yeah I know. I have yet to fix that in Kconfig (it's a Kconfig limitation).
> >
> > Why cannot we simply select it and its dependencies, explicitly, for the
> > time being? Something like:
> >
> >         depends on 64BIT
> >         select VIRT_CPU_ACCOUNTING
> >         select VIRT_CPU_ACCOUNTING_GEN
> >
> > 90% of the .config's have VIRT_CPU_ACCOUNTING_GEN turned off, because it's
> > a default-off feature - so dynticks-full is effectively hidden from the
> > large majority of testers...
> 
> Whatever we do, it seems that select does not work with choices.
> 
> Michal, we are running into an issue where a Kconfig option needs to 
> select CONFIG_VIRT_CPU_ACCOUNTING_GEN but this latter option is part of 
> a choice menu so it doesn't work. As a result we are forced to use a 
> "depends on" and this hides the high level option we are interested in 
> (here full dynticks) behind its low level dependency. How hard do you 
> think it would be to fix this? I tried something that worked half-way 
> but I quickly got lost in the Kconfig maze.

While it's not an ideal solution, we could try to create three bools out 
of the choice options, as a workaround?

Thanks,

	Ingo
