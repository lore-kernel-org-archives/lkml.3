Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaGVTsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:48:07 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41189 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbaGVTsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:48:05 -0400
Message-ID: <53CEBFF2.7050100@hurleysoftware.com>
Date: Tue, 22 Jul 2014 15:48:02 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: PANIC: ata_qc_new_init crashes at boot
References: <CAEuXFEy5=0XkqPiWQNiGbpi5EHSzq5f_U7Sj0t2bhO_1Lqe5vw@mail.gmail.com>
In-Reply-To: <CAEuXFEy5=0XkqPiWQNiGbpi5EHSzq5f_U7Sj0t2bhO_1Lqe5vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Tejun ]

On 07/22/2014 03:26 PM, Jesse Brandeburg wrote:
> This is a repeatable panic, happens every boot (and prevents starting my system)
> 
> .config attached, built from commit 15ba2236f3556fc01b9ca91394465152b5ea74b6
> 
> 
> 
> [    8.732993] sd 6:0:1:0: [sdb] Attached SCSI disk
> [    8.733857]  sda: sda1 sda2 sda3
> [    8.734318] sd 6:0:0:0: [sda] Attached SCSI disk
> [    8.737943] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000058
> [    8.737947] IP: [<ffffffff814e0618>] ata_qc_new_init+0x188/0x1b0
> [    8.737948] PGD 0
> [    8.737949] Oops: 0002 [#1] SMP
> [    8.737953] Modules linked in: isci libsas scsi_transport_sas
> mgag200 drm_kms_helper ttm
> [    8.737955] CPU: 1 PID: 518 Comm: udevd Not tainted 3.16.0-rc6+ #62
> [    8.737956] Hardware name: Intel Corporation S2600CO/S2600CO, BIOS
> SE5C600.86B.02.02.0002.122320131210 12/23/2013
> [    8.737956] task: ffff880c1a00b280 ti: ffff88061a000000 task.ti:
> ffff88061a000000
> [    8.737958] RIP: 0010:[<ffffffff814e0618>]  [<ffffffff814e0618>]
> ata_qc_new_init+0x188/0x1b0
> [    8.737959] RSP: 0018:ffff88061a003ae8  EFLAGS: 00010012
> [    8.737959] RAX: 0000000000000001 RBX: ffff88000241ca80 RCX: 00000000000000fa
> [    8.737960] RDX: 0000000000000020 RSI: 0000000000000020 RDI: ffff8806194aa298
> [    8.737960] RBP: ffff88061a003ae8 R08: ffff8806194a8000 R09: 0000000000000000
> [    8.737961] R10: 0000000000000000 R11: ffff88000241ca80 R12: ffff88061ad58200
> [    8.737961] R13: ffff8806194aa298 R14: ffffffff814e67a0 R15: ffff8806194a8000
> [    8.737962] FS:  00007f3ad7fe3840(0000) GS:ffff880627620000(0000)
> knlGS:0000000000000000
> [    8.737963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.737963] CR2: 0000000000000058 CR3: 000000061a118000 CR4: 00000000001407e0
> [    8.737964] Stack:
> [    8.737965]  ffff88061a003b20 ffffffff814e96e1 ffff88000241ca80
> ffff88061ad58200
> [    8.737966]  ffff8800b6bf6000 ffff880c1c988000 ffff880619903850
> ffff88061a003b68
> [    8.737967]  ffffffffa0056ce1 ffff88061a003b48 0000000013d6e6f8
> ffff88000241ca80
> [    8.737968] Call Trace:
> [    8.737971]  [<ffffffff814e96e1>] ata_sas_queuecmd+0xa1/0x430
> [    8.737976]  [<ffffffffa0056ce1>] sas_queuecommand+0x191/0x220 [libsas]
> [    8.737978]  [<ffffffff8149afee>] scsi_dispatch_cmd+0x10e/0x300
> [    8.737981]  [<ffffffff814a3bc5>] scsi_request_fn+0x2f5/0x550
> [    8.737983]  [<ffffffff81317613>] __blk_run_queue+0x33/0x40
> [    8.737985]  [<ffffffff8131781a>] queue_unplugged+0x2a/0x90
> [    8.737986]  [<ffffffff8131ceb4>] blk_flush_plug_list+0x1b4/0x210
> [    8.737988]  [<ffffffff8131d274>] blk_finish_plug+0x14/0x50
> [    8.737990]  [<ffffffff8117eaa8>] __do_page_cache_readahead+0x198/0x1f0
> [    8.737991]  [<ffffffff8117ee21>] force_page_cache_readahead+0x31/0x50
> [    8.737992]  [<ffffffff8117ee7e>] page_cache_sync_readahead+0x3e/0x50
> [    8.737995]  [<ffffffff81172ac6>] generic_file_read_iter+0x496/0x5a0
> [    8.737998]  [<ffffffff81219897>] blkdev_read_iter+0x37/0x40
> [    8.738002]  [<ffffffff811e307e>] new_sync_read+0x7e/0xb0
> [    8.738004]  [<ffffffff811e3734>] vfs_read+0x94/0x170
> [    8.738006]  [<ffffffff811e43c6>] SyS_read+0x46/0xb0
> [    8.738007]  [<ffffffff811e33d1>] ? SyS_lseek+0x91/0xb0
> [    8.738011]  [<ffffffff8171ee29>] system_call_fastpath+0x16/0x1b
> [    8.738021] Code: 00 00 00 88 50 29 83 7f 08 01 19 d2 83 e2 f0 83
> ea 50 88 50 34 c6 81 1d 02 00 00 40 c6 81 17 02 00 00 00 5d c3 66 0f
> 1f 44 00 00 <89> 14 25 58 00 00 00
> [    8.738023] RIP  [<ffffffff814e0618>] ata_qc_new_init+0x188/0x1b0
> [    8.738023]  RSP <ffff88061a003ae8>
> [    8.738023] CR2: 0000000000000058
> [    8.738025] ---[ end trace 831868baa88bb368 ]---
> 

