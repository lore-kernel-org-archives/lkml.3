Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaFJMFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:05:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:13595 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFJMFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:05:03 -0400
X-Nat-Received: from [202.181.97.72]:19277 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1402401894.17618
To: viro@ZenIV.linux.org.uk, paulmck@linux.vnet.ibm.com
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [pre 3.16-rc1] Oops at spin_trylock(&inode->i_lock)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201406102104.FAG04640.MVJFSQOHtOFOFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 10 Jun 2014 21:04:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10062014 #8198076, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed that commit 59a3d4c363 "Merge branch 'core-rcu-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next" causes
an oops when rebooting a system. Do you have any clue?

Config is at http://I-love.SAKURA.ne.jp/tmp/config-pre-3.16-rc1 .

---------- console log start ----------
EXT4-fs (sda1): re-mounted. Opts: (null)
BUG: unable to handle kernel paging request at ffff88004c0d2f40
IP: [<ffffffff810bc269>] do_raw_spin_trylock+0x9/0x50
PGD 2d32067 PUD 2d35067 PMD 7fb83067 PTE 800000004c0d2060
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: fuse ipv6 vhost_net macvtap macvlan vhost tun ppdev snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd soundcore e1000 dm_mod sg i2c_piix4 i2c_core parport_pc parport shpchp ext4(E) jbd2(E) mbcache(E) crc16(E) sd_mod(E) crc_t10dif(E) sr_mod(E) cdrom(E) mptspi(E) mptscsih(E) mptbase(E) scsi_transport_spi(E) pata_acpi(E) ata_generic(E) ata_piix(E)
CPU: 2 PID: 2277 Comm: mount Tainted: G            E 3.15.0-rc8-04322-g59a3d4c #378
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
task: ffff880046d904d0 ti: ffff8800415a0000 task.ti: ffff8800415a0000
RIP: 0010:[<ffffffff810bc269>]  [<ffffffff810bc269>] do_raw_spin_trylock+0x9/0x50
RSP: 0018:ffff8800415a3d38  EFLAGS: 00010282
RAX: ffff88007962c080 RBX: ffff88004c0d2f40 RCX: 0000000000000002
RDX: 0000000000000018 RSI: ffff88004c0d4f58 RDI: ffff88004c0d2f40
RBP: ffff8800415a3d38 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88004c0d4eb0
R13: ffff88004c0d4fb0 R14: ffff8800415a3dd8 R15: ffff88004c0d4f40
FS:  00007fe45be4a7e0(0000) GS:ffff880079600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88004c0d2f40 CR3: 00000000494b6000 CR4: 00000000000407e0
Stack:
 ffff8800415a3d68 ffffffff816380ee ffffffff811e3a64 ffffffff813117c9
 ffff88004d88deb0 ffff88004c0d2eb0 ffff8800415a3db8 ffffffff811e3a80
 ffff88004c0dafb0 ffff8800708e8fc8 ffff880046d904d0 0000000000000400
Call Trace:
 [<ffffffff816380ee>] _raw_spin_trylock+0x1e/0x70
 [<ffffffff811e3a64>] ? shrink_dentry_list+0x44/0x370
 [<ffffffff813117c9>] ? lockref_put_or_lock+0x29/0x40
 [<ffffffff811e3a80>] shrink_dentry_list+0x60/0x370
 [<ffffffff811e3ec9>] shrink_dcache_sb+0xd9/0x120
 [<ffffffff811cc252>] do_remount_sb+0x52/0x1a0
 [<ffffffff811edf8d>] ? do_remount+0x9d/0x130
 [<ffffffff811ee015>] do_remount+0x125/0x130
 [<ffffffff811f13f2>] do_mount+0x1b2/0x210
 [<ffffffff8117e92b>] ? strndup_user+0x5b/0x80
 [<ffffffff811f14e0>] SyS_mount+0x90/0xe0
 [<ffffffff81642992>] system_call_fastpath+0x16/0x1b
