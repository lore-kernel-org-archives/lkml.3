Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3CESZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:25:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33381 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab3CESZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:25:52 -0500
Date: Tue, 5 Mar 2013 13:25:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
Cc: xen-devel@lists.xensource.com
Subject: intel-pstate driver blows up if cpufreq_register_driver fails.
Message-ID: <20130305182541.GC24062@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what we get:

[   14.429235] calling  intel_pstate_init+0x0/0x14d @ 1^M^M
[   14.434268] Intel P-state driver initializing.^M^M
[   14.438775] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030^M^M
[   14.446649] IP: [<ffffffff8121a254>] sysfs_remove_group+0x14/0x100^M^M
[   14.452889] PGD 0 ^M^M
[   14.454968] Oops: 0000 [#1] SMP ^M^M
[   14.458261] Modules linked in:^M^M
[   14.461382] CPU 0 ^M^M
[   14.463204] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1upstream-00021-g9e952b4-dirty #8 MSI MS-7680/H61M-P23 (MS-7680)^M^M
[   14.474382] RIP: e030:[<ffffffff8121a254>]  [<ffffffff8121a254>] sysfs_remove_group+0x14/0x100^M^M
[   14.483048] RSP: e02b:ffff8801e3489e58  EFLAGS: 00010296^M^M
[   14.488422] RAX: 00000000ffffffed RBX: ffffffff81a7cd80 RCX: 0000000000000000^M^M
[   14.495614] RDX: 0000000000000000 RSI: ffffffff81a7cd80 RDI: 0000000000000000^M^M
[   14.502806] RBP: ffff8801e3489e78 R08: 0000000000000001 R09: 0000000000000008^M^M
[   14.510001] R10: 0000000000000008 R11: 00000000fffffffa R12: 0000000000000000^M^M
[   14.517194] R13: ffffffff81afac08 R14: 000000014c7ca386 R15: 0000000000000000^M^M
[   14.524389] FS:  00007f49debd2700(0000) GS:ffff8801f0e00000(0000) knlGS:0000000000000000^M^M
[   14.532532] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033^M^M
[   14.538340] CR2: 0000000000000030 CR3: 0000000001a0c000 CR4: 0000000000042660^M^M
[   14.545531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M^M
[   14.552724] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M^M
[   14.559918] Process swapper/0 (pid: 1, threadinfo ffff8801e3488000, task ffff8801e347c800)^M^M
[   14.568237] Stack:^M^M
[   14.570316]  00000000ffffffed ffffffff81a9d520 ffffffff81afac08 000000014c7ca386^M^M
[   14.577771]  ffff8801e3489ea8 ffffffff814e8690 00000000ffffffff 00000000ffffffed^M^M
[   14.585223]  ffffffff81a9d520 ffffffff81afac08 ffff8801e3489ec8 ffffffff81afad42^M^M
[   14.592677] Call Trace:^M^M
[   14.595193]  [<ffffffff81afac08>] ? cpufreq_p4_init+0x55/0x55^M^M
[   14.601000]  [<ffffffff814e8690>] intel_pstate_exit+0x20/0xd0^M^M
[   14.606805]  [<ffffffff81afac08>] ? cpufreq_p4_init+0x55/0x55^M^M
[   14.612612]  [<ffffffff81afad42>] intel_pstate_init+0x13a/0x14d^M^M
[   14.618593]  [<ffffffff81002124>] do_one_initcall+0x124/0x170^M^M
[   14.624396]  [<ffffffff81ac1a03>] kernel_init_freeable+0x157/0x1e6^M^M
[   14.630635]  [<ffffffff81ac1a92>] ? kernel_init_freeable+0x1e6/0x1e6^M^M
[   14.637050]  [<ffffffff8165add0>] ? rest_init+0xa0/0xa0^M^M
[   14.642337]  [<ffffffff8165add9>] kernel_init+0x9/0xf0^M^M
[   14.647538]  [<ffffffff8167c9fc>] ret_from_fork+0x7c/0xb0^M^M
[   14.652998]  [<ffffffff8165add0>] ? rest_init+0xa0/0xa0^M^M
[   14.658282] Code: 1f 84 00 00 00 00 00 55 48 89 f2 31 f6 48 89 e5 e8 e2 fd ff ff c9 c3 55 48 89 e5 41 56 41 55 41 54 49 89 fc 53 48 8b 16 48 89 f3 <4c> 8b 77 30 48 85 d2 0f 84 87 00 00 00 31 f6 4c 89 f7 e8 d5 e3 ^M^M
[   14.677174] RIP  [<ffffffff8121a254>] sysfs_remove_group+0x14/0x100^M^M
[   14.683498]  RSP <ffff8801e3489e58>^M^M
[   14.687052] CR2: 0000000000000030^M^M
[   14.690450] ---[ end trace 104ea7a191a991d2 ]---^M^M
[   14.695120] swapper/0 (1) used greatest stack depth: 3688 bytes left^M^M
[   14.701532] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009^M^M


The cpufreq is disabled, so we end up with:

797         rc = cpufreq_register_driver(&intel_pstate_driver);
798         if (rc)
799                 goto out;
800 
801         intel_pstate_debug_expose_params();
802         intel_pstate_sysfs_expose_params();
803         return rc;
804 out:
805         intel_pstate_exit();
806         return -ENODEV;

Since line 797 fails, we call intel_pstate_exit() which tries:

754         sysfs_remove_group(intel_pstate_kobject,
755                                 &intel_pstate_attr_group);


and that blows up b/c we had never called intel_pstate_debug_expose_params
(line 801).

