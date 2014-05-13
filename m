Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbaEMNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:36:47 -0400
Received: from mail2.charite.de ([141.42.206.200]:33200 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176AbaEMNgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:36:45 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 09:36:45 EDT
Date: Tue, 13 May 2014 15:27:06 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: "BUG: soft lockup", always with the same call trace (interpretation
 needed)
Message-ID: <20140513132706.GN13352@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I keep getting the same "BUG: soft lockup", always with the same call
trace - what exactly could be causing this?

[18546.997502] BUG: soft lockup - CPU#3 stuck for 22s! [imap-login:69073]
[18546.998273] Modules linked in: st sr_mod cdrom binfmt_misc fuse btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus hfs minix vfat msdos
fat jfs xfs libcrc32c reiserfs iptable_filter ip_tables x_tables bonding joydev hid_generic iTCO_wdt iTCO_vendor_support gpio_ich
x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul pcspkr usbhid ses enclosure acpi_cpufreq mperf wmi isci igb ptp libsas pps_core
scsi_transport_sas button mei_me lpc_ich ioatdma mei i2c_i801 mfd_core shpchp dca sg loop ghash_clmulni_intel crc32c_intel aesni_intel
ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 autofs4 linear mgag200 ttm drm_kms_helper ehci_pci drm ehci_hcd i2c_algo_bit
sysimgblt sysfillrect usbcore syscopyarea usb_common megaraid_sas processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
[18546.998328]  scsi_dh dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod [last unloaded: cpuid]
[18546.998336] CPU: 3 PID: 69073 Comm: imap-login Not tainted 3.11.10-7-default #1
[18546.998337] Hardware name: Supermicro X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.0a 12/04/2013
[18546.998339] task: ffff8800421383c0 ti: ffff880cbc1be000 task.ti: ffff880cbc1be000
[18546.998341] RIP: 0010:[<ffffffff8155d6cd>]  [<ffffffff8155d6cd>] _raw_spin_lock+0x1d/0x30
[18546.998347] RSP: 0018:ffff880cbc1bf8d0  EFLAGS: 00000293
[18546.998349] RAX: 0000000000005313 RBX: ffff8806f90ab318 RCX: 000000000000531f
[18546.998350] RDX: 000000000000531f RSI: 0000000000000000 RDI: ffff880c41b82480
[18546.998352] RBP: ffff880c41b82000 R08: a038000000000000 R09: 06f90ab1501c0000
[18546.998353] R10: f8e8f70cf2905407 R11: ffff88187ffe9d80 R12: ffff880c42da3400
[18546.998355] R13: ffff8803a0892920 R14: 0000000000000000 R15: 0000000000000000
[18546.998357] FS:  00002b1ba53f2cc0(0000) GS:ffff880c7fc60000(0000) knlGS:0000000000000000
[18546.998358] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18546.998360] CR2: 00002af5f7c72cf0 CR3: 0000000583107000 CR4: 00000000001407e0
[18546.998361] Stack:
[18546.998362]  ffffffff8122c57c ffff8806f90ab0b0 ffff8806f90ab1b8 ffffffff8120e1e8
[18546.998367]  ffff8806f90ab0b0 ffffffff81193af3 ffff880cbc1bf940 ffff88018d5ad530
[18546.998370]  ffff880c42da3508 ffffffff81193c11 ffff88018d5ad5a0 ffffffff81194a1c
[18546.998374] Call Trace:
[18546.998383]  [<ffffffff8122c57c>] ext4_es_lru_del+0x1c/0x60
[18546.998390]  [<ffffffff8120e1e8>] ext4_clear_inode+0x38/0x80
[18546.998395]  [<ffffffff81193af3>] evict+0xa3/0x190
[18546.998400]  [<ffffffff81193c11>] dispose_list+0x31/0x40
[18546.998403]  [<ffffffff81194a1c>] prune_icache_sb+0x16c/0x310
[18546.998409]  [<ffffffff8117ebeb>] prune_super+0x15b/0x190
[18546.998416]  [<ffffffff81128883>] shrink_slab+0x153/0x2d0
[18546.998421]  [<ffffffff8112b69f>] do_try_to_free_pages+0x39f/0x4c0
[18546.998426]  [<ffffffff8112b898>] try_to_free_pages+0xd8/0x160
[18546.998433]  [<ffffffff81121899>] __alloc_pages_nodemask+0x5c9/0x980
[18546.998439]  [<ffffffff8115a86d>] alloc_pages_current+0x9d/0x170
[18546.998445]  [<ffffffff814641cb>] sk_page_frag_refill+0x5b/0x100
[18546.998452]  [<ffffffff814b63ce>] tcp_sendmsg+0x2ee/0xd70
[18546.998460]  [<ffffffff8145fcdf>] sock_aio_write+0x12f/0x150
[18546.998466]  [<ffffffff8117ac27>] do_sync_write+0x67/0x90
[18546.998470]  [<ffffffff8117b3a5>] vfs_write+0x1b5/0x1e0
[18546.998475]  [<ffffffff8117bcb3>] SyS_write+0x43/0xa0
[18546.998480]  [<ffffffff815652ed>] system_call_fastpath+0x1a/0x1f
[18546.998487]  [<00002b1ba5d9d9e0>] 0x2b1ba5d9d9df
[18546.998489] Code: 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 b8 00 00 01 00 f0 0f c1 07 89 c1 c1 e9 10 66 39 c1 89 ca 74 0d 0f 1f 00 f3
90 0f b7 07 <66> 39 d0 75 f6 c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 53 48 

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
