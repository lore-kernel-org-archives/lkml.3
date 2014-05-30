Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaE3NLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:11:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21460 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE3NLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:11:52 -0400
Message-ID: <5388838B.8070802@oracle.com>
Date: Fri, 30 May 2014 09:11:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, pmladek@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: console: lockup on boot
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I sometime see lockups when booting my KVM guest with the latest -next kernel,
it basically hangs right when it should start 'init', and after a while I get
the following spew:

[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[   30.770667] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[   30.770667] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.541585] kworker/dying (172) used greatest stack depth: 3656 bytes left
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.010589] INFO: task swapper/0:1 blocked for more than 200 seconds.
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] general protection fault: 0000 [#1]
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[ 2950.759251] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3109.224481] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3251.771402] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3401.522129] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3568.564422] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3754.638392] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 3941.597288] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 4114.243312] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 4287.428963] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  320.551104] BUG: spinlock lockup suspected on CPU#33, kworker/dying/172
[ 4458.566115] BUG: spinlock lockup suspected on CPU#32, swapper/32/0
[  408.020558] BUG: spinlock lockup suspected on CPU#43, khungtaskd/3760
[   30.790833] PANIC: double fault, error_code: 0x0
[  320.551104]  lock: console_sem+0x0/0x60, .magic: dead4ead, .owner: kworker/u101:1/484, .owner_cpu: -1
[  408.020558]  lock: console_sem+0x0/0x60, .magic: dead4ead, .owner: kworker/u101:1/484, .owner_cpu: 33
[  321.761422]  lock: console_sem+0x0/0x60, .magic: dead4ead, .owner: kworker/u101:1/484, .owner_cpu: -1
[  320.551104] CPU: 33 PID: 172 Comm: kworker/dying Tainted: G        W     3.15.0-rc7-next-20140529-sasha-00017-gd239c90-dirty #550
[  320.551104]  ffffffff8e087060 ffff88012a800b38 ffffffff8c4e92e3 0000000000000001
[   30.790833]  ffff88007bdd3000
[   30.790833] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W     3.15.0-rc7-next-20140529-sasha-00017-gd239c90-dirty #550
[   30.790833]  ffff88012a800b58
[   30.790833] task: ffff880a2b3f0000 ti: ffff88007c1d0000 task.ti: ffff88007c1d0000
[   30.790833]  ffffffff8c4dc9fe
[  320.551104] RIP:  (??:?)
[  320.551104]  ffffffff8e087060
[   30.790833]  0000000086c41770
[   30.790833] string.isra.5 (lib/vsprintf.c:506)
[   30.790833]  ffff88012a800b88
[   30.790833] RSP: 0000:ffff88012ba00000  EFLAGS: 00010092
[   30.790833]  ffffffff891d08b4
[   30.790833] RAX: ffffffff8d6ee711 RBX: ffffffff906949f0 RCX: 0000000000000000
[   30.790833]  ffffffff8e087078
[   30.790833] RDX: ffffffff8d6eb246 RSI: ffffffffffffffff RDI: ffffffff906949f0
[  320.551104]
[   30.790833] RBP: ffff88012ba00018 R08: 000000000000ffff R09: 000000000000ffff
[  320.551104] Call Trace:
[   30.790833] R10: 73203a4755423001 R11: 206b636f6c6e6970 R12: ffffffff90694dc0
[   30.790833] R13: ffffffff90694dc0 R14: 000000000000ffff R15: 0000000000000000
[   30.790833]  <UNK>
[   30.790833] FS:  0000000000000000(0000) GS:ffff88012ba00000(0000) knlGS:0000000000000000
[  321.761422] CPU: 0 PID: 484 Comm: kworker/u101:1 Tainted: G        W     3.15.0-rc7-next-20140529-sasha-00017-gd239c90-dirty #550
[   30.790833] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  320.551104] sending NMI to all CPUs:
[   30.790833] CR2: ffff88012b9ffff8 CR3: 000000000e02c000 CR4: 00000000000006a0
[  321.761422] BUG: spinlock lockup suspected on CPU#0, kworker/u101:1/484
[  321.761422]  lock: logbuf_lock+0x0/0x48, .magic: dead4ead, .owner: kworker/u101:1/484, .owner_cpu: -1
[  321.761422] CPU: 0 PID: 484 Comm: kworker/u101:1 Tainted: G        W     3.15.0-rc7-next-20140529-sasha-00017-gd239c90-dirty #550
[  321.761422] Workqueue: events_power_efficient fb_flashcursor
[  321.761422]  ffffffff8e087000 ffff88007da06c78 ffffffff8c4e92e3 0000000000000000
[  321.761422]  ffff88007bdd3000 ffff88007da06c98 ffffffff8c4dc9fe ffffffff8e087000
[  321.761422]  0000000086c41770 ffff88007da06cc8 ffffffff891d08b4 ffffffff8e087018
[  321.761422] Call Trace:
[  321.761422] <NMI> dump_stack (lib/dump_stack.c:52)
[  321.761422] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 6))
[  321.761422] do_raw_spin_lock (include/linux/nmi.h:35 kernel/locking/spinlock_debug.c:119 kernel/locking/spinlock_debug.c:137)
[  321.761422] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  321.761422] ? vprintk_emit (kernel/printk/printk.c:1620)
[  321.761422] vprintk_emit (kernel/printk/printk.c:1620)
[  321.761422] printk (kernel/printk/printk.c:1806)
[  321.761422] arch_trigger_all_cpu_backtrace_handler (arch/x86/kernel/apic/hw_nmi.c:85)
[  321.761422] nmi_handle (arch/x86/kernel/nmi.c:133)
[  321.761422] ? nmi_handle (arch/x86/kernel/nmi.c:114)
[  321.761422] default_do_nmi (arch/x86/kernel/nmi.c:336)
[  321.761422] ? get_color.isra.12 (drivers/video/console/fbcon.c:369)
[  321.761422] do_nmi (./arch/x86/include/asm/current.h:14 arch/x86/kernel/nmi.c:540)
[  321.761422] end_repeat_nmi (arch/x86/kernel/entry_64.S:1701)
[  321.761422] ? get_color.isra.12 (drivers/video/console/fbcon.c:369)
[  321.761422] ? get_color.isra.12 (drivers/video/console/fbcon.c:369)
[  321.761422] ? get_symbol_pos (kernel/kallsyms.c:230)
[  321.761422] ? get_symbol_pos (kernel/kallsyms.c:230)
[  321.761422] ? get_symbol_pos (kernel/kallsyms.c:230)
[  321.761422]  <<EOE>>  <UNK>
[  321.761422] NMI backtrace for cpu 0
[  321.761422] CPU: 0 PID: 484 Comm: kworker/u101:1 Tainted: G        W     3.15.0-rc7-next-20140529-sasha-00017-gd239c90-dirty #550
[  321.761422] Workqueue: events_power_efficient fb_flashcursor
[  321.761422] task: ffff88007bdd3000 ti: ffff88007bde8000 task.ti: ffff88007bde8000
[  321.761422] RIP: get_symbol_pos (kernel/kallsyms.c:230)
[  321.761422] RSP: 0000:ffff88007bde5c78  EFLAGS: 00000006
[  321.761422] RAX: 0000000000008c7c RBX: ffff88007bde5cd0 RCX: 0000000000009831
[  321.761422] RDX: ffff88007bde5cd8 RSI: ffff88007bde5ce0 RDI: ffffffff89bba9c0
[  321.761422] RBP: ffff88007bde5c78 R08: 000000000000a3e6 R09: 000000000000ffff
[  321.761422] R10: 000000000005da8d R11: 3a6d6d6f43203438 R12: ffff88007bde5d41
[  321.761422] R13: ffffffff89bba9c0 R14: 0000000000000000 R15: ffffffff8d6e8c47
[  321.761422] FS:  0000000000000000(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
[  321.761422] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  321.761422] CR2: 00000000ffffffff CR3: 000000000e02c000 CR4: 00000000000006b0
[  321.761422] Stack:
[  321.761422]  ffff88007bde5cb8 ffffffff8920eb4e 70202c786c383025 ffff88007bde5e31
[  321.761422]  ffff8800fbde5e2b ffff88007bde5d41 ffffffff89bba9c0 0000000000000000
[  321.761422]  ffff88007bde5d08 ffffffff8920ec42 522829676e6fffff 296e656c3e2d4345
[  321.761422] Call Trace:
[  321.761422]  <UNK>
[ 321.761422] Code: 30 0e f7 8c 55 48 85 c0 48 89 e5 75 02 0f 0b 4c 8b 15 ca fc 04 04 31 c0 4d 89 d0 eb 16 48 d1 e9 48 01 c1 48 39 3c cd 30 0e f7 8c <4c> 0f 47 c1 48 0f 46 c1 4c 89 c1 48 29 c1 48 83 f9 01 77 de 48
All code
========
   0:	30 0e                	xor    %cl,(%rsi)
   2:	f7                   	(bad)
   3:	8c 55 48             	mov    %ss,0x48(%rbp)
   6:	85 c0                	test   %eax,%eax
   8:	48 89 e5             	mov    %rsp,%rbp
   b:	75 02                	jne    0xf
   d:	0f 0b                	ud2
   f:	4c 8b 15 ca fc 04 04 	mov    0x404fcca(%rip),%r10        # 0x404fce0
  16:	31 c0                	xor    %eax,%eax
  18:	4d 89 d0             	mov    %r10,%r8
  1b:	eb 16                	jmp    0x33
  1d:	48 d1 e9             	shr    %rcx
  20:	48 01 c1             	add    %rax,%rcx
  23:	48 39 3c cd 30 0e f7 	cmp    %rdi,-0x7308f1d0(,%rcx,8)
  2a:	8c
  2b:*	4c 0f 47 c1          	cmova  %rcx,%r8		<-- trapping instruction
  2f:	48 0f 46 c1          	cmovbe %rcx,%rax
  33:	4c 89 c1             	mov    %r8,%rcx
  36:	48 29 c1             	sub    %rax,%rcx
  39:	48 83 f9 01          	cmp    $0x1,%rcx
  3d:	77 de                	ja     0x1d
  3f:	48                   	rex.W
	...

Code starting with the faulting instruction
===========================================
   0:	4c 0f 47 c1          	cmova  %rcx,%r8
   4:	48 0f 46 c1          	cmovbe %rcx,%rax
   8:	4c 89 c1             	mov    %r8,%rcx
   b:	48 29 c1             	sub    %rax,%rcx
   e:	48 83 f9 01          	cmp    $0x1,%rcx
  12:	77 de                	ja     0xfffffffffffffff2
  14:	48                   	rex.W
	...
[   30.790833] NMI backtrace for cpu 1
[hang]


Thanks,
Sasha
