Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBGOIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:08:38 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36717 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaBGOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:08:36 -0500
MIME-Version: 1.0
Date: Fri, 7 Feb 2014 19:38:35 +0530
Message-ID: <CAAH=MDxg22r78x0szzr_gjqxgfL5ZCGehRxSqAmNcfxiP390QA@mail.gmail.com>
Subject: [Ftrace][Bug] Failed on adding breakpoints, when used with kgdboc
From: yogesh tillu <tillu.yogesh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue: [On x86 64 bit setup] If we enable CONFIG_FTRACE_STARTUP_TEST,
and set software breakpoint(from kgdboc) result into below mentioned
oops and non working of kgdb software breakpoint.

[  347.686031] ------------[ cut here ]------------
[  348.728729] WARNING: at kernel/trace/ftrace.c:1688 ftrace_bug+0x209/0x250()
[  348.787984] Modules linked in:
[  348.894035] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W
3.10.26.x86-generic-64-rt22 #17
[  348.955562] Hardware name: Intel Corporation
BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
[  349.021339]  ffff88013acbbd10 ffff88013acbbd18 ffffffff8180b2b4
ffff88013acbbd58
[  349.021353]  ffffffff81041fc0 ffffffff819e376d ffffffff81816360
ffffffff819cc2ee
[  349.021367]  0000000000007240 ffffffff81db3880 ffffffff8181a050
ffff88013acbbd68
[  349.200624] Call Trace:
[  349.254776]  [<ffffffff8180b2b4>] dump_stack+0x19/0x1b
[  349.254789]  [<ffffffff81041fc0>] warn_slowpath_common+0x70/0xa0
[  349.254800]  [<ffffffff81816360>] ? __do_page_fault+0x4e0/0x4e0
[  349.254816]  [<ffffffff8181a050>] ? __fentry__+0x10/0x10
[  349.254828]  [<ffffffff8104200a>] warn_slowpath_null+0x1a/0x20
[  349.254839]  [<ffffffff810e19e9>] ftrace_bug+0x209/0x250
[  349.254854]  [<ffffffff8102c99c>] ftrace_replace_code+0x2bc/0x460
[  349.254882]  [<ffffffff810e244a>] ftrace_modify_all_code+0x7a/0xb0
[  349.254896]  [<ffffffff8102cb50>] arch_ftrace_update_code+0x10/0x20
[  349.254908]  [<ffffffff810e24e2>] ftrace_run_update_code+0x22/0x80
[  349.254922]  [<ffffffff810e2579>] ftrace_startup_enable+0x39/0x50
[  349.254934]  [<ffffffff810e2ac0>] ftrace_startup+0xc0/0x260
[  349.254952]  [<ffffffff810e2c8d>] register_ftrace_function+0x2d/0x50
[  349.254964]  [<ffffffff81c1349f>] ? event_trace_self_tests+0x2e7/0x2e7
[  349.254976]  [<ffffffff81c134bd>] event_trace_self_tests_init+0x1e/0x69
[  349.254988]  [<ffffffff81000362>] do_one_initcall+0x102/0x130
[  349.255010]  [<ffffffff81bf6018>] kernel_init_freeable+0x18b/0x225
[  349.255021]  [<ffffffff81bf5866>] ? do_early_param+0x87/0x87
[  349.255032]  [<ffffffff817f76a0>] ? rest_init+0x90/0x90
[  349.255048]  [<ffffffff817f76ae>] kernel_init+0xe/0xf0
[  349.255060]  [<ffffffff8181a3d2>] ret_from_fork+0x72/0xa0
[  349.255078]  [<ffffffff817f76a0>] ? rest_init+0x90/0x90
[  349.255107] ---[ end trace 0000000000000002 ]---
[  350.585736] ftrace failed to modify [<ffffffff81816360>]
do_page_fault+0x0/0x10
[  350.696684]  actual: cc:1f:44:00:00
[  351.059427] Failed on adding breakpoints (29248):


Setup Details

a) System details
X86 64 bit
kernel version: 3.10.26

b) Configuration
FTRACE & KGDB is enabled
- using kgdb over console ( KGDBOC )

c) Steps to reproduce
Boot kernel, it will wait for kgdboc to connect
start gdb, connect to target and set breakpoint with break command,
and continue.
Kernel will boot with above mentions oops, resulting gdb to wait
forever for breakpoint.

d) Observation: If we disable CONFIG_FTRACE_STARTUP_TEST,
breakpoint(kgdboc) is working fine.

Could you please let me know if anyone came accross this issue ?

-- 
Thanks,
Yogesh
