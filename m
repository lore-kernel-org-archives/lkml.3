Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaFWK7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:59:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:25830 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFWK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:59:32 -0400
X-Nat-Received: from [202.181.97.72]:42813 [ident-empty]
	by ksav111.sakura.ne.jp with TPROXY id 1403521159.32419
To: iamjoonsoo.kim@lge.com
Cc: ak@linux.intel.com, penberg@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [3.15-rc1 slab] Oops when reading /proc/slab_allocators
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404092036.CEF21247.VFSQFFMLOJOOtH@I-love.SAKURA.ne.jp>
	<20140410073918.GB8204@js1304-P5Q-DELUXE>
	<201404102054.BJI60908.OOFVLQFOSFHMJt@I-love.SAKURA.ne.jp>
	<20140416001049.GC14564@js1304-P5Q-DELUXE>
In-Reply-To: <20140416001049.GC14564@js1304-P5Q-DELUXE>
Message-Id: <201406231959.AEG78150.FJMtOFHLQSVFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 23 Jun 2014 19:59:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.705 status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim wrote:
> On Thu, Apr 10, 2014 at 08:54:37PM +0900, Tetsuo Handa wrote:
> > Joonsoo Kim wrote:
> > > There was another report about this problem and I have already fixed
> > > it, although it wasn't reviewed and merged. See following link.
> > > 
> > > https://lkml.org/lkml/2014/3/11/119
> > 
> > OK. That patch fixes this problem.
> > 
> > Commit b1cb0982 changed the way of walking objects, didn't it? Then,
> > it could happen that slab leak detector code walking all objects
> > triggers an oops.
> 
> Yeah, although it doesn't walks all objects, it walks non-active
> objects and it is problematic. This behaviour comes from my patches :)
> 
> > 
> > > In that time, I thought that this problem wasn't related to my patches,
> > > but your bisect report say that it is from my patches. I will dig into
> > > the problem more deeply as soon as possible and make proper fix.
> > 
> > I see. Here is a minimal kernel config and test script for qemu on CentOS 6.5.
> > http://I-love.SAKURA.ne.jp/tmp/config-pre-3.15-rc1-min
> 
> Thanks.
> I already sent another patch to fix this bug and cc'ed you.
> 
> Thanks.
> 

Hello.

I noticed that 3.16-rc2 shows the same bug.
Did you merge your patch for this bug into 3.15?

[   43.515887] BUG: unable to handle kernel paging request at ffff88003708aff8
[   43.519486] IP: [<ffffffff811c34ff>] handle_slab+0x8f/0x190
[   43.522267] PGD 31a5067 PUD 31a6067 PMD 7fc2b067 PTE 800000003708a060
[   43.525687] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   43.528033] Modules linked in: fuse ipv6 vhost_net macvtap macvlan vhost tun ppdev snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_seq dm_mod snd_seq_device snd_pcm snd_timer snd soundcore sg i2c_piix4 i2c_core parport_pc parport shpchp ext4(E) jbd2(E) mbcache(E) crc16(E) sd_mod(E) crc_t10dif(E) sr_mod(E) cdrom(E) vmxnet3(E) mptspi(E) mptscsih(E) mptbase(E) scsi_transport_spi(E) pata_acpi(E) ata_generic(E) ata_piix(E)
[   43.548360] CPU: 2 PID: 2088 Comm: cat Tainted: G        W   E 3.16.0-rc2 #401
[   43.551602] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[   43.555332] task: ffff880034a59250 ti: ffff880035de0000 task.ti: ffff880035de0000
[   43.557070] RIP: 0010:[<ffffffff811c34ff>]  [<ffffffff811c34ff>] handle_slab+0x8f/0x190
[   43.559095] RSP: 0018:ffff880035de3d88  EFLAGS: 00010002
[   43.560368] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff8800476e75c0
[   43.562051] RDX: ffffea0000dc2280 RSI: 0000000000000001 RDI: ffff88003c19a000
[   43.563736] RBP: ffff880035de3dd8 R08: ffff88003c19a000 R09: ffff88003c19a008
[   43.565454] R10: ffff88003c19a010 R11: 0000000000001000 R12: ffff880048c3ff00
[   43.567137] R13: ffff8800476e75c0 R14: ffff88003708a000 R15: ffffea0000dc2280
[   43.568898] FS:  00007ffdc37d1700(0000) GS:ffff880079600000(0000) knlGS:0000000000000000
[   43.570904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.572299] CR2: ffff88003708aff8 CR3: 00000000348ca000 CR4: 00000000000407e0
[   43.574082] Stack:
[   43.574598]  ffff8800476f1400 ffff8800476f1418 ffff8800476e75c0 0000000000000400
[   43.576500]  ffff880035de3dd8 ffff88003c19a000 ffff880048c3ff00 ffff8800476e75c0
[   43.576502]  0000000000000400 ffffea0000dc2280 ffff880035de3e48 ffffffff811c8bc6
[   43.576504] Call Trace:
[   43.576506]  [<ffffffff811c8bc6>] leaks_show+0xf6/0x270
[   43.576511]  [<ffffffff81200e8f>] seq_read+0x2af/0x440
[   43.576514]  [<ffffffff81245cb3>] proc_reg_read+0x43/0x70
[   43.576517]  [<ffffffff811d7adb>] vfs_read+0xab/0x120
[   43.576519]  [<ffffffff811fa173>] ? __fdget+0x13/0x20
[   43.576521]  [<ffffffff811d80f9>] SyS_read+0x59/0xd0
[   43.576526]  [<ffffffff8164ca12>] system_call_fastpath+0x16/0x1b
[   43.576551] Code: 75 18 e9 e5 00 00 00 0f 1f 44 00 00 89 c2 0f b6 14 17 39 da 0f 84 d2 00 00 00 83 c0 01 39 c6 77 eb f6 41 1a 01 0f 84 f8 00 00 00 <4f> 8b 6c 1e f8 4d 85 ed 0f 84 b3 00 00 00 49 8b 39 4d 89 d4 89 
[   43.576553] RIP  [<ffffffff811c34ff>] handle_slab+0x8f/0x190
[   43.576553]  RSP <ffff880035de3d88>
[   43.576554] CR2: ffff88003708aff8
[   43.576556] ---[ end trace 512dafa068f4bf70 ]---
