Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811Ab3DBG2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:28:13 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48887 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3DBG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:28:11 -0400
Date: Tue, 2 Apr 2013 02:28:10 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Message-ID: <1484037905.443048.1364884090669.JavaMail.root@redhat.com>
In-Reply-To: <1539073339.442884.1364883991962.JavaMail.root@redhat.com>
Subject: NULL pointer at kset_find_obj
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: NULL pointer at kset_find_obj
Thread-Index: bZ12fFygStQSLsWDLp531oNvZ/mh+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just booted the latest mainline,

[   35.217698] Request for unknown module key 'Magrathea: Glacier signing key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11 
[   35.218511] BUG: unable to handle kernel paging request at ffffffffa03093f0 
[   35.218521] IP: [<ffffffff81304710>] kset_find_obj+0x30/0x80 
[   35.218524] PGD 1915067 PUD 1916063 PMD 7aa7c067 PTE 0 
[   35.218527] Oops: 0000 [#1] SMP  
[   35.218540] Modules linked in: kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   35.218547] CPU 2  
[   35.218547] Pid: 379, comm: systemd-udevd Tainted: GF            3.9.0-rc5+ #1 Dell Inc. PowerEdge M605/0NC596 
[   35.218550] RIP: 0010:[<ffffffff81304710>]  [<ffffffff81304710>] kset_find_obj+0x30/0x80 
[   35.218552] RSP: 0018:ffff88011a429d78  EFLAGS: 00010287 
[   35.218553] RAX: ffffffffa03093f8 RBX: ffffffffa03093f0 RCX: ffffffffa03cd7d8 
[   35.218554] RDX: 000000000000006b RSI: ffffffffa03d4099 RDI: ffff88007c396c19 
[   35.218555] RBP: ffff88011a429d98 R08: 00000000ffff8000 R09: 0000000000007fff 
[   35.218556] R10: 0000000000000001 R11: ffffc90004d9964a R12: ffff88011c13b9f8 
[   35.218557] R13: ffffffffa03d4098 R14: 0000000000000005 R15: ffff88011a429ee8 
[   35.218559] FS:  00007ffe5be08880(0000) GS:ffff88007dc80000(0000) knlGS:0000000000000000 
[   35.218560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[   35.218561] CR2: ffffffffa03093f0 CR3: 000000011afa9000 CR4: 00000000000007e0 
[   35.218562] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[   35.218563] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[   35.218565] Process systemd-udevd (pid: 379, threadinfo ffff88011a428000, task ffff88011ad31ac0) 
[   35.218566] Stack: 
[   35.218570]  0000000000000000 ffffffffa03d4098 0000000000000000 ffffffffa03d4080 
[   35.218572]  ffff88011a429ed8 ffffffff810c827d ffffffff81321880 ffffc90004deefff 
[   35.218575]  ffff88011d00c138 ffffc90004def000 8000000000000163 ffff88011ad31ac0 
[   35.218575] Call Trace: 
[   35.218583]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00 
[   35.218587]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   35.218593]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   35.218596]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   35.218601]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 
[   35.218619] Code: 55 49 89 f5 41 54 49 89 fc 48 8d 7f 10 53 48 83 ec 08 e8 54 3c 32 00 49 8b 04 24 49 39 c4 48 8d 58 f8 74 28 0f 1f 80 00 00 00 00 <48> 8b 3b 48 85 ff 74 0c 4c 89 ee e8 b0 4e 00 00 85 c0 74 24 48  
[   35.218621] RIP  [<ffffffff81304710>] kset_find_obj+0x30/0x80 
[   35.218622]  RSP <ffff88011a429d78> 
[   35.218623] CR2: ffffffffa03093f0 
[   35.218626] ---[ end trace a2c34ee98fb28306 ]--- 
[   35.242163] BUG: unable to handle kernel paging request at ffffffffa03093f0 
[   35.242172] IP: [<ffffffff81303fb0>] kobject_get_path+0x20/0xf0 
[   35.242175] PGD 1915067 PUD 1916063 PMD 7aa7c067 PTE 0 
[   35.242178] Oops: 0000 [#2] SMP  
[   35.242192] Modules linked in: edac_mce_amd(F+) kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   35.242200] CPU 1  
[   35.242201] Pid: 383, comm: systemd-udevd Tainted: GF     D      3.9.0-rc5+ #1 Dell Inc. PowerEdge M605/0NC596 
[   35.242204] RIP: 0010:[<ffffffff81303fb0>]  [<ffffffff81303fb0>] kobject_get_path+0x20/0xf0 
[   35.242205] RSP: 0018:ffff88011c0adc68  EFLAGS: 00010292 
[   35.242206] RAX: ffff88011b595668 RBX: ffffffffa03093f0 RCX: 0000000000000000 
[   35.242207] RDX: 0000000000000000 RSI: 00000000000000d0 RDI: ffffffffa03093f0 
[   35.242208] RBP: ffff88011c0adc98 R08: ffff88007d806f40 R09: ffff88007d806f40 
[   35.242209] R10: ffff88011d000c40 R11: 0000000000000001 R12: 0000000000000001 
[   35.242210] R13: 00000000000000d0 R14: ffffffffa03093f0 R15: ffff88011c13b9f8 
[   35.242212] FS:  00007ffe5be08880(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000 
[   35.242213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[   35.242214] CR2: ffffffffa03093f0 CR3: 000000011bab1000 CR4: 00000000000007e0 
[   35.242216] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[   35.242217] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[   35.242218] Process systemd-udevd (pid: 383, threadinfo ffff88011c0ac000, task ffff88011a4c8000) 
[   35.242219] Stack: 
[   35.242224]  0000000000000000 0000000000000001 ffffffff81647130 ffffffffa03093f0 
[   35.242226]  0000000000000000 ffff88011c13b9f8 ffff88011c0add38 ffffffff81304ce6 
[   35.242229]  0000000000000018 0000000000000246 ffffffff81c8b2e2 0000000000000023 
[   35.242230] Call Trace: 
[   35.242233]  [<ffffffff81304ce6>] kobject_uevent_env+0x166/0x610 
[   35.242236]  [<ffffffff8130519b>] kobject_uevent+0xb/0x10 
[   35.242238]  [<ffffffff81303bca>] kobject_cleanup+0xca/0x1b0 
[   35.242241]  [<ffffffff81303a0b>] kobject_put+0x2b/0x60 
[   35.242247]  [<ffffffff810c8af4>] load_module+0x1384/0x1b00 
[   35.242252]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   35.242259]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   35.242262]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   35.242268]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 
[   35.242285] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 49 89 fe 41 55 41 89 f5 41 54 41 bc 01 00 00 00 53 48 89 fb 48 83 ec 08 <48> 8b 3b 48 85 ff 0f 84 94 00 00 00 e8 7f 57 00 00 48 8b 5b 18  
[   35.242287] RIP  [<ffffffff81303fb0>] kobject_get_path+0x20/0xf0 
[   35.242288]  RSP <ffff88011c0adc68> 
[   35.242289] CR2: ffffffffa03093f0 
[   35.242293] ---[ end trace a2c34ee98fb28307 ]--- 
[   35.265175] Request for unknown module key 'Magrathea: Glacier signing key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11 
[   35.520324] Request for unknown module key 'Magrathea: Glacier signing key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11 
[   35.786703] Request for unknown module key 'Magrathea: Glacier signing key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11 
[-- MARK -- Mon Apr  1 04:05:01 2013] 
[   60.200012] BUG: soft lockup - CPU#1 stuck for 23s! [systemd-udevd:357] 
[   60.200012] Modules linked in: bnx2(F+) dcdbas(F+) edac_mce_amd(F+) kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   60.200012] CPU 1  
[   60.200012] Pid: 357, comm: systemd-udevd Tainted: GF     D      3.9.0-rc5+ #1 Dell Inc. PowerEdge M605/0NC596 
[   60.200012] RIP: 0010:[<ffffffff81628372>]  [<ffffffff81628372>] _raw_spin_lock+0x22/0x30 
[   60.200012] RSP: 0018:ffff88007a90fd68  EFLAGS: 00000293 
[   60.200012] RAX: 000000000000013b RBX: ffff88007d804480 RCX: ffffffffa0339a38 
[   60.274008] BUG: soft lockup - CPU#2 stuck for 23s! [systemd-udevd:373] 
[   60.274014] Modules linked in: bnx2(F+) dcdbas(F+) edac_mce_amd(F+) kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   60.274014] CPU 2  
[   60.274014] Pid: 373, comm: systemd-udevd Tainted: GF     D      3.9.0-rc5+ #1 Dell Inc. PowerEdge M605/0NC596 
[   60.274014] RIP: 0010:[<ffffffff81628372>]  [<ffffffff81628372>] _raw_spin_lock+0x22/0x30 
[   60.274014] RSP: 0018:ffff88011b793d68  EFLAGS: 00000297 
[   60.274014] RAX: 000000000000013b RBX: ffffffff81648fc0 RCX: 0000000000000000 
[   60.274014] RDX: 000000000000013c RSI: ffffffffa0302058 RDI: ffff88011c13ba08 
[   60.274014] RBP: ffff88011b793d68 R08: 00000000ffff8000 R09: 0000000000007fff 
[   60.274014] R10: 0000000000000001 R11: ffffc90004798672 R12: ffff880000000002 
[   60.274014] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000 
[   60.274014] FS:  00007ffe5be08880(0000) GS:ffff88007dc80000(0000) knlGS:0000000000000000 
[   60.274014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[   60.274014] CR2: ffffffffa03093f0 CR3: 000000011be25000 CR4: 00000000000007e0 
[   60.274014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[   60.274014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[   60.274014] Process systemd-udevd (pid: 373, threadinfo ffff88011b792000, task ffff88011ad9d040) 
[   60.274014] Stack: 
[   60.274014]  ffff88011b793d98 ffffffff813046fc 0000000000000000 ffffffffa0302058 
[   60.274014]  0000000000000000 ffffffffa0302040 ffff88011b793ed8 ffffffff810c827d 
[   60.274014]  ffffffff81321880 ffffc9000479dfff ffff88011d00c120 ffffc9000479e000 
[   60.274014] Call Trace: 
[   60.274014]  [<ffffffff813046fc>] kset_find_obj+0x1c/0x80 
[   60.274014]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00 
[   60.274014]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   60.274014]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   60.274014]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   60.274014]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 
[   60.274014] Code: 90 90 90 90 90 90 90 90 90 66 66 66 66 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0e 0f 1f 40 00 f3 90 <0f> b7 07 66 39 d0 75 f6 5d c3 0f 1f 40 00 66 66 66 66 90 55 48  
[   60.348015] BUG: soft lockup - CPU#3 stuck for 23s! [systemd-udevd:454] 
[   60.348015] Modules linked in: bnx2(F+) dcdbas(F+) edac_mce_amd(F+) kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
[   60.348015] CPU 3  
[   60.348015] Pid: 454, comm: systemd-udevd Tainted: GF     D      3.9.0-rc5+ #1 Dell Inc. PowerEdge M605/0NC596 
[   60.348015] RIP: 0010:[<ffffffff81628375>]  [<ffffffff81628375>] _raw_spin_lock+0x25/0x30 
[   60.348015] RSP: 0018:ffff88011b0bbd68  EFLAGS: 00000293 
[   60.348015] RAX: 000000000000013b RBX: ffffffff81648fc0 RCX: 0000000000000000 
[   60.348015] RDX: 000000000000013d RSI: ffffffffa02e5398 RDI: ffff88011c13ba08 
[   60.348015] RBP: ffff88011b0bbd68 R08: 00000000ffff8000 R09: 0000000000007fff 
[   60.348015] R10: 0000000000000001 R11: ffffc900047b3172 R12: ffff880000000002 
[   60.348015] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000 
[   60.348015] FS:  00007ffe5be08880(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000 
[   60.348015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[   60.348015] CR2: 00007ffe5bc54000 CR3: 000000011b09d000 CR4: 00000000000007e0 
[   60.348015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[   60.348015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[   60.348015] Process systemd-udevd (pid: 454, threadinfo ffff88011b0ba000, task ffff88011a1c0000) 
[   60.348015] Stack: 
[   60.348015]  ffff88011b0bbd98 ffffffff813046fc 0000000000000000 ffffffffa02e5398 
[   60.348015]  0000000000000000 ffffffffa02e5380 ffff88011b0bbed8 ffffffff810c827d 
[   60.348015]  ffffffff81321880 ffffc900047b6fff ffff88011d00c120 ffffc900047b7000 
[   60.348015] Call Trace: 
[   60.348015]  [<ffffffff813046fc>] kset_find_obj+0x1c/0x80 
[   60.348015]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00 
[   60.348015]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   60.348015]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   60.348015]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   60.348015]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 
[   60.348015] Code: 90 90 90 90 90 90 66 66 66 66 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0e 0f 1f 40 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 66  
[   60.200012] RDX: 000000000000013e RSI: ffffffffa033a278 RDI: ffff88011c13ba08 
[   60.200012] RBP: ffff88007a90fd68 R08: 00000000ffff8000 R09: 0000000000007fff 
[   60.200012] R10: 0000000000000001 R11: ffffc90004813a72 R12: 00000000000000d0 
[   60.200012] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88011ffa1340 
[   60.200012] FS:  00007ffe5be08880(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000 
[   60.200012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[   60.200012] CR2: 00007ffe5bc54000 CR3: 000000006a5f6000 CR4: 00000000000007e0 
[   60.200012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[   60.200012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[   60.200012] Process systemd-udevd (pid: 357, threadinfo ffff88007a90e000, task ffff88006a5c1ac0) 
[   60.200012] Stack: 
[   60.200012]  ffff88007a90fd98 ffffffff813046fc 0000000000000000 ffffffffa033a278 
[   60.200012]  0000000000000000 ffffffffa033a260 ffff88007a90fed8 ffffffff810c827d 
[   60.200012]  ffffffff81321880 ffffc9000481dfff ffff88011d00c128 ffffc9000481e000 
[   60.200012] Call Trace: 
[   60.200012]  [<ffffffff813046fc>] kset_find_obj+0x1c/0x80 
[   60.200012]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00 
[   60.200012]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   60.200012]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   60.200012]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   60.200012]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 

CAI Qian
