Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3HFEaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:30:52 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44011 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3HFEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:30:50 -0400
MIME-Version: 1.0
Date: Mon, 5 Aug 2013 21:30:49 -0700
Message-ID: <CAHFgRy8V7Zp=CRipj+zVq2O+exxnpMuN0BdKwZXmJ1BeReQFYA@mail.gmail.com>
Subject: 3.11.0-rc4 (Linus GIT) -- WARNING: CPU: 1 PID: 1 at
 kernel/time/tick-sched.c:185 can_stop_full_tick+0x7e/0x89()
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not seeing any problems in the behavior of the computer, but
wonder if this indicates something that needs fixing.

[    1.969109] WARNING: CPU: 1 PID: 1 at kernel/time/tick-sched.c:185
can_stop_full_tick+0x7e/0x89()
[    1.969121] NO_HZ FULL will not work with unstable sched clock
[    1.969129] Modules linked in:
[    1.969142] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc4 #150
[    1.969152] Hardware name: ASUSTeK Computer Inc.         UL50VT
         /UL50VT    , BIOS 217     03/01/2010
[    1.969166]  0000000000000000 ffff88013f303eb0 ffffffff8138347b
ffff88013f303ef8
[    1.969183]  ffff88013f303ee8 ffffffff8103454f ffffffff81079bbf
ffff88013f30d7b0
[    1.969199]  0000000000000001 ffff88013a801dc0 ffff88013a802240
ffff88013f303f48
[    1.969216] Call Trace:
[    1.969222]  <IRQ>  [<ffffffff8138347b>] dump_stack+0x4e/0x82
[    1.969241]  [<ffffffff8103454f>] warn_slowpath_common+0x75/0x8e
[    1.969253]  [<ffffffff81079bbf>] ? can_stop_full_tick+0x7e/0x89
[    1.969265]  [<ffffffff810345af>] warn_slowpath_fmt+0x47/0x49
[    1.969278]  [<ffffffff81079bbf>] can_stop_full_tick+0x7e/0x89
[    1.969290]  [<ffffffff8107a046>] tick_nohz_irq_exit+0x63/0x7f
[    1.969302]  [<ffffffff810384ec>] irq_exit+0xa4/0xac
[    1.969314]  [<ffffffff810239e8>] smp_apic_timer_interrupt+0x30/0x3c
[    1.969327]  [<ffffffff8138ef6f>] apic_timer_interrupt+0x6f/0x80
[    1.969336]  <EOI>  [<ffffffff8100c676>] ? save_stack_trace+0x26/0x41
[    1.969355]  [<ffffffff813893cd>] ? _raw_spin_unlock_irqrestore+0x3c/0x69
[    1.969369]  [<ffffffff813810fb>] __slab_free+0x53/0x317
[    1.969382]  [<ffffffff811f08c6>] ? debug_check_no_obj_freed+0x103/0x153
[    1.969397]  [<ffffffff810eb271>] kfree+0x102/0x111
[    1.969410]  [<ffffffff81237171>] ? acpi_ns_get_node+0xb6/0xc6
[    1.969422]  [<ffffffff81237171>] acpi_ns_get_node+0xb6/0xc6
[    1.969434]  [<ffffffff813893ec>] ? _raw_spin_unlock_irqrestore+0x5b/0x69
[    1.969447]  [<ffffffff81053a3a>] ? up+0x34/0x39
[    1.969459]  [<ffffffff812198d2>] ? acpi_os_signal_semaphore+0x1c/0x28
[    1.969472]  [<ffffffff81237aa0>] acpi_get_handle+0x7e/0x92
[    1.969486]  [<ffffffff816aa050>] pnpacpi_add_device_handler+0x57/0x217
[    1.969499]  [<ffffffff812378ca>] acpi_ns_get_device_callback+0x135/0x14b
[    1.969511]  [<ffffffff81053a3a>] ? up+0x34/0x39
[    1.969523]  [<ffffffff8123728f>] acpi_ns_walk_namespace+0xc3/0x17a
[    1.969535]  [<ffffffff81237795>] ? acpi_walk_namespace+0xc0/0xc0
[    1.969547]  [<ffffffff812376c0>] acpi_get_devices+0x5d/0x72
[    1.969560]  [<ffffffff816a9ff9>] ? ispnpidacpi+0x84/0x84
[    1.969571]  [<ffffffff816aa210>] ? pnpacpi_add_device_handler+0x217/0x217
[    1.969584]  [<ffffffff816aa26e>] pnpacpi_init+0x5e/0x8c
[    1.969596]  [<ffffffff81000276>] do_one_initcall+0x8e/0x12b
[    1.969608]  [<ffffffff8104d796>] ? parameq+0x1d/0x1f
[    1.969619]  [<ffffffff8104d924>] ? parse_args+0x18c/0x23f
[    1.969632]  [<ffffffff81684dd4>] kernel_init_freeable+0x115/0x196
[    1.969643]  [<ffffffff816846b4>] ? do_early_param+0x88/0x88
[    1.969654]  [<ffffffff81379a6d>] ? rest_init+0x131/0x131
[    1.969665]  [<ffffffff81379a76>] kernel_init+0x9/0xd1
[    1.969676]  [<ffffffff8138e26c>] ret_from_fork+0x7c/0xb0
[    1.969687]  [<ffffffff81379a6d>] ? rest_init+0x131/0x131
