Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3IJRO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:14:29 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59709 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3IJRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:14:27 -0400
MIME-Version: 1.0
Date: Tue, 10 Sep 2013 13:14:26 -0400
X-Google-Sender-Auth: fHBNqn2YkYrenLBbrgvU94asjuo
Message-ID: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
Subject: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        moneta.mace@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a user report a backtrace from hitting the
BUG_ON(!ret->d_lockref.count) added with the lockref infrastructure
(commit 98474236f72) on rawhide today[1].  I've grabbed the backtrace
below.  The user has btrfs, NFS, and sshfs in usage with this oops.

I've not seen anything similar, but I could have missed it.  Does this
look familiar to anyone?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1006472

kernel: [ 765.817482] ------------[ cut here ]------------
kernel: [ 765.818426] kernel BUG at fs/dcache.c:648!
kernel: [ 765.818426] invalid opcode: 0000 [#1] SMP
kernel: [ 765.818426] Modules linked in: rpcsec_gss_krb5 nfsv4
dns_resolver nfs fscache fuse rfcomm bnep ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack w83627ehf
hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec coretemp
kvm_intel snd_hwdep kvm snd_seq snd_seq_device snd_pcm iTCO_wdt
iTCO_vendor_support microcode serio_raw i2c_i801 lpc_ich mfd_core
btusb bluetooth r8169 rfkill mii snd_page_alloc shpchp snd_timer snd
soundcore acpi_cpufreq nfsd auth_rpcgss uinput nfs_acl lockd sunrpc
binfmt_misc ata_generic pata_acpi btrfs libcrc32c xor raid1 raid0
raid6_pq i915 firewire_ohci firewire_core crc_itu_t video pata_it8213
i2c_algo_bit drm_kms_helper drm i2c_dev i2c_core
kernel: [ 765.818426] CPU: 0 PID: 13007 Comm: gkrellm Not tainted
3.12.0-0.rc0.git16.2.fc21.x86_64 #1
kernel: [ 765.818426] Hardware name: Supermicro C2SEA/C2SEA, BIOS 1.0c
03/11/2009
kernel: [ 765.818426] task: ffff8801a1ff6c80 ti: ffff8801cb902000
task.ti: ffff8801cb902000
kernel: [ 765.818426] RIP: 0010:[<ffffffff811c03cd>]
[<ffffffff811c03cd>] dget_parent+0x6d/0x80
kernel: [ 765.818426] RSP: 0018:ffff8801cb903c38 EFLAGS: 00010246
kernel: [ 765.818426] RAX: 0000000000000000 RBX: ffff88022baca600 RCX:
00000000cced6f6f
kernel: [ 765.818426] RDX: 000000000000006f RSI: 0000000000000000 RDI:
ffff88022baca658
kernel: [ 765.818426] RBP: ffff8801cb903c50 R08: 8080808080808080 R09:
fefefefefefefeff
kernel: [ 765.818426] R10: 2f2f2f2f2f2f2f2f R11: 722e7172742e2d2d R12:
ffff88022bb2bd80
kernel: [ 765.818426] R13: ffff88022baca658 R14: ffff8801a1ff6c80 R15:
0000000000000002
kernel: [ 765.818426] FS: 00007fbda2e39a00(0000)
GS:ffff880237c00000(0000) knlGS:0000000000000000
kernel: [ 765.818426] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [ 765.818426] CR2: 000000000042f860 CR3: 00000001a1d26000 CR4:
00000000000007f0
kernel: [ 765.818426] Stack:
kernel: [ 765.818426] ffff8801cb903de0 ffff88022bb2bd80
0000000000000000 ffff8801cb903c70
kernel: [ 765.818426] ffffffff811b5508 ffff8801cb903de0
ffff88023761b003 ffff8801cb903d10
kernel: [ 765.818426] ffffffff811b6225 0000000000000000
000201da00000000 ffff8801a1ff6c80
kernel: [ 765.818426] Call Trace:
kernel: [ 765.818426] [<ffffffff811b5508>] handle_dots+0x1c8/0x290
kernel: [ 765.818426] [<ffffffff811b6225>] link_path_walk+0x335/0x8a0
kernel: [ 765.818426] [<ffffffff8113ed21>] ? read_cache_page+0x21/0x30
kernel: [ 765.818426] [<ffffffff811b6bb4>] path_lookupat+0x334/0x7b0
kernel: [ 765.818426] [<ffffffff811b705b>] filename_lookup+0x2b/0xd0
kernel: [ 765.818426] [<ffffffff811baa64>] user_path_at_empty+0x54/0x90
kernel: [ 765.818426] [<ffffffff811baab1>] user_path_at+0x11/0x20
kernel: [ 765.818426] [<ffffffff811af2d0>] vfs_fstatat+0x50/0xa0
kernel: [ 765.818426] [<ffffffff811af4cf>] SYSC_newstat+0x1f/0x40
kernel: [ 765.818426] [<ffffffff810e7cc6>] ? __audit_syscall_exit+0x1f6/0x2a0
kernel: [ 765.818426] [<ffffffff811af91e>] SyS_newstat+0xe/0x10
kernel: [ 765.818426] [<ffffffff81667a19>] system_call_fastpath+0x16/0x1b
kernel: [ 765.818426] Code: 18 4c 8d 6b 58 4c 89 ef e8 b1 ef 49 00 49
3b 5c 24 18 75 19 8b 43 5c 85 c0 74 10 83 c0 01 89 43 5c 41 80 45 00
01 48 89 d8 eb c2 <0f> 0b 80 43 58 01 eb c9 66 66 2e 0f 1f 84 00 00 00
00 00 66 66
kernel: [ 765.818426] RIP [<ffffffff811c03cd>] dget_parent+0x6d/0x80
kernel: [ 765.818426] RSP <ffff8801cb903c38>
kernel: [ 765.929977] ---[ end trace 384aa993d7ac57c0 ]---
