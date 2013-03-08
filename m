Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3CHXrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852Ab3CHXrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:47:17 -0500
Date: Fri, 8 Mar 2013 18:47:14 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308234714.GA4642@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
 <20130308192042.GA10305@redhat.com>
 <20130308193652.GA11692@redhat.com>
 <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com>
 <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com>
 <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
 <CA+55aFw=v3uBZUfzUePThL_=+qteoTqg20_ZumaDkCvX90AzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=v3uBZUfzUePThL_=+qteoTqg20_ZumaDkCvX90AzkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 03:28:01PM -0800, Linus Torvalds wrote:
 > Oh, btw, I'm assuming you're testing current git like you usually do.
 > 
 > If so, just to humor me, can you try plain 3.8 (or 3.8.2 or whatever
 > the current stable kernel is). Because while the oopses may be due to
 > your extensions to trinity, let's make sure. Maybe something bad
 > happened in the merge window, and we're just wasting time trying to
 > figure it out, when it could be just bisected...
 > 
 > The pipe and symlink BUG_ON() bugs you've found are likely real and
 > old, so keep the patches for those around, but let's just verify that
 > the BUG_ON(nd->inode != parent->d_inode);" is old too.
 > 
 > I suspect it's a real and old bug, and that you'll be able to recreate
 > it with the stable kernels too, but just to make sure..
 > 
 >                 Linus

That didn't take long..

[  163.807774] kernel BUG at fs/namei.c:1446!
[  163.807837] invalid opcode: 0000 [#1] SMP 
[  163.807910] Modules linked in: ipt_ULOG af_key irda crc_ccitt nfc pppoe pppox ppp_generic slhc atm lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep btusb snd_seq snd_seq_device snd_pcm bluetooth ppdev snd_page_alloc rfkill microcode usb_debug serio_raw k10temp edac_core edac_mce_amd snd_timer sp5100_tco snd soundcore i2c_piix4 r8169 lm63 mii parport_pc parport vhost_net tun macvtap macvlan kvm_amd kvm ata_generic pata_acpi firewire_ohci firewire_core pata_atiixp crc_itu_t radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core wmi
[  163.809090] CPU 1 
[  163.809126] Pid: 5831, comm: trinity-child1 Not tainted 3.8.1-201.fc18.x86_64.debug #1 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  163.809303] RIP: 0010:[<ffffffff8171232d>]  [<ffffffff8171232d>] lookup_slow+0x25/0xad
[  163.809424] RSP: 0018:ffff8800cf895d08  EFLAGS: 00010212
[  163.809499] RAX: ffff8801129db790 RBX: ffff8800cf895e48 RCX: 00000000000002e0
[  163.809595] RDX: ffff8800cf895d98 RSI: ffff8800cf895e58 RDI: ffff8800cf895e48
[  163.809691] RBP: ffff8800cf895d38 R08: 0000000000000001 R09: 0000000000000001
[  163.809787] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000010
[  163.809883] R13: ffff8800cf4e46f0 R14: 00000000ffffff9c R15: ffff8800cf895e48
[  163.809981] FS:  00007f2416788740(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
[  163.810091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  163.810170] CR2: 0000000002222000 CR3: 0000000036eda000 CR4: 00000000000007e0
[  163.810269] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.810367] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  163.810464] Process trinity-child1 (pid: 5831, threadinfo ffff8800cf894000, task ffff880111ff8000)
[  163.810582] Stack:
[  163.810614]  ffffea000324ac00 0000000000000000 0000000000000001 0000000000000010
[  163.810737]  0000000000000000 00000000ffffff9c ffff8800cf895de8 ffffffff811e8ced
[  163.810859]  0000000000000000 ffffffff81a0bb2c ffff8800cf895d88 00000000000000d0
[  163.810982] Call Trace:
[  163.811026]  [<ffffffff811e8ced>] path_lookupat+0x74d/0x770
[  163.811108]  [<ffffffff811bcfe8>] ? kmem_cache_alloc+0xe8/0x350
[  163.811195]  [<ffffffff810d69cf>] ? lock_release_holdtime.part.26+0xf/0x180
[  163.811294]  [<ffffffff811e8d44>] filename_lookup+0x34/0xc0
[  163.811374]  [<ffffffff811ebb9e>] user_path_at_empty+0x8e/0x110
[  163.811507]  [<ffffffff81021e49>] ? sched_clock+0x9/0x10
[  163.811586]  [<ffffffff810ae555>] ? sched_clock_cpu+0xc5/0x120
[  163.811694]  [<ffffffff810d606d>] ? trace_hardirqs_off+0xd/0x10
[  163.811779]  [<ffffffff810ae61f>] ? local_clock+0x6f/0x80
[  163.811857]  [<ffffffff811ebc31>] user_path_at+0x11/0x20
[  163.811935]  [<ffffffff81203e58>] sys_lgetxattr+0x38/0x90
[  163.812014]  [<ffffffff81724799>] system_call_fastpath+0x16/0x1b
[  163.812096] Code: 55 48 89 e5 0f 0b 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 48 83 ec 10 4c 8b 6f 08 48 8b 47 30 49 3b 45 30 74 02 <0f> 0b 48 8d b8 e8 00 00 00 49 89 f6 31 f6 49 89 d4 e8 3d 4d 00 
[  163.812748] RIP  [<ffffffff8171232d>] lookup_slow+0x25/0xad
[  163.812833]  RSP <ffff8800cf895d08>
[  163.813040] ---[ end trace f67521cc7acbb145 ]---

