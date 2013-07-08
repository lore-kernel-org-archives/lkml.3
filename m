Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3GHVxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 17:53:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:55263 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 17:53:06 -0400
Message-ID: <1373320381.2320.2.camel@localhost.localdomain>
Subject: BUG in i915_gem_unmap_dma_buf?
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 08 Jul 2013 23:53:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jul 08 23:37:33 localhost.localdomain kernel: BUG: unable to handle kernel paging request at 0000000113b10038
Jul 08 23:37:33 localhost.localdomain kernel: IP: [<ffffffffa00f1eaf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
Jul 08 23:37:33 localhost.localdomain kernel: PGD 1135e0067 PUD 0 
Jul 08 23:37:33 localhost.localdomain kernel: Oops: 0000 [#1] SMP 
Jul 08 23:37:33 localhost.localdomain kernel: Modules linked in: rfcomm btusb fuse ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_
Jul 08 23:37:34 localhost.localdomain kernel:  cfg80211 rfkill atl1c snd_page_alloc snd_timer snd soundcore wmi uinput nfsd auth_rpcgss nfs_acl lockd binfmt_misc sunrpc udl drm_usb i915 i2c_algo_bit drm_kms_helper usb_storage drm i2c_core video
Jul 08 23:37:34 localhost.localdomain kernel: CPU 0 
Jul 08 23:37:34 localhost.localdomain kernel: Pid: 493, comm: Xorg Tainted: G          I  3.9.6-301.fc19.x86_64 #1 Acer Aspire 1810T/JM11-MS
Jul 08 23:37:34 localhost.localdomain kernel: RIP: 0010:[<ffffffffa00f1eaf>]  [<ffffffffa00f1eaf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
Jul 08 23:37:34 localhost.localdomain kernel: RSP: 0018:ffff88011a3c5ca8  EFLAGS: 00010293
Jul 08 23:37:34 localhost.localdomain kernel: RAX: 0000000113b10000 RBX: ffff880139295870 RCX: 0000000000000000
Jul 08 23:37:34 localhost.localdomain kernel: RDX: 0000000000000300 RSI: ffff8801100bd000 RDI: ffff88013796f030
Jul 08 23:37:34 localhost.localdomain kernel: RBP: ffff88011a3c5cb0 R08: 0000000000000000 R09: 0000000000000000
Jul 08 23:37:34 localhost.localdomain kernel: R10: ffffffff81ce2b30 R11: ffff880117803e10 R12: ffff880139295870
Jul 08 23:37:34 localhost.localdomain kernel: R13: 0000000000000000 R14: 0000000000000003 R15: ffff88011a3c5d70
Jul 08 23:37:34 localhost.localdomain kernel: FS:  00007ffdce953980(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jul 08 23:37:34 localhost.localdomain kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 08 23:37:34 localhost.localdomain kernel: CR2: 0000000113b10038 CR3: 00000001100ee000 CR4: 00000000000407f0
Jul 08 23:37:34 localhost.localdomain kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 08 23:37:34 localhost.localdomain kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 08 23:37:34 localhost.localdomain kernel: Process Xorg (pid: 493, threadinfo ffff88011a3c4000, task ffff88011a32ddc0)
Jul 08 23:37:34 localhost.localdomain kernel: Stack:
Jul 08 23:37:34 localhost.localdomain kernel:  ffff880112687dc0 ffff88011a3c5cd8 ffffffff813f37de ffff880112687dc0
Jul 08 23:37:34 localhost.localdomain kernel:  ffff880137674020 ffff880137674000 ffff88011a3c5cf8 ffffffffa0036ac2
Jul 08 23:37:34 localhost.localdomain kernel:  ffff880137d98f00 ffff880137674020 ffff88011a3c5d10 ffffffffa0062a95
Jul 08 23:37:34 localhost.localdomain kernel: Call Trace:
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff813f37de>] dma_buf_unmap_attachment+0x3e/0x60
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa0036ac2>] drm_prime_gem_destroy+0x22/0x40 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa0062a95>] udl_gem_free_object+0x35/0x60 [udl]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa00207fa>] drm_gem_object_free+0x2a/0x30 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa0020e2e>] drm_gem_object_release_handle+0xae/0xd0 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff812f19b4>] idr_for_each+0xa4/0xf0
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa0020d80>] ? drm_gem_vm_open+0x60/0x60 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa00214a0>] drm_gem_release+0x20/0x30 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffffa001fc21>] drm_release+0x551/0x5d0 [drm]
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8119aff1>] __fput+0xe1/0x230
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8119b1fe>] ____fput+0xe/0x10
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8107cefc>] task_work_run+0xbc/0xe0
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff810625d4>] do_exit+0x2b4/0xa20
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8119b1fe>] ? ____fput+0xe/0x10
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8107cee4>] ? task_work_run+0xa4/0xe0
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff81062dbf>] do_group_exit+0x3f/0xa0
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff81062e34>] sys_exit_group+0x14/0x20
Jul 08 23:37:34 localhost.localdomain kernel:  [<ffffffff8164ea99>] system_call_fastpath+0x16/0x1b
Jul 08 23:37:34 localhost.localdomain kernel: Code: 90 55 89 d1 48 89 e5 53 48 8b 7f 08 48 89 f3 8b 56 08 48 8b 36 48 85 ff 74 32 48 8b 87 00 02 00 00 48 85 c0 74 26 83 f9 02 77 2a <48> 8b 40 38 48 85 c0 74 05 45 31 c0 ff d0 48 89 df e8 fb f5 20 
Jul 08 23:37:34 localhost.localdomain kernel: RIP  [<ffffffffa00f1eaf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
Jul 08 23:37:34 localhost.localdomain kernel:  RSP <ffff88011a3c5ca8>
Jul 08 23:37:34 localhost.localdomain kernel: CR2: 0000000113b10038
Jul 08 23:37:34 localhost.localdomain kernel: ---[ end trace e815fd70dd00acb6 ]---
Jul 08 23:37:34 localhost.localdomain kernel: Fixing recursive fault but reboot is needed!


