Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3EOBLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:11:16 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51700 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3EOBLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:11:15 -0400
MIME-Version: 1.0
Date: Tue, 14 May 2013 18:11:14 -0700
X-Google-Sender-Auth: axa5ArjC8b4JjoPZfuktzGcvGBg
Message-ID: <CACKvgLFPNktU6OHfMnrn0do7ZjnLkYhU-oQBXGQRjgeWXNLsrw@mail.gmail.com>
Subject: NULL pointer dereference in inode_has_perm on 3.4
From: Vinson Lee <vlee@freedesktop.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm seeing a NULL pointer deference in inode_has_perm with Linux
kernel 3.4.27. Does anyone have any ideas what this issue might be? As
another point of reference, I've also seen this on 2.6.39.4.

[63314.399998] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000020
[63314.400270] IP: [<ffffffff8121f3f6>] inode_has_perm+0x1b/0x36
[63314.400471] PGD 610cad067 PUD 610cae067 PMD 0
[63314.400635] Oops: 0000 [#1] SMP
[63314.400756] CPU 7
[63314.400821] Modules linked in: ipv6 dm_multipath video sbs sbshc
hed acpi_pad acpi_memhotplug acpi_ipmi parport_pc lp parport tcp_diag
inet_diag ipmi_si ipmi_devintf ipmi_msghandler dell_rbu snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss joydev snd_pcm ioatdma snd_timer snd soundcore
snd_page_alloc igb pcspkr dca dcdbas i2c_i801 shpchp i2c_core iTCO_wdt
i7core_edac iTCO_vendor_support edac_core microcode
[63314.402381]
[63314.402435] Pid: 15274, comm: python2.6 Not tainted 3.4.27 #1 Dell
   C6100       /0D61XP
[63314.402740] RIP: 0010:[<ffffffff8121f3f6>]  [<ffffffff8121f3f6>]
inode_has_perm+0x1b/0x36
[63314.403012] RSP: 0018:ffff88032cba1ba8  EFLAGS: 00010246
[63314.403187] RAX: 0000000000000000 RBX: ffff8805d621ca20 RCX: ffff88032cba1bb8
[63314.403418] RDX: 0000000000800000 RSI: ffff8805d621ca20 RDI: ffff8805ee9c1500
[63314.403649] RBP: ffff88032cba1ba8 R08: 0000000000000080 R09: 0000000000000080
[63314.403880] R10: 0000000000800000 R11: ffff88032cba1b48 R12: ffff8805ee9c1500
[63314.404111] R13: 0000000000000081 R14: 0000000000000000 R15: ffff880183945b40
[63314.404343] FS:  0000000049bb5940(0063) GS:ffff88063fc60000(0000)
knlGS:0000000000000000
[63314.404604] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[63314.404791] CR2: 0000000000000020 CR3: 0000000610cac000 CR4: 00000000000007e0
[63314.405022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[63314.405253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[63314.405484] Process python2.6 (pid: 15274, threadinfo
ffff88032cba0000, task ffff880183945b40)
[63314.405762] Stack:
[63314.405831]  ffff88032cba1c18 ffffffff81220631 0000000000000009
0000000000000000
[63314.406096]  ffff8805d621ca20 0000000000000000 ffff88032cba1be8
0000000000000010
[63314.406359]  0000000000000000 0000000000000000 ffff88032cba1c48
ffff8805d621ca20
[63314.406623] Call Trace:
[63314.406710]  [<ffffffff81220631>] selinux_inode_permission+0x85/0x90
[63314.406920]  [<ffffffff8121ccf0>] security_inode_permission+0x1e/0x20
[63314.407133]  [<ffffffff81146d82>] inode_permission+0xd3/0xdf
[63314.407318]  [<ffffffff81146dfa>] link_path_walk+0x6c/0x4b4
[63314.407503]  [<ffffffff8114ecce>] ? dput+0x2f/0xe2
[63314.407661]  [<ffffffff811473cf>] ? path_init+0xd4/0x2ea
[63314.407836]  [<ffffffff8114763e>] path_lookupat+0x59/0x330
[63314.408019]  [<ffffffff8112cb73>] ? kmem_cache_alloc+0x31/0x103
[63314.408212]  [<ffffffff8114793d>] do_path_lookup+0x28/0xa4
[63314.408393]  [<ffffffff81149a3a>] user_path_at_empty+0x55/0x94
[63314.408586]  [<ffffffff81073878>] ? wake_up_state+0x10/0x12
[63314.408772]  [<ffffffff8108f727>] ? wake_futex+0x64/0x69
[63314.408947]  [<ffffffff8108f81c>] ? futex_wake+0xf0/0x102
[63314.409124]  [<ffffffff81149a8a>] user_path_at+0x11/0x13
[63314.409301]  [<ffffffff81140ab3>] vfs_fstatat+0x42/0x6d
[63314.409473]  [<ffffffff81140bd0>] vfs_stat+0x1b/0x1d
[63314.409636]  [<ffffffff81140bf1>] sys_newstat+0x1f/0x3d
[63314.409812]  [<ffffffff814e2f69>] system_call_fastpath+0x16/0x1b
[63314.410007] Code: fe 48 c7 40 68 07 00 00 00 e8 6c d8 f0 ff c9 c3
55 48 89 e5 66 66 66 66 90 31 c0 41 89 d2 f6 46 0d 02 75 20 48 8b 46
38 45 89 c1 <0f> b7 50 20 8b 70 1c 49 89 c8 48 8b 47 68 44 89 d1 8b 78
04 e8
[63314.410998] RIP  [<ffffffff8121f3f6>] inode_has_perm+0x1b/0x36
[63314.411195]  RSP <ffff88032cba1ba8>
[63314.411310] CR2: 0000000000000020
[63314.411846] ---[ end trace fa4043a7d7cc37e7 ]---

Cheers,
Vinson
