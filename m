Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211AbaGCQRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:17:51 -0400
Received: from smtp.gaealink.net ([108.166.122.24]:37027 "EHLO
	smtp.gaealink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaGCQRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:17:48 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 12:17:47 EDT
Message-ID: <53B57FF1.8000307@julianfamily.org>
Date: Thu, 03 Jul 2014 09:08:17 -0700
From: Joe Julian <joe@julianfamily.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mpt2sas stuck installing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a knox enclosure with an unresponsive drive. When the mpt2sas 
module is loaded the module loading process hangs. modprobe/insmod is 
stuck and any further attempts to load modules also hang. By 
blacklisting the module and loading it last, I can get the computer to 
boot, but attempting to manually load the module will still hang. When I 
shut down, I get the following:

[55473.508343] mpt2sas1: _config_request: timeout
[55474.510395] BUG: unable to handle kernel paging request at 
ffffc90020ae0000
[55474.513048] IP: [<ffffffffa03c00f0>] 
mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
[55474.525196] PGD 103f80c067 PUD 203f003067 PMD 1026dca067 PTE 0
[55474.526115] Oops: 0000 [#1] SMP
[55474.527837] Modules linked in: raid456 async_pq async_xor xor 
async_memcpy async_raid6_recov raid6_pq async_tx ses enclosure mpt2sas 
raid_class rdma_ucm ib_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm 
ib_uverbs ib_umad mlx4_en mlx4_ib(-) ib_sa ib_mad ib_core coretemp 
mlx4_core kvm_intel kvm 8021q garp stp ghash_clmulni_intel llc 
aesni_intel ablk_helper cryptd nfsd lrw aes_x86_64 xts psmouse gf128mul 
sb_edac nfs_acl auth_rpcgss edac_core mei microcode serio_raw mac_hid lp 
lpc_ich nfs fscache parport lockd sunrpc ext2 isci libsas ahci libahci 
e1000e scsi_transport_sas [last unloaded: mlx4_core]
[55474.538831] CPU 2
[55474.539218] Pid: 3516, comm: scsi_eh_10 Not tainted 3.8.0-38-generic 
#56~precise1-Ubuntu Quanta F03R /Winterfell
[55474.541004] RIP: 0010:[<ffffffffa03c00f0>] [<ffffffffa03c00f0>] 
mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
[55474.542772] RSP: 0018:ffff881019a39ae8  EFLAGS: 00010246
[55474.543590] RAX: ffffc90020ae0000 RBX: ffff88100fd1e6b0 RCX: 
0000000000000000
[55474.546285] RDX: ffff881019a39fd8 RSI: 0000000000000001 RDI: 
ffff88100fd1e6b0
[55474.548451] RBP: ffff881019a39ae8 R08: 0000000000000000 R09: 
0000000000000000
[55474.549585] R10: 00000000000007db R11: 00000000000007da R12: 
0000000000000001
[55474.550689] R13: ffff881019a39bbc R14: 000000000000ffff R15: 
ffff881019a39c80
[55474.551791] FS:  0000000000000000(0000) GS:ffff88103fc40000(0000) 
knlGS:0000000000000000
[55474.553044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55474.553928] CR2: ffffc90020ae0000 CR3: 0000000001c0d000 CR4: 
00000000000407e0
[55474.555187] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[55474.557030] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[55474.558139] Process scsi_eh_10 (pid: 3516, threadinfo 
ffff881019a38000, task ffff8810257b5d00)
[55474.560748] Stack:
[55474.561069]  ffff881019a39b98 ffffffffa03c183a 0000000000000006 
0000000000000006
[55474.562218]  ffff88100fd1eb00 ffff88100fd1eaf8 ffff88100fd1e6d0 
0000000000000000
[55474.563343]  ffff881019a30000 ffffffff8105b3ea ffff88100fd1ead8 
0000000000000000
[55474.564595] Call Trace:
[55474.565003]  [<ffffffffa03c183a>] 
_config_request.constprop.5+0x15a/0x590 [mpt2sas]
[55474.568223]  [<ffffffff8105b3ea>] ? console_unlock+0x1a/0x30
[55474.569896]  [<ffffffffa03c2a3a>] 
mpt2sas_config_get_expander_pg0+0x8a/0xf0 [mpt2sas]
[55474.571322]  [<ffffffffa03c589c>] 
_scsih_search_responding_expanders+0x5c/0xe0 [mpt2sas]
[55474.572582]  [<ffffffffa03c4599>] ? 
_scsih_search_responding_sas_devices+0xa9/0xc0 [mpt2sas]
[55474.573912]  [<ffffffffa03cd43e>] 
mpt2sas_scsih_reset_handler+0xbe/0x1a0 [mpt2sas]
[55474.575191]  [<ffffffffa03bf91f>] _base_reset_handler+0x1f/0x40 [mpt2sas]
[55474.576250]  [<ffffffffa03c0d9e>] 
mpt2sas_base_hard_reset_handler+0x1ae/0x1e0 [mpt2sas]
[55474.577500]  [<ffffffffa03c499c>] _scsih_host_reset+0x5c/0xb0 [mpt2sas]
[55474.578554]  [<ffffffff814ac2f3>] scsi_try_host_reset+0x53/0x110
[55474.579729]  [<ffffffff814adbbc>] scsi_eh_host_reset+0x4c/0x170
[55474.580764]  [<ffffffff814ae532>] scsi_eh_ready_devs+0x82/0xa0
[55474.581866]  [<ffffffff814aef2d>] scsi_unjam_host+0xed/0x1d0
[55474.584848]  [<ffffffff814af175>] scsi_error_handler+0x165/0x1c0
[55474.585984]  [<ffffffff814af010>] ? scsi_unjam_host+0x1d0/0x1d0
[55474.592375]  [<ffffffff8107f2e0>] kthread+0xc0/0xd0
[55474.594325]  [<ffffffff8107f220>] ? flush_kthread_worker+0xb0/0xb0
[55474.595654]  [<ffffffff816ff1ac>] ret_from_fork+0x7c/0xb0
[55474.598729]  [<ffffffff8107f220>] ? flush_kthread_worker+0xb0/0xb0
[55474.607501] Code: c7 c2 f8 7d 3d a0 48 c7 c7 52 ac 3d a0 31 c0 e8 f1 
de 31 e1 e9 f6 fe ff ff 66 90 66 66 66 66 90 55 48 8b 87 88 00 00 00 48 
89 e5 <8b> 00 89 c2 81 e2 00 00 00 f0 85 f6 0f 45 c2 5d c3 66 66 66 66
[55474.611823] RIP  [<ffffffffa03c00f0>] 
mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
[55474.613007]  RSP <ffff881019a39ae8>
[55474.613548] CR2: ffffc90020ae0000
[55474.614183] ---[ end trace a817d8e30eb9f07c ]---

