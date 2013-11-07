Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3KGWho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:37:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3KGWhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:37:36 -0500
Date: Thu, 7 Nov 2013 17:37:28 -0500
From: Dave Jones <davej@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: usb-serial lockdep trace in linus' current tree.
Message-ID: <20131107223728.GA18157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-usb@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing this since todays USB merge.

WARNING: CPU: 0 PID: 226 at kernel/lockdep.c:2740 lockdep_trace_alloc+0xc5/0xd0()
DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
Modules linked in: usb_debug(+) kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode(+) pcspkr serio_raw
CPU: 0 PID: 226 Comm: systemd-udevd Not tainted 3.12.0+ #112
 ffffffff81a22d3d ffff88023cde5670 ffffffff8171a8e8 ffff88023cde56b8
 ffff88023cde56a8 ffffffff8105430d 0000000000000046 00000000000080d0
 0000000000000010 0000000000000001 ffff880244407a80 ffff88023cde5708
Call Trace:
 [<ffffffff8171a8e8>] dump_stack+0x4e/0x82
 [<ffffffff8105430d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8105437c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff810cbcd5>] lockdep_trace_alloc+0xc5/0xd0
 [<ffffffff811a5633>] __kmalloc+0x53/0x350
 [<ffffffff8153e417>] ? xhci_urb_enqueue+0xb7/0x610
 [<ffffffff81339f5c>] ? debug_dma_mapping_error+0x7c/0x90
 [<ffffffff8153e417>] xhci_urb_enqueue+0xb7/0x610
 [<ffffffff8150fad6>] usb_hcd_submit_urb+0xa6/0xae0
 [<ffffffff8100b2f4>] ? native_sched_clock+0x24/0x80
 [<ffffffff810c531f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b2f4>] ? native_sched_clock+0x24/0x80
 [<ffffffff810c531f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810c5439>] ? get_lock_stats+0x19/0x60
 [<ffffffff810c5bae>] ? put_lock_stats.isra.28+0xe/0x40
 [<ffffffff81511569>] usb_submit_urb+0x1f9/0x470
 [<ffffffff81554ca5>] usb_serial_generic_write_start+0xf5/0x210
 [<ffffffff81554ef0>] usb_serial_generic_write+0x70/0x90
 [<ffffffff81555637>] usb_console_write+0xc7/0x220
 [<ffffffff810af585>] call_console_drivers.constprop.23+0xa5/0x1e0
 [<ffffffff810afe0c>] console_unlock+0x40c/0x460
 [<ffffffff810b10ec>] register_console+0x12c/0x390
 [<ffffffff81555b62>] usb_serial_console_init+0x22/0x40
 [<ffffffff815539aa>] usb_serial_probe+0xfea/0x10e0
 [<ffffffff8100b2f4>] ? native_sched_clock+0x24/0x80
 [<ffffffff810c531f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810c5439>] ? get_lock_stats+0x19/0x60
 [<ffffffff8172004d>] ? __mutex_unlock_slowpath+0xed/0x1a0
 [<ffffffff810c8af5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810c8bcd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff815164ef>] usb_probe_interface+0x1cf/0x300
 [<ffffffff814ad607>] driver_probe_device+0x87/0x390
 [<ffffffff814ad9e3>] __driver_attach+0x93/0xa0
 [<ffffffff814ad950>] ? __device_attach+0x40/0x40
 [<ffffffff814ab53b>] bus_for_each_dev+0x6b/0xb0
 [<ffffffff814ad02e>] driver_attach+0x1e/0x20
 [<ffffffff8155246e>] usb_serial_register_drivers+0x29e/0x580
 [<ffffffffa0005000>] ? 0xffffffffa0004fff
 [<ffffffffa000501e>] usb_serial_module_init+0x1e/0x1000 [usb_debug]
 [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
 [<ffffffff8103c7b3>] ? set_memory_nx+0x43/0x50
 [<ffffffff810d9e42>] load_module+0x1fd2/0x26a0
 [<ffffffff810d4f90>] ? store_uevent+0x40/0x40
 [<ffffffff810da6a6>] SyS_finit_module+0x86/0xb0
 [<ffffffff8172db64>] tracesys+0xdd/0xe2
---[ end trace ee033a3c9fd6263b ]---

