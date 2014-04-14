Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaDNLSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:18:06 -0400
Received: from smtp.ispras.ru ([83.149.199.79]:41716 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaDNLSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:18:03 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 07:18:02 EDT
Message-ID: <534BC29B.3020408@ispras.ru>
Date: Mon, 14 Apr 2014 15:12:27 +0400
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: f2fs: BUG_ON() is triggered when mount valid f2fs filesystem
References: <52F320FC.50803@ispras.ru>
In-Reply-To: <52F320FC.50803@ispras.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When mount this f2fs image: 
http://linuxtesting.org/downloads/f2fs_fault_image.zip
BUG_ON is triggered in f2fs driver (messages below are generated on 
kernel 3.13.2; for other kernels output is similar):

[ 2416.364463] kernel BUG at fs/f2fs/node.c:215!
[ 2416.364464] invalid opcode: 0000 [#1] SMP
[ 2416.364466] Modules linked in: f2fs fuse ip6t_rpfilter ip6t_REJECT 
xt_conntrack bnep bluetooth rfkill ebtable_nat ebtable_broute bridge stp 
llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security 
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle 
iptable_security iptable_raw vboxsf(OF) snd_intel8x0 snd_ac97_codec 
ac97_bus snd_seq snd_seq_device ppdev snd_pcm snd_page_alloc snd_timer 
snd e1000 joydev soundcore microcode serio_raw parport_pc parport 
vboxvideo(OF) drm i2c_piix4 i2c_core vboxguest(OF) ata_generic pata_acpi
[ 2416.364493] CPU: 0 PID: 2117 Comm: mount Tainted: GF O 3.10.11fs #4
[ 2416.364494] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[ 2416.364496] task: ffff8800304d3fc0 ti: ffff88000dbae000 task.ti: 
ffff88000dbae000
[ 2416.364497] RIP: 0010:[<ffffffffa0329f2e>] [<ffffffffa0329f2e>] 
set_node_addr.clone.1+0x1de/0x270 [f2fs]
[ 2416.364503] RSP: 0018:ffff88000dbafaa8 EFLAGS: 00010202
[ 2416.364504] RAX: ffff880034bc0030 RBX: ffff88000dbafaf8 RCX: 
0000000000000000
[ 2416.364505] RDX: 0000000000000000 RSI: 0000000000000005 RDI: 
0000000000000000
[ 2416.364505] RBP: ffff88000dbafae8 R08: ffff880034bc0030 R09: 
ffff88000860e6e8
[ 2416.364506] R10: 0000000000000001 R11: 000000000084642a R12: 
ffff88001f617020
[ 2416.364507] R13: ffff88001f617000 R14: ffff88001f617010 R15: 
00000000ffffffff
[ 2416.364509] FS: 00007f8597b25880(0000) GS:ffff88003fc00000(0000) 
knlGS:0000000000000000
[ 2416.364510] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2416.364511] CR2: 00007ffc645020b0 CR3: 000000003c699000 CR4: 
00000000000006f0
[ 2416.364514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2416.364515] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 2416.364516] Stack:
[ 2416.364517] 01fa000000000400 ffff88001f617000 ffff88000dbafae8 
ffff880033900000
[ 2416.364519] ffffea0000ddbec0 ffff8800339008f8 ffff88003bc4b000 
ffff880000000000
[ 2416.364521] ffff88000dbafb68 ffffffffa032ebad 0000000500000005 
000000000001fa00
[ 2416.364523] Call Trace:
[ 2416.364528] [<ffffffffa032ebad>] recover_inode_page+0x1fd/0x3e0 [f2fs]
[ 2416.364531] [<ffffffff811446e7>] ? __lock_page+0x67/0x70
[ 2416.364535] [<ffffffff81089990>] ? autoremove_wake_function+0x50/0x50
[ 2416.364538] [<ffffffffa0337788>] recover_fsync_data+0x1398/0x15d0 [f2fs]
[ 2416.364541] [<ffffffff812b9e5c>] ? selinux_d_instantiate+0x1c/0x20
[ 2416.364544] [<ffffffff811cb20b>] ? d_instantiate+0x5b/0x80
[ 2416.364547] [<ffffffffa0321044>] f2fs_fill_super+0xb04/0xbf0 [f2fs]
[ 2416.364549] [<ffffffff811b861e>] ? mount_bdev+0x7e/0x210
[ 2416.364551] [<ffffffff811b8769>] mount_bdev+0x1c9/0x210
[ 2416.364554] [<ffffffffa0320540>] ? validate_superblock+0x210/0x210 [f2fs]
[ 2416.364557] [<ffffffffa031cf8d>] f2fs_mount+0x1d/0x30 [f2fs]
[ 2416.364559] [<ffffffff811b9497>] mount_fs+0x47/0x1c0
[ 2416.364562] [<ffffffff81166e00>] ? __alloc_percpu+0x10/0x20
[ 2416.364564] [<ffffffff811d4032>] vfs_kern_mount+0x72/0x110
[ 2416.364566] [<ffffffff811d6763>] do_mount+0x493/0x910
[ 2416.364568] [<ffffffff811615cb>] ? strndup_user+0x5b/0x80
[ 2416.364570] [<ffffffff811d6c70>] SyS_mount+0x90/0xe0
[ 2416.364573] [<ffffffff8166f8d9>] system_call_fastpath+0x16/0x1b
[ 2416.364574] Code: a0 24 02 00 01 48 8b 13 48 89 50 18 48 8b 53 08 48 
89 50 20 48 8b 53 10 48 89 50 28 48 83 7b 08 00 74 c4 48 83 05 82 24 02 
00 01 <0f> 0b 48 83 05 80 24 02 00 01 48 83 05 58 24 02 00 01 0f 0b 48
[ 2416.364595] RIP [<ffffffffa0329f2e>] 
set_node_addr.clone.1+0x1de/0x270 [f2fs]
[ 2416.364598] RSP <ffff88000dbafaa8>
[ 2416.364600] ---[ end trace d203dddb09f4fc3d ]---

Found by Linux File System Verification project (linuxtesting.org).


fsck.f2fs reports that given filesystem is valid.

Moreover, on kernels 3.13.2, 3.14 mount continues to fail(with same 
error) even after these operations on given filesystem's image:

mkfs -t f2fs <img>
mount -t f2fs -omand <img> <mount-point>
touch <mount-point>/file.txt
setfacl <mount-point>/file.txt
umount <mount-point>

Initial filesystem's content for above operations is important: if one 
applies them to zero-filled or one-filled image, resulted filesystem is 
mounted successfully.



-- 
Best regards,
Andrey Tsyvarev
Linux Verification Center, ISPRAS
web: http://linuxtesting.org

-- 
Andrey Tsyvarev<tsyvarev@ispras.ru>

