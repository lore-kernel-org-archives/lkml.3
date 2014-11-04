Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaKDXFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:05:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaKDXFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:05:14 -0500
Date: Wed, 5 Nov 2014 00:05:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 12/12 v3] x86/nmi: Perform a safe NMI stack trace
 on all CPUs
In-Reply-To: <20141104160223.310714394@goodmis.org>
Message-ID: <alpine.LNX.2.00.1411042343130.29198@pobox.suse.cz>
References: <20141104155237.228431433@goodmis.org> <20141104160223.310714394@goodmis.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Steven Rostedt wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> NMI on each CPU and call show_regs(). But this can lead to a hard lock
> up if the NMI comes in on another printk().
> 
> In order to avoid this, when the NMI triggers, it switches the printk
> routine for that CPU to call a NMI safe printk function that records the
> printk in a per_cpu seq_buf descriptor. After all NMIs have finished
> recording its data, the trace_seqs are printed in a safe context.
> 
> Link: http://lkml.kernel.org/p/20140619213952.360076309@goodmis.org
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I've been running the whole machinery that used to trigger very quickly 
the complete hardlock of the machine (*) for the whole evening/night, and 
it's still running flawlessly.

Plus, as I said previously, I agree with the whole idea (given the 
general nastiness of the problem and given the fact this simply has to be 
fixed without pointless delays).

I.e FWIW

	Tested-by: Jiri Kosina <jkosina@suse.cz>
	Acked-by: Jiri Kosina <jkosina@suse.cz>

for the whole series.

(*) heavy printk() workload (**) + sysrq-l in parallel
(**) iptables logging every incoming packet + flood ping from another 
     machine

Thanks,

-- 
Jiri Kosina
SUSE Labs
