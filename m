Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3DYG2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:28:36 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55868 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYG2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:28:35 -0400
Date: Thu, 25 Apr 2013 08:28:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20130425062830.GA15989@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
 <20130424073259.GC1780@gmail.com>
 <20130424073852.GA10410@gmail.com>
 <20130424145017.GA6993@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424145017.GA6993@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >         depends on VIRT_CPU_ACCOUNTING_GEN
> > 
> > It should _really_ select both the RCU and the CPU time accounting model 
> > automatically!
> 
> Yeah I know. I have yet to fix that in Kconfig (it's a Kconfig limitation).

Why cannot we simply select it and its dependencies, explicitly, for the 
time being? Something like:

	depends on 64BIT
	select VIRT_CPU_ACCOUNTING
	select VIRT_CPU_ACCOUNTING_GEN

90% of the .config's have VIRT_CPU_ACCOUNTING_GEN turned off, because it's 
a default-off feature - so dynticks-full is effectively hidden from the 
large majority of testers...

Thanks,

	Ingo
