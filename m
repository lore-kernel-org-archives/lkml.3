Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3EGHyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:54:54 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34136 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3EGHyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:54:53 -0400
Date: Tue, 7 May 2013 03:54:53 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1066765392.8155999.1367913293110.JavaMail.root@redhat.com>
In-Reply-To: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.0: WARNING: at drivers/base/core.c:575
Thread-Index: yaJVbnaITfbi0DUdIA/mtdAi+jaxtS131gK0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, also saw it on x64,

[   18.305143] WARNING: at drivers/base/core.c:575 device_create_file+0x82/0xa0() 
[   18.313208] Write permission without 'store' 
[   18.317985] Modules linked in: i5000_edac(F+) iTCO_vendor_support(F) coretemp(F) edac_core(F) kvm_intel(F) lpc_ich(F) kvm(F) i5k_amb(F) ptp(F) i2c_i801(F) shpchp(F) mfd_core(F) pps_core(F) microcode(F) pcspkr(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) crc_t10dif(F) cdrom(F) ata_generic(F) pata_acpi(F) mgag200(F) syscopyarea(F) sysfillrect(F) sysimgblt(F) ata_piix(F) i2c_algo_bit(F) drm_kms_helper(F) ttm(F) drm(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   18.366804] CPU: 0 PID: 355 Comm: systemd-udevd Tainted: GF            3.9.0+ #1 
[   18.375065] Hardware name: NEC Express800/120Rg-1 [N8100-1242]/MS-9172-02S, BIOS 1.0.5S42 10/05/2006 
[   18.385360]  0000000000000009 ffff880069917938 ffffffff815f105e ffff880069917978 
[   18.393800]  ffffffff8104e4f0 ffff8800663099c8 ffffffffa03304a0 ffff8800661cea40 
[   18.402136] Rquest for unknown module key 'Magrathea: Glacier signing key: cf3c1f5ed7be276234c447dbf4a4a5a83a249db4' err -11 
[   18.402241]  0000000000000000 ffff8800661cea40 0000000000000000 ffff8800699179d8 
[   18.402242] Call Trace: 
[   18.402247]  [<ffffffff815f105e> dump_stack+0x19/0x1b 
[   18.402251]  [<ffffffff8104e4f0>] warn_slowpath_common+0x70/0xa0 
[   18.402252]  [<ffffffff8104e5d6>] warn_slowpath_fmt+0x46/0x50 
[   18.402254]  [<ffffffff813c92d2>] device_create_file+0x82/0xa0 
[   18.402260]  [<fffffffa032a948>] edac_create_sysfs_mci_device+0x3b8/0x550 [edac_core] 
[   18.402263]  [<ffffffffa0328574>] edac_mc_add_mc+0xf4/0x260 [edac_core] 
[   18.402265]  [<ffffffffa0304179>] i5000_probe1+0x859/0xb20 [i5000_edac] 
[   18.402267]  [<ffffffffa0304471>] i5000_init_one+0x31/0x40 [i5000_edac] 
[   18.402271]  [<ffffffff8131425b>] local_pci_probe+0x4b/0x80 
[   18.402272]  [<ffffffff81314571>] pci_device_probe+0x111/0x120 
[   18.402275]  [<ffffffff813cd58b>] driver_probe_device+0x8b/0x390 
[   18.402276]  [<ffffffff813cd93b>] __driver_attach+0xab/0xb0 
[   18.402278]  [<ffffffff813cd890>] ? driver_probe_device+0x390/0x390 
[   .402279]  [<ffffffff813cb50d>] bus_for_each_dev+0x5d/0xa0 
[   18.402281]  [<ffffffff813ccece>] driver_attach+0x1e/0x20 
[   18.402282]  [<ffffffff813cc9fe>] bus_add_driver+0x11e/0x2a0 
[   18.402284]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
[   18.402285]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
[   18.402286]  [<ffffffff813ce007>] driver_register+0x77/0x170 
[   18.402288]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
[   18.402289]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
[   18.402 [<ffffffff813134fc>] __pci_register_driver+0x4c/0x50 
[   18.402292]  [<ffffffffa002f031>] i5000_init+0x31/0x1000 [i5000_edac] 
[   18.402295]  [<ffffffff810002ea>] do_one_initcall+0xea/0x1a0 
[   18.402298]  [<ffffffff810b4464>] le+0x11e4/0x1b00 
[   18.402300]  [<ffffffff81303f10>] ? ddebug_proc_open+0xc0/0xc0 
[   18.402303]  [<ffffffff815f7af2>] ? page_fault+0x22/0x30 
[   18.402305]  [<ffffffff810b4e57>] SyS_init_module+0xd7/0x120 
[   18.402307]  [<ffffffff815ff942>] sysall_fastpath+0x16/0x1b 
[   18.402308] ---[ end trace 3eb6a6f51fb8cafb ]--- 
[   18.402406] ------------[ cut here ]------------ 

----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 7, 2013 3:25:58 PM
> Subject: 3.9.0: WARNING: at drivers/base/core.c:575
> 
> Never saw any of those messages were floating in any of the RC testing, but
> now happened in 3.9 GA on Power 7 systems.
> 
> [    0.329753] EEH: devices created
> [    0.340203] atomic64 test passed
> [    0.340407] NET: Registered protocol family 16
> [    0.340457] EEH: No capable adapters found
> [    0.340609] IBM eBus Device Driver
> [    0.358825] Write permission without 'store'
> [    0.358852] ------------[ cut here ]------------
> [    0.358859] WARNING: at drivers/base/core.c:575
> [    0.358866] Modules linked in:
> [    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> [    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti:
> c0000003f8c00000
> [    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR:
> 0000000001766760
> [    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.9.0+)
> [    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139d24  XER:
> 00000001
> [    0.358939] SOFTE: 1
> [    0.358944] CFAR: c00000000074427c
> [    0.358950]
> GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 0000000000000020
> GPR04: 0000000000000000 0000000000000000 00000000160c9615 0000000000000000
> GPR08: c000000001064af0 0000000000000000 0000000000000000 0000000000003fef
> GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 0000000000000000
> GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 0000000000000001
> GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000117eb08
> GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c000000000ff21a0
> GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c000000001500030
> [    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
> [    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
> [    0.359088] Call Trace:
> [    0.359095] [c0000003f8c03a00] [c0000000004a7f40]
> .device_create_file+0xa0/0xe0 (unreliable)
> [    0.359112] [c0000003f8c03a90] [c00000000074daf8]
> .register_cpu_online+0x21c/0x284
> [    0.359126] [c0000003f8c03b30] [c000000000a78308]
> .topology_init+0x130/0x200
> [    0.359138] [c0000003f8c03c10] [c00000000000b4d4]
> .do_one_initcall+0x144/0x1f0
> [    0.359150] [c0000003f8c03cd0] [c000000000a746a8]
> .kernel_init_freeable+0x23c/0x32c
> [    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0x1c/0x130
> [    0.359175] [c0000003f8c03e30] [c00000000000a164]
> .ret_from_kernel_thread+0x64/0x80
> [    0.359184] Instruction dump:
> [    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb0 60000000
> 3c62ff8c
> [    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810070
> a1240008 4bffff80
> [    0.359241] ---[ end trace c949de754c984735 ]---
> 
> CAI Qian
