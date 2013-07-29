Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3G2HfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:35:14 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:52047 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3G2HfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:35:12 -0400
Date: Mon, 29 Jul 2013 09:35:27 +0200
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bskeggs@redhat.com, maarten.lankhorst@canonical.com
Subject: Re: nouveau oops in nouveau_bo_new
Message-ID: <20130729093527.7d2784e5@fem.tu-ilmenau.de>
In-Reply-To: <20130729085616.70670064@fem.tu-ilmenau.de>
References: <20130725162203.GA32273@redhat.com>
	<20130729085616.70670064@fem.tu-ilmenau.de>
X-Mailer: Claws Mail 3.9.2-dirty (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 08:56:16 +0200
Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:

> On Thu, 25 Jul 2013 12:22:03 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > This recently started happening (since the last DRM merge, 3.10 was
> > fine).
> > 
> > [   17.751970] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [   17.752260] Modules linked in: nouveau(+) video mxm_wmi wmi
> > i2c_algo_bit tg3 ttm drm_kms_helper iTCO_wdt drm iTCO_vendor_support
> > ptp lpc_ich ppdev dcdbas mfd_core pps_core serio_raw i5k_amb
> > i2c_i801 pcspkr i2c_core shpchp parport_pc parport xfs libcrc32c
> > raid0 floppy [   17.753911] CPU: 3 PID: 292 Comm: systemd-udevd Not
> > tainted 3.11.0-rc2+ #13 [   17.754123] Hardware name: Dell
> > Inc.                 Precision WorkStation 490    /0DT031, BIOS A08
> > 04/25/2008 [   17.754285] task: ed9dabc0 ti: ecdd0000 task.ti:
> > ecdd0000 [   17.754392] EIP: 0060:[<f86dde0f>] EFLAGS: 00010296 CPU:
> > 3 [   17.754542] EIP is at nouveau_bo_new+0x1f/0x28c [nouveau]
> > [   17.754647] EAX: 00000000 EBX: ed8610b0 ECX: 00000100 EDX:
> > 00004000 [   17.754753] ESI: 00004000 EDI: ec8390b0 EBP: ecdd1b4c
> > ESP: ecdd1b14 [   17.754858]  DS: 007b ES: 007b FS: 00d8 GS: 00e0
> > SS: 0068 [   17.754963] CR0: 80050033 CR2: 00000000 CR3: 2ca65000
> > CR4: 000007f0 [   17.755069] Stack: [   17.755167]  00000003
> > f1002780 000008b0 ecdd0000 f850280f 00000600 000080d0 ed8610b0
> > [   17.755690] 00000100 ef9f3cd0 00000000 ed8610b0 ef9f3cd0
> > 00000000 ecdd1b78 f86ef2f6 [   17.756210]  00000004 00000000
> > 00000000 00000000 ed861444 ecef8c30 ebb41520 ef9f3cd0
> > [   17.756729] Call Trace: [   17.756849] [<f850280f>] ?
> > drm_mode_crtc_set_gamma_size+0x23/0x43 [drm] [   17.756993]
> > [<f86ef2f6>] nv04_crtc_create+0xd4/0x142 [nouveau] [   17.757138]
> > [<f86f2758>] nv04_display_create+0xf2/0x35a [nouveau]
> > [   17.757281]  [<f86e801a>] nouveau_display_create+0x33f/0x553
> > [nouveau] [   17.757422]  [<f86d99fb>] nouveau_drm_load+0x22f/0x5dc
> > [nouveau] [   17.757534]  [<c1391816>] ? device_register+0x17/0x1a
> > [   17.757648]  [<f84ff77b>] ? drm_sysfs_device_add+0x76/0xa3 [drm]
> > [   17.757764]  [<f84fe6bd>] drm_get_pci_dev+0x138/0x238 [drm]
> > [   17.757902]  [<f86ab3ce>] ? nouveau_device_create_+0x65/0x11b
> > [nouveau] [   17.758044]  [<f86da081>]
> > nouveau_drm_probe+0x2d9/0x360 [nouveau] [   17.758155]
> > [<c12d55ac>] pci_device_probe+0x6c/0xb0 [   17.758261]
> > [<c1393dae>] driver_probe_device+0x7f/0x356 [   17.758367]
> > [<c139412c>] __driver_attach+0x74/0x76 [   17.758473]
> > [<c13940b8>] ? __device_attach+0x33/0x33 [   17.758579]
> > [<c13922b6>] bus_for_each_dev+0x49/0x74 [   17.758684]
> > [<c13938ec>] driver_attach+0x1e/0x20 [   17.758791] [<c13940b8>] ?
> > __device_attach+0x33/0x33 [   17.758896]  [<c1393550>]
> > bus_add_driver+0x1d0/0x27c [   17.759002]  [<c12d51c2>] ?
> > pci_pm_suspend+0x111/0x111 [   17.759109]  [<c12d51c2>] ?
> > pci_pm_suspend+0x111/0x111 [   17.759215]  [<c1394667>]
> > driver_register+0x6a/0x123 [   17.759321]  [<c12bdfad>] ?
> > __raw_spin_lock_init+0x2d/0x4e [   17.759428]  [<c12d45f3>]
> > __pci_register_driver+0x4a/0x4d [   17.760008]  [<f84fe8a3>]
> > drm_pci_init+0xe6/0xee [drm] [   17.760008]  [<f8752000>] ?
> > 0xf8751fff [   17.760008]  [<f8752048>]
> > nouveau_drm_init+0x48/0x1000 [nouveau] [   17.760008]  [<c10003f0>]
> > do_one_initcall+0xc0/0x180 [   17.760008]  [<f8752000>] ?
> > 0xf8751fff [   17.760008] [<c1033765>] ? set_memory_nx+0x5a/0x5c
> > [   17.760008]  [<c15aca75>] ? set_section_ro_nx+0x54/0x59
> > [   17.760008]  [<c10b4174>] load_module+0x1ad6/0x2519
> > [   17.760008]  [<c10b05ed>] ?
> > copy_module_from_fd.isra.49+0x34/0x13b [   17.760008]  [<c10b4d0b>]
> > SyS_finit_module+0x73/0xac [   17.760008]  [<c106b0cb>] ?
> > up_write+0x1b/0x30 [   17.760008]  [<c11343ca>] ?
> > vm_mmap_pgoff+0x7a/0x97 [   17.760008]  [<c15bf03b>]
> > sysenter_do_call+0x12/0x32 [   17.760008] Code: c7 83 1c 01 00 00
> > ff ff ff ff eb aa 55 89 e5 57 56 53 83 ec 2c 66 66 66 66 90 89 d6
> > 89 4d e8 8b b8 ec 03 00 00 8b 87 8c 00 00 00 <8b> 00 0f b6 88 91 00
> > 00 00 b8 ff ff ff ff d3 e0 25 ff ff ff 7f [   17.760008] EIP:
> > [<f86dde0f>] nouveau_bo_new+0x1f/0x28c [nouveau] SS:ESP
> > 0068:ecdd1b14 [   17.760008] CR2: 0000000000000000
> 
> I've seen a similar oops. Bisect pointed me to
> 0108bc808107b97e101b15af9705729626be6447 "drm/nouveau: do not allow
> negative sizes for now" and reverting this commit fixed it for me.

Forgot CC
