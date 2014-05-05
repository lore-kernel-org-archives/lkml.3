Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaEERH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:07:26 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:56733 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaEERHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:07:24 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 5 May 2014 13:10:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu> <20140502162234.GX11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu> <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Vince Weaver wrote:

> (Although often things like to crash the instant my tested-by e-mails 
> clear the lkml list.)

This did turn up on the core2 machine.  I had been seeing this problem 
earlier but was hoping it was part of the memory corruption issue:

[ 4918.921921] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 4918.925692] IP: [<ffffffff81539fa6>] mutex_lock+0x19/0x37
[ 4918.925692] PGD c5e62067 PUD cae00067 PMD 0 
[ 4918.925692] Oops: 0002 [#1] SMP 
[ 4918.925692] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet ohci_pci evdev ohci_hcd acpi_cpufreq coretemp psmouse serio_raw pcspkr video wmi i2c_nforce2 button processor thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[ 4918.925692] CPU: 0 PID: 9777 Comm: perf_fuzzer Not tainted 3.15.0-rc4+ #42
[ 4918.925692] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[ 4918.925692] task: ffff8800c628e800 ti: ffff8800c6610000 task.ti: ffff8800c6610000
[ 4918.925692] RIP: 0010:[<ffffffff81539fa6>]  [<ffffffff81539fa6>] mutex_lock+0x19/0x37
[ 4918.925692] RSP: 0018:ffff8800c6611d30  EFLAGS: 00010286
[ 4918.925692] RAX: 0000000000000000 RBX: 0000000000000010 RCX: ffff8800c9b89080
[ 4918.925692] RDX: 0000000080000000 RSI: 0000000000000286 RDI: 0000000000000010
[ 4918.925692] RBP: ffff8800c6611d50 R08: 0000000000000001 R09: ffff8800c5b41f00
[ 4918.925692] R10: ffff8800cb217400 R11: ffff8800caf03400 R12: ffff8800c628e800
[ 4918.925692] R13: ffff8800c628e800 R14: 0000000000000001 R15: 0000000000000038
[ 4918.925692] FS:  00007f8700f46700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[ 4918.925692] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4918.925692] CR2: 0000000000000010 CR3: 00000000c974d000 CR4: 00000000000407f0
[ 4918.925692] DR0: 0000000000a80000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4918.925692] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 4918.925692] Stack:
[ 4918.925692]  ffff880119c62010 ffff8800c628e800 ffff8800c628e800 0000000000000000
[ 4918.925692]  ffff8800c6611dc0 ffffffff810d10b7 ffff8800c5b41f48 0000000000000010
[ 4918.925692]  ffff880119c62010 0000000000000286 0000000000000286 0000000119c62010
[ 4918.925692] Call Trace:
[ 4918.925692]  [<ffffffff810d10b7>] perf_event_init_context+0x7c/0x1c8
[ 4918.925692]  [<ffffffff810d126c>] perf_event_init_task+0x69/0x6d
[ 4918.925692]  [<ffffffff8103e1ff>] copy_process+0x5cc/0x163b
[ 4918.925692]  [<ffffffff8112a044>] ? __d_free+0x53/0x58
[ 4918.925692]  [<ffffffff8112a6ab>] ? dentry_kill+0x1b8/0x1d5
[ 4918.925692]  [<ffffffff81130d9d>] ? mntput+0x2a/0x2c
[ 4918.925692]  [<ffffffff811193af>] ? __fput+0x17e/0x18d
[ 4918.925692]  [<ffffffff8103f536>] do_fork+0x74/0x1dc
[ 4918.925692]  [<ffffffff8111943a>] ? ____fput+0xe/0x10
[ 4918.925692]  [<ffffffff81058960>] ? task_work_run+0x8d/0xa0
[ 4918.925692]  [<ffffffff8103f6b4>] SyS_clone+0x16/0x18
[ 4918.925692]  [<ffffffff81542c89>] stub_clone+0x69/0x90
[ 4918.925692]  [<ffffffff815429e6>] ? system_call_fastpath+0x1a/0x1f
[ 4918.925692] Code: 48 8b 04 25 00 b9 00 00 b2 01 48 89 47 18 89 d0 c9 c3 55 48 89 e5 53 48 83 ec 18 66 66 66 66 90 48 89 fb e8 d7 f6 ff ff 48 89 df <f0> ff 0f 79 05 e8 7a 05 00 00 65 48 8b 04 25 00 b9 00 00 48 89 
[ 4918.925692] RIP  [<ffffffff81539fa6>] mutex_lock+0x19/0x37
[ 4918.925692]  RSP <ffff8800c6611d30>
[ 4918.925692] CR2: 0000000000000010
[ 4919.771050] ---[ end trace 9a98d4ca40642975 ]---

