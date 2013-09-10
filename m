Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3IJWPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:15:10 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:38472 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3IJWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:15:08 -0400
Message-ID: <522F99E8.1040802@gmail.com>
Date: Wed, 11 Sep 2013 00:15:04 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: Jiang Liu <liuj97@gmail.com>, Wang YanQing <udknight@gmail.com>,
        Shaohua Li <shli@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: 3.10.10: WARNING: at kernel/smp.c:181 generic_smp_call_function_single_interrupt+0x11c/0x130()
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I got this stacktrace shortly after bootup. I am disabling the two
hyper-threaded cores in my startup scripts so possibly that was the
trigger, at least per earlier report from Fernando Soto on Jul 08 2013:
  https://lkml.org/lkml/2013/7/8/301

  I don't see his name in this patch series which Google bring to me:

Re: [PATCH v1 2/3] SMP: simpilify function generic_smp_call_function_single_interrupt()

does the patch fix the issue? Are you aware of the issue? That is why
I CCed all of you. ;-) Please, somebody add to Cc: also Fernando, I cannot
find his email address in SPAM-protected email archives. surely you have
his original email in your Inbox or Trash. Thanks.


My stacktrace from 3.10.10 is:

[   22.908990] ------------[ cut here ]------------
[   22.909011] WARNING: at kernel/smp.c:181 generic_smp_call_function_single_interrupt+0x11c/0x130()
[   22.909021] Modules linked in: iwldvm iwlwifi
[   22.909029] CPU: 2 PID: 17 Comm: migration/2 Not tainted 3.10.10-default-pciehp #2
[   22.909032] Hardware name: Dell Inc. Vostro 3550/, BIOS A11 08/03/2012
[   22.909044]  0000000000000009 ffff88019fb03f08 ffffffff817f9734 ffff88019fb03f48
[   22.909054]  ffffffff8109698b ffff8801979adfd8 ffff88019fb13d80 0000000000000004
[   22.909064]  ffff88019fb03f68 ffff88019893bf01 0000000000000000 ffff88019fb03f58
[   22.909066] Call Trace:
[   22.909083]  <IRQ>  [<ffffffff817f9734>] dump_stack+0x19/0x1b
[   22.909093]  [<ffffffff8109698b>] warn_slowpath_common+0x6b/0xa0
[   22.909102]  [<ffffffff810969d5>] warn_slowpath_null+0x15/0x20
[   22.909111]  [<ffffffff810f2e6c>] generic_smp_call_function_single_interrupt+0x11c/0x130
[   22.909120]  [<ffffffff81025772>] smp_call_function_single_interrupt+0x22/0x40
[   22.909131]  [<ffffffff818029ef>] call_function_single_interrupt+0x6f/0x80
[   22.909146]  <EOI>  [<ffffffff810ff5e1>] ? stop_machine_cpu_stop+0xb1/0xf0
[   22.909155]  [<ffffffff810ff530>] ? cpu_stop_queue_work+0xa0/0xa0
[   22.909164]  [<ffffffff810ff6a4>] cpu_stopper_thread+0x84/0x140
[   22.909172]  [<ffffffff810ff8bc>] ? cpu_stop_should_run+0x2c/0x50
[   22.909181]  [<ffffffff81800d2a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[   22.909188]  [<ffffffff810ec1b5>] ? trace_hardirqs_on_caller+0x105/0x1d0
[   22.909193]  [<ffffffff810ec28d>] ? trace_hardirqs_on+0xd/0x10
[   22.909199]  [<ffffffff810c452f>] smpboot_thread_fn+0xff/0x190
[   22.909203]  [<ffffffff810c4430>] ? lg_global_unlock+0x70/0x70
[   22.909207]  [<ffffffff810bcac5>] kthread+0xe5/0xf0
[   22.909212]  [<ffffffff810bc9e0>] ? flush_kthread_worker+0x150/0x150
[   22.909218]  [<ffffffff818018ec>] ret_from_fork+0x7c/0xb0
[   22.909222]  [<ffffffff810bc9e0>] ? flush_kthread_worker+0x150/0x150
[   22.909226] ---[ end trace a42128a3e17e6268 ]---
[   22.909261] smpboot: CPU 2 is now offline
[   23.044977] smpboot: CPU 3 is now offline


Martin
