Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3CAONR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:13:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3CAONP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:13:15 -0500
Date: Fri, 1 Mar 2013 09:13:05 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Divide error in intel_pstate_set_policy
Message-ID: <20130301141305.GD31649@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've had a report[1] that the intel_pstate driver will panic on boot
under certain virtual machine environments.  Thus far it seems VMWare
and Hyper-V both see this.  While this may be because of something those
VMs are doing, the driver probably shouldn't cause a panic if it's
getting some iffy data.

Oops below. This was with Linus' tree as of Linux v3.8-9456-g309667e.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=916833

[    5.740065] Intel P-state driver initializing.
[    5.741503] Intel pstate controlling: cpu 0
[    5.742983] divide error: 0000 [#1] SMP 
[    5.744284] Modules linked in:
[    5.745225] CPU 0 
[    5.745612] Pid: 1, comm: swapper/0 Not tainted 3.9.0-0.rc0.git11.1.fc19.x86_64 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[    5.750186] RIP: 0010:[<ffffffff8158562d>]  [<ffffffff8158562d>] intel_pstate_set_policy+0x6d/0x130
[    5.752686] RSP: 0018:ffff880033535bb0  EFLAGS: 00010246
[    5.754478] RAX: 0000000000000000 RBX: ffff880033535c10 RCX: 0000000000000000
[    5.757091] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    5.759356] RBP: ffff880033535bc0 R08: a3d70a3d70a3d70b R09: 0000000000000064
[    5.761265] R10: 0000000000000000 R11: 0000000000000064 R12: ffff88002ace2760
[    5.763102] R13: 0000000000000000 R14: 0000000000000040 R15: 0000000000000040
[    5.765004] FS:  0000000000000000(0000) GS:ffff880036600000(0000) knlGS:0000000000000000
[    5.767496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.769486] CR2: 0000000000000000 CR3: 0000000001c0c000 CR4: 00000000000407f0
[    5.771679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.773942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.775722] Process swapper/0 (pid: 1, threadinfo ffff880033534000, task ffff880033538000)
[    5.778419] Stack:
[    5.779495]  0000000000000000 ffff880033535c10 ffff880033535bf0 ffffffff8157d773
[    5.781799]  ffff88002ace2808 ffff88002ace2760 0000000000000000 0000000000000040
[    5.784320]  ffff880033535d88 ffffffff8157dd74 ffff880000000000 0000000000000282
[    5.786624] Call Trace:
[    5.787644]  [<ffffffff8157d773>] __cpufreq_set_policy+0x103/0x280
[    5.789789]  [<ffffffff8157dd74>] cpufreq_add_dev_interface+0x294/0x350
[    5.791991]  [<ffffffff8157daa0>] ? cpufreq_update_policy+0x1b0/0x1b0
[    5.793740]  [<ffffffff8157ec4f>] cpufreq_add_dev+0x4af/0x5e0
[    5.795496]  [<ffffffff8146ed49>] subsys_interface_register+0xa9/0xf0
[    5.797269]  [<ffffffff8157c63f>] cpufreq_register_driver+0x9f/0x200
[    5.799054]  [<ffffffff81f5ea0c>] ? intel_pstate_setup+0x2f/0x2f
[    5.800932]  [<ffffffff81f5ea9c>] intel_pstate_init+0x90/0x143
[    5.802796]  [<ffffffff8100210a>] do_one_initcall+0x10a/0x160
[    5.804657]  [<ffffffff81f1f09c>] kernel_init_freeable+0x17c/0x202
[    5.806830]  [<ffffffff81f1e88b>] ? do_early_param+0x88/0x88
[    5.808404]  [<ffffffff816fb6f0>] ? rest_init+0x150/0x150
[    5.809862]  [<ffffffff816fb6fe>] kernel_init+0xe/0x190
[    5.811507]  [<ffffffff8172502c>] ret_from_fork+0x7c/0xb0
[    5.813352]  [<ffffffff816fb6f0>] ? rest_init+0x150/0x150
[    5.814812] Code: 41 ba 64 00 00 00 8b 7b 1c 31 d2 41 b9 64 00 00 00 49 b8 0b d7 a3 70 3d 0a d7 a3 41 bb 64 00 00 00 41 0f af c2 45 31 d2 44 89 d1 <f7> f7 85 c0 41 0
f 48 c2 48 63 f0 83 fe 64 49 0f 4f f1 89 35 b3
