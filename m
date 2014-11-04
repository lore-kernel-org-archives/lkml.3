Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaKDXlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:41:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:24818 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751229AbaKDXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:41:09 -0500
Date: Tue, 4 Nov 2014 18:41:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 12/12 v3] x86/nmi: Perform a safe NMI stack trace
 on all CPUs
Message-ID: <20141104184102.4ecb3533@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1411042343130.29198@pobox.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160223.310714394@goodmis.org>
	<alpine.LNX.2.00.1411042343130.29198@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 00:05:12 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 4 Nov 2014, Steven Rostedt wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> > NMI on each CPU and call show_regs(). But this can lead to a hard lock
> > up if the NMI comes in on another printk().
> > 
> > In order to avoid this, when the NMI triggers, it switches the printk
> > routine for that CPU to call a NMI safe printk function that records the
> > printk in a per_cpu seq_buf descriptor. After all NMIs have finished
> > recording its data, the trace_seqs are printed in a safe context.

Hmm, I need to update the change log to say seq_bufs instead of
trace_seqs.

> > 
> > Link: http://lkml.kernel.org/p/20140619213952.360076309@goodmis.org
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> I've been running the whole machinery that used to trigger very quickly 
> the complete hardlock of the machine (*) for the whole evening/night, and 
> it's still running flawlessly.
> 
> Plus, as I said previously, I agree with the whole idea (given the 
> general nastiness of the problem and given the fact this simply has to be 
> fixed without pointless delays).
> 
> I.e FWIW
> 
> 	Tested-by: Jiri Kosina <jkosina@suse.cz>
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> for the whole series.

Thanks! I'll update the commits.

-- Steve

> 
> (*) heavy printk() workload (**) + sysrq-l in parallel
> (**) iptables logging every incoming packet + flood ping from another 
>      machine
> 
> Thanks,
> 

