Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3GJJ5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:57:38 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50281 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3GJJ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:57:36 -0400
Date: Wed, 10 Jul 2013 11:57:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Subject: EDAC lockdep splat
Message-ID: <20130710095733.GA356@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging an unrelated issue I came across the following lockdep
splat:

...
Jul 10 11:38:00 x4 kernel: AMD64 EDAC driver v3.4.0
Jul 10 11:38:00 x4 kernel: EDAC amd64: DRAM ECC enabled.
Jul 10 11:38:00 x4 kernel: EDAC amd64: F10h detected (node 0).
Jul 10 11:38:00 x4 kernel: EDAC MC: DCT0 chip selects:
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jul 10 11:38:00 x4 kernel: EDAC MC: DCT1 chip selects:
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jul 10 11:38:00 x4 kernel: EDAC amd64: using x4 syndromes.
Jul 10 11:38:00 x4 kernel: EDAC amd64: MCT channel count: 2
Jul 10 11:38:00 x4 kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Jul 10 11:38:00 x4 kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Jul 10 11:38:00 x4 kernel: EDAC amd64: CS2: Unbuffered DDR3 RAM
Jul 10 11:38:00 x4 kernel: EDAC amd64: CS3: Unbuffered DDR3 RAM
Jul 10 11:38:00 x4 kernel: BUG: key ffff8802169693f8 not in .data!
Jul 10 11:38:00 x4 kernel: ------------[ cut here ]------------
Jul 10 11:38:00 x4 kernel: WARNING: CPU: 3 PID: 1 at kernel/lockdep.c:2987 lockdep_init_map+0x45e/0x490()
Jul 10 11:38:00 x4 kernel: sda: unknown partition table
Jul 10 11:38:00 x4 kernel: DEBUG_LOCKS_WARN_ON(1)
Jul 10 11:38:00 x4 kernel: CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.10.0-08587-g496322b #34
Jul 10 11:38:00 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Jul 10 11:38:00 x4 kernel: 0000000000000009 ffff880216885ac8 ffffffff815a9e66 ffff880216885b10
Jul 10 11:38:00 x4 kernel: ffff880216885b00 ffffffff810627ad ffff8802155b1910 ffff8802169693f8
Jul 10 11:38:00 x4 kernel: sd 1:0:0:0: [sda] Attached SCSI disk
Jul 10 11:38:00 x4 kernel: 0000000000000000 0000000000000000 ffff88021559c400 ffff880216885b60
Jul 10 11:38:00 x4 kernel: Call Trace:
Jul 10 11:38:00 x4 kernel: [<ffffffff815a9e66>] dump_stack+0x45/0x56
Jul 10 11:38:00 x4 kernel: [<ffffffff810627ad>] warn_slowpath_common+0x7d/0xb0
Jul 10 11:38:00 x4 kernel: [<ffffffff81062857>] warn_slowpath_fmt+0x47/0x50
Jul 10 11:38:00 x4 kernel: [<ffffffff810a588e>] lockdep_init_map+0x45e/0x490
Jul 10 11:38:00 x4 kernel: [<ffffffff810a3096>] debug_mutex_init+0x36/0x50
Jul 10 11:38:00 x4 kernel: [<ffffffff8108526d>] __mutex_init+0x5d/0x70
Jul 10 11:38:00 x4 kernel: [<ffffffff813c8235>] bus_register+0x175/0x2e0
Jul 10 11:38:00 x4 kernel: [<ffffffff8146c3d3>] edac_create_sysfs_mci_device+0x53/0x530
Jul 10 11:38:00 x4 kernel: [<ffffffff8146a303>] edac_mc_add_mc+0xf3/0x250
Jul 10 11:38:00 x4 kernel: [<ffffffff81471424>] amd64_probe_one_instance+0x734/0xfa0
Jul 10 11:38:00 x4 kernel: [<ffffffff8126182c>] pci_device_probe+0x9c/0xe0
Jul 10 11:38:00 x4 kernel: [<ffffffff813c90a1>] driver_probe_device+0x71/0x230
Jul 10 11:38:00 x4 kernel: [<ffffffff813c9363>] __driver_attach+0xa3/0xb0
Jul 10 11:38:00 x4 kernel: [<ffffffff813c92c0>] ? __device_attach+0x60/0x60
Jul 10 11:38:00 x4 kernel: [<ffffffff813c7403>] bus_for_each_dev+0x63/0xa0
Jul 10 11:38:00 x4 kernel: [<ffffffff813c8fb9>] driver_attach+0x19/0x20
Jul 10 11:38:00 x4 kernel: [<ffffffff813c7ee0>] bus_add_driver+0x1d0/0x260
Jul 10 11:38:00 x4 kernel: [<ffffffff81ab62f6>] ? mce_amd_init+0x15d/0x15d
Jul 10 11:38:00 x4 kernel: [<ffffffff813c9921>] driver_register+0x71/0x150
Jul 10 11:38:00 x4 kernel: [<ffffffff81255206>] ? __raw_spin_lock_init+0x36/0x60
Jul 10 11:38:00 x4 kernel: [<ffffffff81ab62f6>] ? mce_amd_init+0x15d/0x15d
Jul 10 11:38:00 x4 kernel: [<ffffffff8126190b>] __pci_register_driver+0x5b/0x60
Jul 10 11:38:00 x4 kernel: [<ffffffff81ab63a5>] amd64_edac_init+0xaf/0x191
Jul 10 11:38:00 x4 kernel: [<ffffffff81ab62f6>] ? mce_amd_init+0x15d/0x15d
Jul 10 11:38:00 x4 kernel: [<ffffffff81a95d61>] do_one_initcall+0x7f/0x10d
Jul 10 11:38:00 x4 kernel: [<ffffffff81080838>] ? parse_args+0x1f8/0x330
Jul 10 11:38:00 x4 kernel: [<ffffffff81a95efc>] kernel_init_freeable+0x10d/0x18d
Jul 10 11:38:00 x4 kernel: [<ffffffff81a957ad>] ? do_early_param+0x88/0x88
Jul 10 11:38:00 x4 kernel: [<ffffffff815a1cb0>] ? rest_init+0xc0/0xc0
Jul 10 11:38:00 x4 kernel: [<ffffffff815a1cb9>] kernel_init+0x9/0x180
Jul 10 11:38:00 x4 kernel: [<ffffffff815b20ac>] ret_from_fork+0x7c/0xb0
Jul 10 11:38:00 x4 kernel: [<ffffffff815a1cb0>] ? rest_init+0xc0/0xc0
Jul 10 11:38:00 x4 kernel: ---[ end trace 7de9b5e7ff84ed1b ]---
Jul 10 11:38:00 x4 kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Jul 10 11:38:00 x4 kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
...

-- 
Markus
