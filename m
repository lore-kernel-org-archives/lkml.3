Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaFCN4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:56:50 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:53133 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFCN4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:56:48 -0400
Message-ID: <538DD41A.7040107@bjorling.me>
Date: Tue, 03 Jun 2014 15:56:42 +0200
From: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: willy@linux.intel.com, sbradshaw@micron.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
References: <1401742510-10827-1-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406021642480.11244@AMR> <alpine.LRH.2.03.1406021702530.11244@AMR>
In-Reply-To: <alpine.LRH.2.03.1406021702530.11244@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 01:06 AM, Keith Busch wrote:
> Depending on the timing, it might fail in alloc instead of free:
>
> Jun  2 16:45:40 kbgrz1 kernel: [  265.421243] NULL pointer dereference
> at           (null)
> Jun  2 16:45:40 kbgrz1 kernel: [  265.434284] PGD 429acf067 PUD
> 42ce28067 PMD 0
> Jun  2 16:45:40 kbgrz1 kernel: [  265.439565] Oops: 0000 [#1] SMP
> Jun  2 16:45:40 kbgrz1 kernel: [  265.443413] Modules linked in: nvme
> parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss
> oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp
> llc jfs joydev hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal
> coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul
> ablk_helper cryptd ehci_pci ehci_hcd microcode usbcore pcspkr ioatdma
> lpc_ich usb_common mfd_core i2c_i801 evdev wmi acpi_cpufreq tpm_tis
> ipmi_si tpm ipmi_msghandler processor thermal_sys button ext4 crc16 jbd2
> mbcache dm_mod nbd sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common
> isci libsas igb ahci scsi_transport_sas libahci ptp libata pps_core
> i2c_algo_bit i2c_core scsi_mod dca
> Jun  2 16:45:40 kbgrz1 kernel: [  265.526398] CPU: 4 PID: 5454 Comm:
> nvme_id_ctrl Not tainted 3.15.0-rc1+ #2
> Jun  2 16:45:40 kbgrz1 kernel: [  265.534181] Hardware name: Intel
> Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210
> 12/23/2013
> Jun  2 16:45:40 kbgrz1 kernel: [  265.545789] task: ffff88042e418390 ti:
> ffff8804283e6000 task.ti: ffff8804283e6000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.554270] RIP:
> 0010:[<ffffffff811c51b8>]  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
> Jun  2 16:45:40 kbgrz1 kernel: [  265.563720] RSP:
> 0018:ffff8804283e7d80  EFLAGS: 00010286
> Jun  2 16:45:40 kbgrz1 kernel: [  265.569755] RAX: 0000000000000000 RBX:
> ffff880035a06008 RCX: 00000000000f4240
> Jun  2 16:45:40 kbgrz1 kernel: [  265.577830] RDX: 000000000028a360 RSI:
> 0000000000000000 RDI: ffff880035a06008
> Jun  2 16:45:40 kbgrz1 kernel: [  265.585904] RBP: ffff88043f680000 R08:
> 0000000000000000 R09: 0000000000001000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.593979] R10: 0000000000001000 R11:
> 0000000000000410 R12: 00000000000000d0
> Jun  2 16:45:40 kbgrz1 kernel: [  265.602053] R13: 0000000000000001 R14:
> 0000000000000000 R15: 0000000000000000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.610134] FS:
> 00007f74b8bc9700(0000) GS:ffff88043f680000(0000) knlGS:0000000000000000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.619303] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Jun  2 16:45:40 kbgrz1 kernel: [  265.625824] CR2: 0000000000000000 CR3:
> 00000004292c4000 CR4: 00000000000407e0
> Jun  2 16:45:40 kbgrz1 kernel: [  265.633889] Stack:
> Jun  2 16:45:40 kbgrz1 kernel: [  265.636236]  ffffffff811c689f
> 0000000000000000 00000000fffffff4 ffff8804283e7e10
> Jun  2 16:45:40 kbgrz1 kernel: [  265.644949]  ffff8804283e7e94
> 000000000000007d 00007fff4f8a73b0 0000000000000000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.653653]  ffffffffa055acc7
> 0000000000000246 000000002d0aaec0 ffff88042d0aaec0
> Jun  2 16:45:40 kbgrz1 kernel: [  265.662358] Call Trace:
> Jun  2 16:45:40 kbgrz1 kernel: [  265.665194]  [<ffffffff811c689f>] ?
> blk_mq_alloc_request+0x54/0xd5
> Jun  2 16:45:40 kbgrz1 kernel: [  265.672217]  [<ffffffffa055acc7>] ?
> __nvme_submit_admin_cmd+0x2d/0x68 [nvme]
> Jun  2 16:45:40 kbgrz1 kernel: [  265.680196]  [<ffffffffa055c879>] ?
> nvme_user_admin_cmd+0x144/0x1b1 [nvme]
> Jun  2 16:45:40 kbgrz1 kernel: [  265.687987]  [<ffffffffa055c903>] ?
> nvme_dev_ioctl+0x1d/0x2b [nvme]
> Jun  2 16:45:40 kbgrz1 kernel: [  265.695107]  [<ffffffff81125916>] ?
> do_vfs_ioctl+0x3f2/0x43b
> Jun  2 16:45:40 kbgrz1 kernel: [  265.701547]  [<ffffffff8105ca6b>] ?
> finish_task_switch+0x84/0xc4
> Jun  2 16:45:40 kbgrz1 kernel: [  265.708382]  [<ffffffff81394a8c>] ?
> __schedule+0x45c/0x4f0
> Jun  2 16:45:40 kbgrz1 kernel: [  265.714603]  [<ffffffff811259ad>] ?
> SyS_ioctl+0x4e/0x7d
> Jun  2 16:45:40 kbgrz1 kernel: [  265.720555]  [<ffffffff8139c6d2>] ?
> system_call_fastpath+0x16/0x1b
> Jun  2 16:45:40 kbgrz1 kernel: [  265.727560] Code: 8b 4a 38 48 39 4e 38
> 72 12 74 06 b8 01 00 00 00 c3 48 8b 4a 60 48 39 4e 60 73 f0 c3 66 66 66
> 66 90 48 8b 87 e0 00 00 00 48 63 f6 <8b> 14 b0 48 8b 87 f8 00 00 00 48
> 8b 04 d0 c3 89 ff f0 48 0f ab
> Jun  2 16:45:40 kbgrz1 kernel: [  265.760706]  RSP <ffff8804283e7d80>
> Jun  2 16:45:40 kbgrz1 kernel: [  265.764705] CR2: 0000000000000000
> Jun  2 16:45:40 kbgrz1 kernel: [  265.768531] ---[ end trace
> 785048a51785f51e ]---
>
> On Mon, 2 Jun 2014, Keith Busch wrote:
>> On Mon, 2 Jun 2014, Matias Bjørling wrote:
>>> Hi Matthew and Keith,
>>>
>>> Here is an updated patch with the feedback from the previous days.
>>> It's against
>>> Jens' for-3.16/core tree. You may use the nvmemq_wip_review branch at:
>>
>> I'm testing this on my normal hardware now. As I feared, hot removal
>> doesn't work while the device is actively being managed. Here's the oops:
>>
>> [ 1267.018283] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000004
>> [ 1267.018288] IP: [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
>> [ 1267.018292] PGD b5ed5067 PUD b57e2067 PMD 0
>> [ 1267.018294] Oops: 0000 [#1] SMP
>> [ 1267.018343] Modules linked in: nvme parport_pc ppdev lp parport dlm
>> sctp libcrc32c configfs nfsd auth_rpcgss oid_registry nfs_acl nfs
>> lockd fscache sunrpc md4 hmac cifs bridge stp llc joydev jfs
>> hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp
>> kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32c_intel
>> ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul
>> ablk_helper cryptd microcode ehci_pci ehci_hcd usbcore pcspkr lpc_ich
>> acpi_cpufreq ioatdma mfd_core usb_common i2c_i801 evdev wmi ipmi_si
>> tpm_tis ipmi_msghandler tpm processor thermal_sys button ext4 crc16
>> jbd2 mbcache dm_mod nbd sg sr_mod cdrom sd_mod crc_t10dif
>> crct10dif_common isci libsas ahci scsi_transport_sas libahci igb
>> libata ptp pps_core i2c_algo_bit scsi_mod i2c_core dca [last unloaded:
>> nvme]
>> [ 1267.018346] CPU: 1 PID: 6618 Comm: nvme_id_ctrl Tainted: G        W
>> 3.15.0-rc1+ #2
>> [ 1267.018347] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS
>> SE5C600.86B.02.02.0002.122320131210 12/23/2013
>> [ 1267.018349] task: ffff88042879eef0 ti: ffff8800b5f14000 task.ti:
>> ffff8800b5f14000
>> [ 1267.018354] RIP: 0010:[<ffffffff811c51b8>]  [<ffffffff811c51b8>]
>> blk_mq_map_queue+0xf/0x1e
>> [ 1267.018356] RSP: 0018:ffff8800b5f15db0  EFLAGS: 00010206
>> [ 1267.018357] RAX: 0000000000000000 RBX: ffffe8fbffa21e80 RCX:
>> ffff88042f3952e0
>> [ 1267.018359] RDX: 0000000000001c10 RSI: 0000000000000001 RDI:
>> ffff8800b5e9f008
>> [ 1267.018360] RBP: ffff88042d993480 R08: ffff8800b5e18cc0 R09:
>> 0000000000000000
>> [ 1267.018362] R10: 0000000000000ca0 R11: 0000000000000ca0 R12:
>> ffff8800b5f15e94
>> [ 1267.018363] R13: 0000000000003a98 R14: 00007fffc7b44c40 R15:
>> 0000000000000000
>> [ 1267.018365] FS:  00007feb4cb05700(0000) GS:ffff88043f620000(0000)
>> knlGS:0000000000000000
>> [ 1267.018367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 1267.018369] CR2: 0000000000000004 CR3: 00000000b50f2000 CR4:
>> 00000000000407e0
>> [ 1267.018369] Stack:
>> [ 1267.018372]  ffffffff811c6334 00000000fffffffc ffff88042d993480
>> 00000000fffffffc
>> [ 1267.018375]  ffffffffa0532d73 0000000000000ca0 00000000fffffff4
>> ffff88042562b440
>> [ 1267.018378]  ffff88042d853000 0000000000001000 ffffffffa05348f3
>> ffffc9001518b2a8
>> [ 1267.018378] Call Trace:
>> [ 1267.018383]  [<ffffffff811c6334>] ? blk_mq_free_request+0x37/0x48
>> [ 1267.018388]  [<ffffffffa0532d73>] ?
>> __nvme_submit_admin_cmd+0x7f/0x8a [nvme]
>> [ 1267.018392]  [<ffffffffa05348f3>] ? nvme_user_admin_cmd+0x144/0x1b1
>> [nvme]
>> [ 1267.018397]  [<ffffffffa053497d>] ? nvme_dev_ioctl+0x1d/0x2b [nvme]
>> [ 1267.018399]  [<ffffffff81125916>] ? do_vfs_ioctl+0x3f2/0x43b
>> [ 1267.018402]  [<ffffffff8105ca6b>] ? finish_task_switch+0x84/0xc4
>> [ 1267.018406]  [<ffffffff81394a8c>] ? __schedule+0x45c/0x4f0
>> [ 1267.018408]  [<ffffffff811259ad>] ? SyS_ioctl+0x4e/0x7d
>> [ 1267.018411]  [<ffffffff8139c6d2>] ? system_call_fastpath+0x16/0x1b
>> [ 1267.018435] Code: 8b 4a 38 48 39 4e 38 72 12 74 06 b8 01 00 00 00
>> c3 48 8b 4a 60 48 39 4e 60 73 f0 c3 66 66 66 66 90 48 8b 87 e0 00 00
>> 00 48 63 f6 <8b> 14 b0 48 8b 87 f8 00 00 00 48 8b 04 d0 c3 89 ff f0 48
>> 0f ab
>> [ 1267.018438] RIP  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
>> [ 1267.018439]  RSP <ffff8800b5f15db0>
>> [ 1267.018440] CR2: 0000000000000004
>> [ 1267.018443] ---[ end trace 1e244ae5f3ceb23b ]---
>>

Thanks. I'll look into it.
