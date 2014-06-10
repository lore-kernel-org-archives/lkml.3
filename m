Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaFJPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:52:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:50625 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaFJPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:52:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="353074726"
Date: Tue, 10 Jun 2014 09:51:42 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <1402392038-5268-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406100945250.4699@AMR>
References: <1402392038-5268-1-git-send-email-m@bjorling.me> <1402392038-5268-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1635435661-1402415503=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1635435661-1402415503=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 10 Jun 2014, Matias Bjørling wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.
>

I'd like to run xfstests on this, but it is failing mkfs.xfs. I honestly
don't know much about this area, but I think this may be from the recent
chunk sectors patch causing a __bio_add_page to reject adding a new page.

[  762.968002] ------------[ cut here ]------------
[  762.973238] kernel BUG at fs/direct-io.c:753!
[  762.978189] invalid opcode: 0000 [#1] SMP
[  762.983003] Modules linked in: nvme parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp llc jfs joydev hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd microcode pcspkr ehci_pci ehci_hcd usbcore lpc_ich ioatdma mfd_core usb_common acpi_cpufreq i2c_i801 evdev wmi tpm_tis ipmi_si tpm ipmi_msghandler processor thermal_sys button ext4 crc16 jbd2 mbcache dm_mod nbd sg sr_mod cdrom sd_mod crc_t10dif crct10dif_common isci libsas ahci igb libahci scsi_transport_sas ptp pps_core libata i2c_algo_bit i2c_core scsi_mod dca
[  763.066172] CPU: 0 PID: 12870 Comm: mkfs.xfs Not tainted 3.15.0-rc8+ #13
[  763.073735] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[  763.085290] task: ffff88042809c510 ti: ffff880423c58000 task.ti: ffff880423c58000
[  763.093728] RIP: 0010:[<ffffffff81142ddf>]  [<ffffffff81142ddf>] dio_send_cur_page+0xa1/0xa8
[  763.103325] RSP: 0018:ffff880423c5ba68  EFLAGS: 00010202
[  763.109333] RAX: 0000000000000001 RBX: ffff880423c5bbf8 RCX: 0000000000001000
[  763.117410] RDX: 0000000000000001 RSI: ffff88042e4c8f00 RDI: ffff8804274e7008
[  763.125487] RBP: ffff88042834b0c0 R08: 0000000000000000 R09: 0000000000000006
[  763.133569] R10: 0000000000000006 R11: ffff880423c5b8d0 R12: ffff880423c5bb90
[  763.141645] R13: 0000000000001000 R14: 0000000000000000 R15: 000000002e939002
[  763.149720] FS:  00007f6052596740(0000) GS:ffff88043f600000(0000) knlGS:0000000000000000
[  763.158891] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  763.165411] CR2: 0000000001a23000 CR3: 0000000420638000 CR4: 00000000000407f0
[  763.173495] Stack:
[  763.175848]  ffff880423c5bbf8 ffff88042834b0c0 ffffea000e530cc0 ffffffff81142e8e
[  763.184543]  ffff88042834b0c0 ffff880400000000 0000000000000006 ffff88042834b0c0
[  763.193245]  0000000000000008 ffffea000e530cc0 0000000000000000 0000000000000000
[  763.201949] Call Trace:
[  763.204793]  [<ffffffff81142e8e>] ? submit_page_section+0xa8/0x112
[  763.211809]  [<ffffffff8114388c>] ? do_blockdev_direct_IO+0x7da/0xad8
[  763.219124]  [<ffffffff810e74b8>] ? zone_statistics+0x46/0x79
[  763.225659]  [<ffffffff810d7766>] ? get_page_from_freelist+0x625/0x727
[  763.233064]  [<ffffffff811409b1>] ? I_BDEV+0x8/0x8
[  763.238516]  [<ffffffff81140cc5>] ? blkdev_direct_IO+0x52/0x57
[  763.245134]  [<ffffffff811409b1>] ? I_BDEV+0x8/0x8
[  763.250601]  [<ffffffff810d1749>] ? generic_file_direct_write+0xe2/0x145
[  763.258193]  [<ffffffff810d18ea>] ? __generic_file_aio_write+0x13e/0x225
[  763.265782]  [<ffffffff81140c00>] ? blkdev_aio_write+0x42/0xa6
[  763.272417]  [<ffffffff8111801a>] ? do_sync_write+0x50/0x73
[  763.278752]  [<ffffffff81118b36>] ? vfs_write+0x9f/0xfc
[  763.284706]  [<ffffffff81118f48>] ? SyS_pwrite64+0x66/0x8c
[  763.290952]  [<ffffffff8139fe12>] ? system_call_fastpath+0x16/0x1b
[  763.297958] Code: 89 ef e8 a0 fd ff ff 48 8b 53 78 49 8d 4c 24 30 48 89 de 48 89 ef e8 87 fc ff ff 85 c0 75 0e 48 89 df e8 17 ff ff ff 85 c0 74 cd <0f> 0b 5b 5d 41 5c c3 41 57 4d 89 cf 41 56 41 89 ce 41 55 45 89
[  763.324319] RIP  [<ffffffff81142ddf>] dio_send_cur_page+0xa1/0xa8
[  763.331311]  RSP <ffff880423c5ba68>
[  763.335359] ---[ end trace d57f8af6b5f01282 ]---
--8323328-1635435661-1402415503=:4699--
