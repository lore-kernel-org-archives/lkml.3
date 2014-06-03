Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbaFCWXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:23:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:60920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153AbaFCWXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:23:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,969,1392192000"; 
   d="scan'208";a="522263095"
Date: Tue, 3 Jun 2014 16:23:23 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>, willy@linux.intel.com,
        sbradshaw@micron.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
In-Reply-To: <538E2C2E.1010500@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406031553280.11244@AMR>
References: <1401742510-10827-1-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406021642480.11244@AMR> <alpine.LRH.2.03.1406021702530.11244@AMR> <538E2C2E.1010500@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Matias Bjorling wrote:
>
> Keith, will you take the nvmemq_wip_v6 branch for a spin? Thanks!

Still fails as before:

[   88.933881] BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
[   88.942900] IP: [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[   88.949605] PGD 427be0067 PUD 425495067 PMD 0
[   88.954915] Oops: 0000 [#1] SMP
[   88.958787] Modules linked in: nvme parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp llc joydev jfs hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd microcode ehci_pci ehci_hcd pcspkr usbcore lpc_ich ioatdma usb_common mfd_core evdev i2c_i801 wmi acpi_cpufreq tpm_tis tpm ipmi_si ipmi_msghandler processor thermal_sys button ext4 crc16 jbd2 mbcache dm_mod nbd sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common isci ahci libsas igb libahci scsi_transport_sas ptp pps_core i2c_algo_bit libata i2c_core scsi_mod dca
[   89.042529] CPU: 5 PID: 4544 Comm: nvme_id_ctrl Not tainted 3.15.0-rc1+ #3
[   89.050295] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[   89.061856] task: ffff88042bbdb0d0 ti: ffff88042c24c000 task.ti: ffff88042c24c000
[   89.070305] RIP: 0010:[<ffffffff811c51b8>]  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[   89.079747] RSP: 0018:ffff88042c24dda0  EFLAGS: 00010202
[   89.085795] RAX: 0000000000000000 RBX: ffffe8fbffaa1b00 RCX: ffff88042e8ec4b0
[   89.093868] RDX: 0000000000008be6 RSI: 0000000000000005 RDI: ffff88042abdf048
[   89.101950] RBP: ffff88042c2b81c0 R08: ffff88042c24c000 R09: ffff880035c58410
[   89.110033] R10: ffff88043f6b2dc0 R11: ffff88043f6b2dc0 R12: ffff88042c24de94
[   89.118119] R13: 000000000000007d R14: 00007fff0cd892b0 R15: 0000000000000000
[   89.126210] FS:  00007f39866c5700(0000) GS:ffff88043f6a0000(0000) knlGS:0000000000000000
[   89.135387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.141916] CR2: 0000000000000014 CR3: 000000042b387000 CR4: 00000000000407e0
[   89.149997] Stack:
[   89.152353]  ffffffff811c6334 00000000fffffffc ffff88042c2b81c0 ffff88042c24de10
[   89.161096]  ffffffffa054dcbb 0000000000000246 00000000fffffffc ffff8800b5e05cc0
[   89.169839]  00000000fffffff4 ffff8800b5e05cc0 ffff88042bbc3000 0000000000001000
[   89.178583] Call Trace:
[   89.181429]  [<ffffffff811c6334>] ? blk_mq_free_request+0x37/0x48
[   89.188360]  [<ffffffffa054dcbb>] ? __nvme_submit_admin_cmd+0x52/0x68 [nvme]
[   89.196349]  [<ffffffffa054f761>] ? nvme_user_admin_cmd+0x144/0x1b1 [nvme]
[   89.204150]  [<ffffffffa054f7eb>] ? nvme_dev_ioctl+0x1d/0x2b [nvme]
[   89.211278]  [<ffffffff81125916>] ? do_vfs_ioctl+0x3f2/0x43b
[   89.217710]  [<ffffffff81117e35>] ? vfs_write+0xde/0xfc
[   89.223657]  [<ffffffff811259ad>] ? SyS_ioctl+0x4e/0x7d
[   89.229622]  [<ffffffff8139c6d2>] ? system_call_fastpath+0x16/0x1b
[   89.236636] Code: 8b 4a 38 48 39 4e 38 72 12 74 06 b8 01 00 00 00 c3 48 8b 4a 60 48 39 4e 60 73 f0 c3 66 66 66 66 90 48 8b 87 e0 00 00 00 48 63 f6 <8b> 14 b0 48 8b 87 f8 00 00 00 48 8b 04 d0 c3 89 ff f0 48 0f ab
[   89.263435] RIP  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[   89.270237]  RSP <ffff88042c24dda0>
[   89.274237] CR2: 0000000000000014
[   89.278095] ---[ end trace 54c0e8cbb1fe2ec3 ]---
