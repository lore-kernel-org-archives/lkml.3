Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaDXEGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:06:37 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33511 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaDXEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:06:35 -0400
Message-ID: <1398312391.5415.16.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Thu, 24 Apr 2014 06:06:31 +0200
In-Reply-To: <20140411185739.GA6644@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turning lockdep on, it says it's busted.

(I'll go stare at it, maybe the beast will blink first for a change)

[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e710f>] locking_selftest+0xdf/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e719e>] locking_selftest+0x16e/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e722d>] locking_selftest+0x1fd/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e72bc>] locking_selftest+0x28c/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e734b>] locking_selftest+0x31b/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e73da>] locking_selftest+0x3aa/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e7469>] locking_selftest+0x439/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/sched/core.c:2660 migrate_disable+0xbd/0xd0()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000a64 ffffffff81a01d38 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000000 ffffffff81a01d78 ffffffff8104f0cc ffffffff81a01d78
[    0.000000]  ffffffff81a194c0 0000000000000027 0000000000000006 0000000000000001
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff8104f0cc>] warn_slowpath_common+0x8c/0xc0
[    0.000000]  [<ffffffff8104f11a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8108795d>] migrate_disable+0xbd/0xd0
[    0.000000]  [<ffffffff810b7a7f>] call_console_drivers.constprop.20+0x4f/0x140
[    0.000000]  [<ffffffff810b823f>] console_unlock.part.15+0x1df/0x2e0
[    0.000000]  [<ffffffff815ec835>] ? _raw_spin_unlock+0x35/0x60
[    0.000000]  [<ffffffff810b8358>] console_unlock+0x18/0x30
[    0.000000]  [<ffffffff810b8771>] vprintk_emit+0x231/0x400
[    0.000000]  [<ffffffff815e9aca>] ? preempt_schedule+0x4a/0x70
[    0.000000]  [<ffffffff812e1320>] ? bad_unlock_order_spin+0x40/0x40
[    0.000000]  [<ffffffff815d8519>] printk+0x4d/0x4f
[    0.000000]  [<ffffffff815f11d9>] ? preempt_count_sub+0x29/0x70
[    0.000000]  [<ffffffff812e1348>] ? double_unlock_spin+0x28/0x30
[    0.000000]  [<ffffffff815e1dc8>] dotest+0x75/0xc7
[    0.000000]  [<ffffffff812e74cf>] locking_selftest+0x49f/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000] ---[ end trace 0000000000000001 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/sched/core.c:2693 migrate_enable+0xf6/0x1a0()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000a85 ffffffff81a01cb8 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000000 ffffffff81a01cf8 ffffffff8104f0cc ffffffff81a01d18
[    0.000000]  ffffffff81a194c0 0000000000000000 000000000000000a ffffffff8275f367
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff8104f0cc>] warn_slowpath_common+0x8c/0xc0
[    0.000000]  [<ffffffff8104f11a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff810877f6>] migrate_enable+0xf6/0x1a0
[    0.000000]  [<ffffffff813aab31>] vt_console_print+0x2f1/0x3d0
[    0.000000]  [<ffffffff810b7ae7>] call_console_drivers.constprop.20+0xb7/0x140
[    0.000000]  [<ffffffff810b823f>] console_unlock.part.15+0x1df/0x2e0
[    0.000000]  [<ffffffff815ec835>] ? _raw_spin_unlock+0x35/0x60
[    0.000000]  [<ffffffff810b8358>] console_unlock+0x18/0x30
[    0.000000]  [<ffffffff810b8771>] vprintk_emit+0x231/0x400
[    0.000000]  [<ffffffff815e9aca>] ? preempt_schedule+0x4a/0x70
[    0.000000]  [<ffffffff812e1320>] ? bad_unlock_order_spin+0x40/0x40
[    0.000000]  [<ffffffff815d8519>] printk+0x4d/0x4f
[    0.000000]  [<ffffffff815f11d9>] ? preempt_count_sub+0x29/0x70
[    0.000000]  [<ffffffff812e1348>] ? double_unlock_spin+0x28/0x30
[    0.000000]  [<ffffffff815e1dc8>] dotest+0x75/0xc7
[    0.000000]  [<ffffffff812e74cf>] locking_selftest+0x49f/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000] ---[ end trace 0000000000000002 ]---
[    0.000000]   ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 0000000000000046
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e74f5>] locking_selftest+0x4c5/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]   ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000008 ffffffff81a01f28 ffffffff815e12a5 0000000000000046
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e752e>] locking_selftest+0x4fe/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000] 
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000008 ffffffff81a01f28 ffffffff815e12a5 0000000000000006
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e76c5>] locking_selftest+0x695/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000] 
[    0.000000]            recursive read-lock #2:             |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.1-rt1 #16
[    0.000000] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[    0.000000]  0000000000000002 ffffffff81a01f28 ffffffff815e12a5 ffffffff810b7727
[    0.000000]  0000000000000001 ffffffff81a01f58 ffffffff815e1db2 0000000000000000
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffffffff81a01f68
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff815e12a5>] dump_stack+0x4f/0x7c
[    0.000000]  [<ffffffff810b7727>] ? console_trylock_for_printk+0x37/0xf0
[    0.000000]  [<ffffffff815e1db2>] dotest+0x5f/0xc7
[    0.000000]  [<ffffffff812e7703>] locking_selftest+0x6d3/0xb30
[    0.000000]  [<ffffffff81d51d8f>] start_kernel+0x215/0x327
[    0.000000]  [<ffffffff81d51a0c>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81d9f4c1>] ? memblock_reserve+0x49/0x4e
[    0.000000]  [<ffffffff81d515b2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d516a4>] x86_64_start_kernel+0xf0/0xf7
[    0.000000]              |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -----------------------------------------------------------------
[    0.000000] BUG:  11 unexpected failures (out of 119) - debugging disabled! |
[    0.000000] -----------------------------------------------------------------


