Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3GGW0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 18:26:07 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:51123 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab3GGW0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 18:26:04 -0400
Message-ID: <51D9EAF3.4050804@tlinx.org>
Date: Sun, 07 Jul 2013 15:25:55 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Fwd: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also am seeing this for the first time:

(don't know, but seems unlikely to be related to
https://patchwork.kernel.org/patch/87359/
Yet it is the only hit I found for the same message.


Looks like it's back to a more stable 3.9.8...
(*sigh*)


BUG: key ffff880c1148c478 not in .data!
[    4.429474] ------------[ cut here ]------------
[    4.434236] WARNING: at kernel/lockdep.c:2987 
lockdep_init_map+0x45e/0x490()
[    4.441414] DEBUG_LOCKS_WARN_ON(1)
[    4.444684] Modules linked in:
[    4.448168] usb 1-3.2: new low-speed USB device number 3 using ehci-pci
[    4.454975] CPU: 10 PID: 1 Comm: swapper/0 Tainted: G          I  
3.10.0-Isht-Van #1
[    4.462862] Hardware name: Dell Inc. PowerEdge T610/0CX0R0, BIOS 
6.3.0 07/24/2012
[    4.470475]  0000000000000009 ffff880c13175a70 ffffffff815bb279 
ffff880c13175aa8
[    4.478221]  ffffffff8104641c ffff880c11c12130 ffff880c1148c478 
0000000000000000
[    4.485988]  ffff880c11c12058 ffff880c12386180 ffff880c13175b08 
ffffffff81046487
[    4.493800] Call Trace:
[    4.496472]  [<ffffffff815bb279>] dump_stack+0x19/0x1b
[    4.501776]  [<ffffffff8104641c>] warn_slowpath_common+0x5c/0x80
[    4.507917]  [<ffffffff81046487>] warn_slowpath_fmt+0x47/0x50
[    4.513790]  [<ffffffff8109c1fe>] lockdep_init_map+0x45e/0x490
[    4.519775]  [<ffffffff8109b12d>] debug_mutex_init+0x2d/0x40
[    4.525567]  [<ffffffff8106ef61>] __mutex_init+0x51/0x60
[    4.531017]  [<ffffffff813a1618>] bus_register+0x158/0x2c0
[    4.536646]  [<ffffffff814c6dc3>] edac_create_sysfs_mci_device+0x53/0x540
[    4.542512] usb 1-3.2: New USB device found, idVendor=413c, 
idProduct=2003
[    4.542513] usb 1-3.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    4.542514] usb 1-3.2: Product: Dell USB Keyboard
[    4.542515] usb 1-3.2: Manufacturer: Dell
[    4.567013]  [<ffffffff814c4f13>] edac_mc_add_mc+0x103/0x270
[    4.572804]  [<ffffffff814cac30>] i7core_probe+0x530/0xe70
[    4.578435]  [<ffffffff81313479>] local_pci_probe+0x39/0x70
[    4.584136]  [<ffffffff81313ca1>] pci_device_probe+0x111/0x120
[    4.590107]  [<ffffffff813a27b1>] driver_probe_device+0x71/0x230
[    4.596251]  [<ffffffff813a2a3b>] __driver_attach+0x8b/0x90
[    4.601955]  [<ffffffff813a29b0>] ? __device_attach+0x40/0x40
[    4.607836]  [<ffffffff813a09a3>] bus_for_each_dev+0x63/0xa0
[    4.613625]  [<ffffffff813a2309>] driver_attach+0x19/0x20
[    4.619167]  [<ffffffff813a1f28>] bus_add_driver+0x1d8/0x270
[    4.624963]  [<ffffffff813a2e4c>] driver_register+0x6c/0x150
[    4.630756]  [<ffffffff81313308>] __pci_register_driver+0x58/0x60
[    4.636990]  [<ffffffff81cddf00>] ? edac_init+0x67/0x67
[    4.642343]  [<ffffffff81cddf38>] i7core_init+0x38/0xb7
[    4.647702]  [<ffffffff81cddf00>] ? edac_init+0x67/0x67
[    4.653065]  [<ffffffff810002ca>] do_one_initcall+0xfa/0x150
[    4.658859]  [<ffffffff81ca6eee>] kernel_init_freeable+0x15a/0x1da
[    4.665176]  [<ffffffff81ca6807>] ? do_early_param+0x88/0x88
[    4.673917]  [<ffffffff815a95b0>] ? rest_init+0xd0/0xd0
[    4.679278]  [<ffffffff815a95b9>] kernel_init+0x9/0x180
[    4.684640]  [<ffffffff815c962c>] ret_from_fork+0x7c/0xb0
[    4.690174]  [<ffffffff815a95b0>] ? rest_init+0xd0/0xd0
[    4.695534] ---[ end trace 9ddab1480c5d91dc ]---
[    4.700444] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core 
#1': DEV 0000:fe:03.0
[    4.708791] EDAC PCI0: Giving out device to module 'i7core_edac' 
controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[    4.720714] BUG: key ffff880c11a1c478 not in .data!




