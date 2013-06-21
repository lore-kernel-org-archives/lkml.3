Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946063Ab3FUVJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:09:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20470 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945954Ab3FUVJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:09:38 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BUyC4VmaGVwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5V7bKCsQ6TsA:10 a=rL20t8O_S21H0ge4yh4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371848976.18733.130.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 21 Jun 2013 17:09:36 -0400
In-Reply-To: <1371835898.18733.122.camel@gandalf.local.home>
References: <1371835898.18733.122.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 13:31 -0400, Steven Rostedt wrote:

> My testing also triggered another bug, but I'm not sure it's related to
> these patches or something that already existed. I'm currently
> investigating it now.


I haven't been able to reproduce it.

Here's the bug I hit while running function tracer on hackbench:

------------[ cut here ]------------
WARNING: at /work/autotest/nobackup/linux-test.git/kernel/fork.c:1196 copy_process+0x2c3/0x1398()
DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled)^M
Modules linked in:
CPU: 1 PID: 4570 Comm: gdm-simple-gree Not tainted 3.10.0-rc3-test+ #5
Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006
 ffffffff81d2a7a5 ffff88006ed13d50 ffffffff8192822b ffff88006ed13d90
 ffffffff81035f25 ffff8800721c6000 ffff88006ed13da0 0000000001200011
 0000000000000000 ffff88006ed5e000 ffff8800721c6000 ffff88006ed13df0
Call Trace:
 [<ffffffff8192822b>] dump_stack+0x19/0x1b
 [<ffffffff81035f25>] warn_slowpath_common+0x67/0x80
 [<ffffffff81035fe1>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff812bfc5d>] ? __raw_spin_lock_init+0x31/0x52
 [<ffffffff810341f7>] copy_process+0x2c3/0x1398^M
 [<ffffffff8103539d>] do_fork+0xa8/0x260
 [<ffffffff810ca7b1>] ? trace_preempt_on+0x2a/0x2f
 [<ffffffff812afb3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81937fe7>] ? sysret_check+0x1b/0x56
 [<ffffffff81937fe7>] ? sysret_check+0x1b/0x56
 [<ffffffff810355cf>] SyS_clone+0x16/0x18
 [<ffffffff81938369>] stub_clone+0x69/0x90
 [<ffffffff81937fc2>] ? system_call_fastpath+0x16/0x1b
---[ end trace 8b157a9d20ca1aa2 ]---


Does that look familiar?

I can send the .config if needed.

-- Steve