Code: ff ff ff 31 ff e8 28 ef 01 00 e9 41 ff ff ff 4c 89 ef e8 cb aa fa ff e9 44 ff ff ff 90 90 90 90 90 90 55 48 89 e5 66 66 66 66 90 <8b> 17 89 d0 c1 e8 10 66 39 c2 74 0b 31 c0 c9 c3 0f 1f 80 00 00
RIP  [<ffffffff810bc269>] do_raw_spin_trylock+0x9/0x50
 RSP <ffff8800415a3d38>
CR2: ffff88004c0d2f40
---[ end trace 98409f38f5f1bb7f ]---
BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 1, pid: 2277, name: mount
INFO: lockdep is turned off.
irq event stamp: 69452
hardirqs last  enabled at (69451): [<ffffffff810d9c6c>] __call_rcu.clone.0+0x14c/0x330
hardirqs last disabled at (69452): [<ffffffff81639753>] error_sti+0x5/0x6
softirqs last  enabled at (68978): [<ffffffff8105b691>] __do_softirq+0x1e1/0x420
softirqs last disabled at (68969): [<ffffffff8105ba05>] irq_exit+0xc5/0xd0
CPU: 2 PID: 2277 Comm: mount Tainted: G      D     E 3.15.0-rc8-04322-g59a3d4c #378
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
 ffffffff81a0d7a3 ffff8800415a3998 ffffffff8163284a ffff8800415a3998
 ffff880046d904d0 ffff8800415a39c8 ffffffff8108ce85 ffff880046d904d0
 ffff880047415eb8 0000000000000009 0000000000000009 ffff8800415a39f8
Call Trace:
 [<ffffffff8163284a>] dump_stack+0x51/0x6f
 [<ffffffff8108ce85>] __might_sleep+0x175/0x230
 [<ffffffff81637026>] down_read+0x26/0xa0
 [<ffffffff8106aa44>] exit_signals+0x24/0x140
 [<ffffffff81058bb5>] do_exit+0xb5/0x570
 [<ffffffff8163a161>] oops_end+0xa1/0xf0
 [<ffffffff81045f5e>] no_context+0x12e/0x200
 [<ffffffff8104615d>] __bad_area_nosemaphore+0x12d/0x230
 [<ffffffff810b70b5>] ? __lock_acquire+0x445/0x600
 [<ffffffff81046273>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff8163cdc1>] __do_page_fault+0xe1/0x4c0
 [<ffffffff81638d90>] ? _raw_spin_unlock_irqrestore+0x40/0x70
 [<ffffffff8131145d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8163d1fc>] do_page_fault+0xc/0x10
 [<ffffffff81639552>] page_fault+0x22/0x30
 [<ffffffff810bc269>] ? do_raw_spin_trylock+0x9/0x50
 [<ffffffff816380ee>] _raw_spin_trylock+0x1e/0x70
 [<ffffffff811e3a64>] ? shrink_dentry_list+0x44/0x370
 [<ffffffff813117c9>] ? lockref_put_or_lock+0x29/0x40
 [<ffffffff811e3a80>] shrink_dentry_list+0x60/0x370
 [<ffffffff811e3ec9>] shrink_dcache_sb+0xd9/0x120
 [<ffffffff811cc252>] do_remount_sb+0x52/0x1a0
 [<ffffffff811edf8d>] ? do_remount+0x9d/0x130
 [<ffffffff811ee015>] do_remount+0x125/0x130
 [<ffffffff811f13f2>] do_mount+0x1b2/0x210
 [<ffffffff8117e92b>] ? strndup_user+0x5b/0x80
 [<ffffffff811f14e0>] SyS_mount+0x90/0xe0
 [<ffffffff81642992>] system_call_fastpath+0x16/0x1b
note: mount[2277] exited with preempt_count 2
---------- console log end ----------

