Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3DXHi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:38:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60699 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab3DXHi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:38:57 -0400
Date: Wed, 24 Apr 2013 09:38:52 +0200
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
Message-ID: <20130424073852.GA10410@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
 <20130424073259.GC1780@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424073259.GC1780@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> One detail: 'make oldconfig' gave me:
> 
>  Timer tick handling
>    1. Periodic timer ticks (constant rate, no dynticks) (HZ_PERIODIC) (NEW)
>  > 2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
> 
> I.e. CONFIG_NO_HZ_IDLE is picked by default. The default should really be 
> CONFIG_HZ_PERIODIC - so that people can easily enable full dynticks but 
> are not defaulted into it unknowingly.

Oh, I got confused by the artificial hiding of NO_HZ_FULL again. Why is it 
still hidden? I have a fairly generic config, yet it was not offered. I 
bet most people won't ever see it!

Sigh, it's due to the dependency mess that I pointed out twice already:

        depends on TREE_RCU || TREE_PREEMPT_RCU
        depends on VIRT_CPU_ACCOUNTING_GEN

It should _really_ select both the RCU and the CPU time accounting model 
automatically!

The selection of the dynticks mode certainly overrides RCU selection, and 
it should for sure override some arcane, low level detail like the CPU 
accounting model ...

Thanks,

	Ingo
