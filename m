Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3FRBMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:12:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3FRBL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:11:59 -0400
Date: Mon, 17 Jun 2013 21:11:45 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mchehab@redhat.com, norsk5@xmission.com
Subject: EDAC BUG: key ee78135c not in .data!
Message-ID: <20130618011145.GB2200@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
	norsk5@xmission.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this during boot-up:


i5k_amb: probe of i5k_amb.0 failed with error -16
EDAC MC: Ver: 3.0.0
BUG: key ee78135c not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x34f/0x37c()
DEBUG_LOCKS_WARN_ON(1)
Modules linked in:
 i5000_edac(+) edac_core i5k_amb shpchp parport_pc(+) floppy(+) parport xfs libcrc32c raid0
CPU: 0 PID: 303 Comm: systemd-udevd Not tainted 3.10.0-rc6+ #1 
Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
 c173f15a e4d39bc8 e4d39b90 c15a3cec e4d39bb8 c1038f25 c1739e2c e4d39be4
 00000bab c109b81c c109b81c e4d8d0c4 ee78135c ee78135c e4d39bd0 c1038f6f
 00000009 e4d39bc8 c1739e2c e4d39be4 e4d39bfc c109b81c c173f15a 00000bab
Call Trace:
 [<c15a3cec>] dump_stack+0x16/0x18
 [<c1038f25>] warn_slowpath_common+0x5e/0x75
 [<c109b81c>] ? lockdep_init_map+0x34f/0x37c
 [<c109b81c>] ? lockdep_init_map+0x34f/0x37c
 [<c1038f6f>] warn_slowpath_fmt+0x33/0x35
 [<c109b81c>] lockdep_init_map+0x34f/0x37c
 [<c109a5ab>] debug_mutex_init+0x2d/0x42
 [<c106233c>] __mutex_init+0x44/0x49
 [<c137f9d7>] bus_register+0x120/0x2b9
 [<f84a411b>] edac_create_sysfs_mci_device+0x4f/0x50a [edac_core]
 [<f84a2388>] edac_mc_add_mc+0xe9/0x226 [edac_core]
 [<f84540df>] i5000_init_one+0x775/0x96e [i5000_edac]
 [<c109d8b2>] ? trace_hardirqs_on_caller+0xea/0x1b4
 [<c12c302c>] pci_device_probe+0x6c/0xb0
 [<c1380a28>] driver_probe_device+0x7f/0x354
 [<c1380da3>] __driver_attach+0x73/0x75
 [<c1380d30>] ? __device_attach+0x33/0x33
 [<c137ef36>] bus_for_each_dev+0x49/0x74
 [<c138056c>] driver_attach+0x1e/0x20
 [<c1380d30>] ? __device_attach+0x33/0x33
 [<c13801d0>] bus_add_driver+0x1d0/0x27c
 [<c12c2c42>] ? pci_pm_suspend+0x111/0x111
 [<c12c2c42>] ? pci_pm_suspend+0x111/0x111
 [<c13812d7>] driver_register+0x6a/0x123
 [<c12abc4d>] ? __raw_spin_lock_init+0x2d/0x4e
 [<f8449000>] ? 0xf8448fff
 [<c12c2073>] __pci_register_driver+0x4a/0x4d
 [<f844902a>] i5000_init+0x2a/0x1000 [i5000_edac]
 [<c1000173>] do_one_initcall+0xa3/0x160
 [<c15a0cc7>] ? set_section_ro_nx+0x54/0x59
 [<c10ab997>] load_module+0x1c27/0x24fd
 [<c10a7bcf>] ? copy_module_from_fd.isra.48+0x34/0x139
 [<c10ac3c1>] SyS_finit_module+0x73/0xac
 [<c10642ab>] ? up_write+0x1b/0x30
 [<c112792c>] ? vm_mmap_pgoff+0x7a/0x97
 [<c15b19c1>] sysenter_do_call+0x12/0x32
---[ end trace 63d11a09ce743ee7 ]---