---------- bisect log start ----------
# bad: [776edb59317ada867dfcddde40b55648beeb0078] Merge branch 'locking-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next
# good: [26fc9cd200ec839e0b3095e05ae018f27314e7aa] kernfs: move the last knowledge of sysfs out from kernfs
# good: [f9c78b2be2cac2a7a397d489275e7d9f9ae785f2] block: move bio.c and bio-integrity.c from fs/ to block/
# good: [681a2895486243a82547d8c9f53043eb54b53da0] Merge branch 'for-3.16/core' of git://git.kernel.dk/linux-block into next
# good: [5da77761e6fd51f633b4f31051c4f839e01c29c0] Merge tag 'driver-core-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core into next
# good: [4e857c58efeb99393cba5a5d0d8ec7117183137c] arch: Mass conversion of smp_mb__*()
# good: [bf8102228a8bf053051f311e5486042fe0542894] intel_pstate: Improve initial busy calculation
# good: [192a98e280e560510a62aca8cfa83b4ae7c095bb] ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
# good: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
# good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
# good: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
# good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
# good: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
# good: [8bb495e3f02401ee6f76d1b1d77f3ac9f079e376] Linux 3.10
# good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
# good: [28a33cbc24e4256c143dce96c7d93bf423229f92] Linux 3.5
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
# good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect start '776edb59317ada867dfcddde40b55648beeb0078' '26fc9cd200ec839e0b3095e05ae018f27314e7aa' 'f9c78b2be2cac2a7a397d489275e7d9f9ae785f2' '681a2895486243a82547d8c9f53043eb54b53da0' '5da77761e6fd51f633b4f31051c4f839e01c29c0' '4e857c58efeb99393cba5a5d0d8ec7117183137c' 'bf8102228a8bf053051f311e5486042fe0542894' '192a98e280e560510a62aca8cfa83b4ae7c095bb' 'v3.15' 'v3.14' 'v3.13' 'v3.12' 'v3.11' 'v3.10' 'v3.9' 'v3.8' 'v3.7' 'v3.6' 'v3.5' 'v3.4' 'v3.3' 'v3.2' 'v3.1' 'v3.0'
# good: [539b4f72d0da83e4d20df7cfc27dc49c00316940] staging/rtl8192u: Put EXPORT_SYMBOL just after the exported function
git bisect good 539b4f72d0da83e4d20df7cfc27dc49c00316940
# good: [49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c] Merge tag 'tty-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty into next
git bisect good 49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c
# good: [8f5759aeb88a47448cd92ab55a016d013b154a98] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux into next
git bisect good 8f5759aeb88a47448cd92ab55a016d013b154a98
# good: [de6b25de4584febbe1808bc782734ae163b22c26] Merge tag 'regmap-v3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap into next
git bisect good de6b25de4584febbe1808bc782734ae163b22c26
# good: [312c76f1a3989b8d0c0c13fee765bb2c41f2d114] Merge tag 'regulator-v3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator into next
git bisect good 312c76f1a3989b8d0c0c13fee765bb2c41f2d114
# good: [48d684fdad83d7525a557e6ff9c37811b6a9947b] rcutorture: Run rcu_torture_writer at normal priority
git bisect good 48d684fdad83d7525a557e6ff9c37811b6a9947b
# good: [a5d6d3a1b00a0ad88f07c3a727c79b27915278e3] softirq: A single rcu_bh_qs() call per softirq set is enough
git bisect good a5d6d3a1b00a0ad88f07c3a727c79b27915278e3
# good: [61f38db3e3c0e4c3be0858750e2cabeadaecac0c] rcu: Provide API to suppress stall warnings while sysrc runs
git bisect good 61f38db3e3c0e4c3be0858750e2cabeadaecac0c
# good: [f70e3c4f8b6ab61f713e040822ec51f5de498146] CMA: correct unlock target
git bisect good f70e3c4f8b6ab61f713e040822ec51f5de498146
# bad: [59a3d4c3631e553357b7305dc09db1990aa6757c] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next
git bisect bad 59a3d4c3631e553357b7305dc09db1990aa6757c
# good: [e14505a8d50882ff3bdd4b791b14d90a0881fa4d] Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu
git bisect good e14505a8d50882ff3bdd4b791b14d90a0881fa4d
# good: [ff806d034ef8e9a95ff0b0532104dd65332e446b] Merge branch 'for-v3.16' of git://git.linaro.org/people/mszyprowski/linux-dma-mapping into next
git bisect good ff806d034ef8e9a95ff0b0532104dd65332e446b
---------- bisect log end ----------
