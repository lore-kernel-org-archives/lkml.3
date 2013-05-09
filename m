Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3EIK6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:58:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35677 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3EIK6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:58:02 -0400
Date: Thu, 9 May 2013 13:01:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: lockdep: BUG: key ffff880436f00330 not in .data!
Message-ID: <20130509110101.GD27333@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on current linus:

[    3.806733] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
[    3.807455] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
[    3.808317] BUG: key ffff880436f00330 not in .data!
[    3.808843] ------------[ cut here ]------------
[    3.809571] WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x555/0x590()
[    3.810274] DEBUG_LOCKS_WARN_ON(1)
[    3.810279] Modules linked in: sb_edac(+) edac_core acpi_cpufreq mperf ehci_hcd gf128mul ablk_helper iTCO_wdt iTCO_vendor_support evdev l
pc_ich button pcspkr usbcore snd cryptd mfd_core usb_common soundcore processor microcode
[    3.811776] CPU: 7 PID: 718 Comm: modprobe Not tainted 3.9.0+ #5
[    3.812516] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[    3.813271]  0000000000000009 ffff880434421858 ffffffff815e97c6 ffff880434421898
[    3.814009]  ffffffff8103e210 ffff880434421888 ffff88043b200110 ffffffff8181062e
[    3.814758]  0000000000000000 ffff880436f00330 0000000000000000 ffff8804344218f8
[    3.815518] Call Trace:
[    3.816249]  [<ffffffff815e97c6>] dump_stack+0x19/0x1b
[    3.816977]  [<ffffffff8103e210>] warn_slowpath_common+0x70/0xa0
[    3.817675]  [<ffffffff8103e2f6>] warn_slowpath_fmt+0x46/0x50
[    3.818394]  [<ffffffff810954c5>] lockdep_init_map+0x555/0x590
[    3.819119]  [<ffffffff810998ed>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[    3.819837]  [<ffffffff810999bd>] ? trace_hardirqs_on+0xd/0x10
[    3.820536]  [<ffffffff81093ea8>] debug_mutex_init+0x38/0x50
[    3.821223]  [<ffffffff81068b91>] __mutex_init+0x61/0x70
[    3.821916]  [<ffffffff8142a495>] bus_register+0x175/0x2e0
[    3.822579]  [<ffffffffa00ce645>] edac_create_sysfs_mci_device+0x55/0x540 [edac_core]
[    3.823249]  [<ffffffff810999bd>] ? trace_hardirqs_on+0xd/0x10
[    3.823938]  [<ffffffffa00cc5e3>] edac_mc_add_mc+0x103/0x270 [edac_core]
[    3.824600]  [<ffffffffa00b2d12>] sbridge_probe+0xc12/0xee0 [sb_edac]
[    3.825307]  [<ffffffff812abbe6>] pci_device_probe+0x136/0x150
[    3.825996]  [<ffffffff8142bb96>] driver_probe_device+0x76/0x230
[    3.826663]  [<ffffffff8142bdfb>] __driver_attach+0xab/0xb0
[    3.827342]  [<ffffffff8142bd50>] ? driver_probe_device+0x230/0x230
[    3.828018]  [<ffffffff81429ced>] bus_for_each_dev+0x5d/0xa0
[    3.828672]  [<ffffffff8142b67e>] driver_attach+0x1e/0x20
[    3.829329]  [<ffffffff8142b151>] bus_add_driver+0x101/0x260
[    3.829957]  [<ffffffff8142c4d7>] driver_register+0x77/0x170
[    3.830559]  [<ffffffff812aab74>] __pci_register_driver+0x64/0x70
[    3.831156]  [<ffffffffa006a000>] ? 0xffffffffa0069fff
[    3.831737]  [<ffffffffa006a033>] sbridge_init+0x33/0x1000 [sb_edac]
[    3.832290]  [<ffffffffa006a000>] ? 0xffffffffa0069fff
[    3.832868]  [<ffffffff81000312>] do_one_initcall+0x112/0x170
[    3.833392]  [<ffffffff810a5bb9>] load_module+0x1be9/0x25a0
[    3.833918]  [<ffffffff810a18e0>] ? unset_module_init_ro_nx+0x80/0x80
[    3.834426]  [<ffffffff810a662f>] SyS_init_module+0xbf/0xf0
[    3.834975]  [<ffffffff815f8ec6>] system_call_fastpath+0x1a/0x1f
[    3.835471] ---[ end trace 4ad6d866311d6e2b ]---
[    3.836069] EDAC MC0: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#0': DEV 0000:3f:0e.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
