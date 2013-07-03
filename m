Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3GCLqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:46:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3GCLqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:46:09 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=938I8qm67NgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A_1Y_ByquugA:10 a=D19gQVrFAAAA:8 a=WPEV3b9g5bf_FnBVzCIA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372851967.22688.98.camel@gandalf.local.home>
Subject: Re: arch/x86/include/asm/trace/irq_vectors.h:50 suspicious
 rcu_dereference_check() usage!
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Seiji Aguchi <saguchi@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 03 Jul 2013 07:46:07 -0400
In-Reply-To: <20130703052801.GA2591@redhat.com>
References: <20130703052801.GA2591@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 01:28 -0400, Dave Jones wrote:
> [ 3206.433900] ===============================
> [ 3206.434449] [ INFO: suspicious RCU usage. ]
> [ 3206.434999] 3.10.0+ #40 Not tainted
> [ 3206.435468] -------------------------------
> [ 3206.436018] /home/davej/src/linux-dj/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
> [ 3206.437383] 
> other info that might help us debug this:
> 

This has been fixed by Seiji and sent to Ingo:

https://lkml.org/lkml/2013/6/28/459

Ingo or Peter, can you pull in his patch.

Thanks,

-- Steve

> [ 3206.438388] 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> [ 3206.439733] RCU used illegally from extended quiescent state!
> [ 3206.440474] no locks held by trinity-child1/31470.
> [ 3206.441096] 
> stack backtrace:
> [ 3206.441667] CPU: 3 PID: 31470 Comm: trinity-child1 Not tainted 3.10.0+ #40
> [ 3206.445412]  0000000000000000 ffff880244e03f60 ffffffff816ec1a2 ffff880244e03f90
> [ 3206.447288]  ffffffff810b8b07 ffff88022e069890 ffff880207809f58 0000000000000006
> [ 3206.449335]  0000003e127b97d8 ffff880244e03fa8 ffffffff8102629e 0000000000000282
> [ 3206.451405] Call Trace:
> [ 3206.452676]  <IRQ>  [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
> [ 3206.454390]  [<ffffffff810b8b07>] lockdep_rcu_suspicious+0xe7/0x120
> [ 3206.456086]  [<ffffffff8102629e>] smp_trace_reschedule_interrupt+0x17e/0x290
> [ 3206.457876]  [<ffffffff8170022f>] trace_reschedule_interrupt+0x6f/0x80
> [ 3206.459593]  <EOI>  [<ffffffff8114a847>] ? user_enter+0x87/0xd0
> [ 3206.461279]  [<ffffffff816fa6c5>] do_page_fault+0x45/0x50
> [ 3206.462872]  [<ffffffff816f6fe2>] page_fault+0x22/0x30


