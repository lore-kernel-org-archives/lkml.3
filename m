Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaKZW56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:57:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaKZW54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:57:56 -0500
Date: Wed, 26 Nov 2014 17:57:45 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141126225745.GA30346@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <20141126024032.GA13246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126024032.GA13246@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:40:32PM -0500, Dave Jones wrote:
 > On Tue, Nov 25, 2014 at 05:48:15PM -0800, Linus Torvalds wrote:
 > 
 >  > So that would either imply you have some staging driver (unlikely), or
 >  > more likely that 3.17 really already has the problem, it's just that
 >  > it needs some particular code alignment or phase of the moon or
 >  > something to trigger.
 > 
 > Maybe I'll try 3.17 + perf fix for an even longer runtime.
 > Like over thanksgiving or something.

Dammit, dammit, dammit.

I didn't even have to wait that long.

[19861.135201] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c132:26979]
[19861.135652] Modules linked in: snd_seq_dummy 8021q garp stp fuse tun hidp bnep rfcomm af_key llc2 scsi_transport_iscsi nfnetlink can_bcm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can_raw can pppoe pppox ppp_ge
neric slhc irda crc_ccitt rds rose sctp libcrc32c x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi crc
t10dif_pclmul crc32c_intel snd_hda_intel snd_hda_controller snd_hda_codec ghash_clmulni_intel snd_hwdep pcspkr snd_seq snd_seq_device serio_raw usb_debug snd_pcm e1000e snd_timer microcode ptp snd pps_core shpchp soundcore nfsd auth_rpcgs
s oid_registry nfs_acl lockd sunrpc
[19861.138604] CPU: 1 PID: 26979 Comm: trinity-c132 Not tainted 3.17.0+ #2
[19861.139229] Hardware name: Intel Corporation Shark Bay Client platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 01/28/2013
[19861.139897] task: ffff8801ec6716f0 ti: ffff8801b5bf8000 task.ti: ffff8801b5bf8000
[19861.140564] RIP: 0010:[<ffffffff81369585>]  [<ffffffff81369585>] copy_user_enhanced_fast_string+0x5/0x10
[19861.141263] RSP: 0018:ffff8801b5bfbcf0  EFLAGS: 00010206
[19861.141974] RAX: ffff8801b5bfbe48 RBX: 0000000000000003 RCX: 0000000000000a1d
[19861.142688] RDX: 0000000000001000 RSI: 00007f6f89ef85e3 RDI: ffff8801750445e3
[19861.143416] RBP: ffff8801b5bfbd30 R08: 0000000000000000 R09: 0000000000000001
[19861.144164] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b5bfbc78
[19861.144909] R13: ffff8801d702ed70 R14: ffffffff810a3d2b R15: ffff8801b5bfbc60
[19861.145668] FS:  00007f6f89eeb740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[19861.146440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19861.147218] CR2: 00007f6f89ef3000 CR3: 00000001cddb5000 CR4: 00000000001407e0
[19861.148014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19861.148828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[19861.149640] Stack:
[19861.150443]  ffffffff8119a4f8 160000007c331000 0000000000001000 160000007c331000
[19861.151283]  0000000000001000 ffff8801b5bfbe58 0000000000000000 ffff8801d702f0a0
[19861.152133]  ffff8801b5bfbdc0 ffffffff81170474 ffff8801b5bfbd88 0000000000001000
[19861.152995] Call Trace:
[19861.153851]  [<ffffffff8119a4f8>] ? iov_iter_copy_from_user_atomic+0x78/0x1c0
[19861.154738]  [<ffffffff81170474>] generic_perform_write+0xf4/0x1e0
[19861.155636]  [<ffffffff811ff1da>] ? file_update_time+0xaa/0xf0
[19861.156536]  [<ffffffff81172ba2>] __generic_file_write_iter+0x162/0x350
[19861.157447]  [<ffffffff81172dcf>] generic_file_write_iter+0x3f/0xb0
[19861.158365]  [<ffffffff811e17ae>] new_sync_write+0x8e/0xd0
[19861.159287]  [<ffffffff811e202a>] vfs_write+0xba/0x1f0
[19861.160214]  [<ffffffff811e2e42>] SyS_pwrite64+0x92/0xc0
[19861.161152]  [<ffffffff817b62a4>] tracesys+0xdd/0xe2
[19861.162091] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[19861.164217] sending NMI to other CPUs:
[19861.165221] NMI backtrace for cpu 2
[19861.166099] CPU: 2 PID: 28083 Comm: trinity-c151 Not tainted 3.17.0+ #2
[19861.167084] Hardware name: Intel Corporation Shark Bay Client platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 01/28/2013
[19861.168113] task: ffff8800746116f0 ti: ffff8801c6894000 task.ti: ffff8801c6894000
[19861.169152] RIP: 0010:[<ffffffff810fb326>]  [<ffffffff810fb326>] smp_call_function_many+0x276/0x320
[19861.170223] RSP: 0000:ffff8801c6897b00  EFLAGS: 00000202
[19861.171295] RAX: 0000000000000001 RBX: ffff8802445d4c40 RCX: ffff8802443da408
[19861.172384] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 0000000000000000
[19861.173483] RBP: ffff8801c6897b40 R08: ffff880242469ce0 R09: 0000000100180011
[19861.174590] R10: ffff880243c04240 R11: 0000000000000000 R12: 0000000000000001
[19861.175703] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000008
[19861.176822] FS:  00007f6f89eeb740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[19861.177956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19861.179103] CR2: 0000000002400000 CR3: 0000000231685000 CR4: 00000000001407e0
[19861.180264] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19861.181428] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[19861.182595] Stack:
[19861.183764]  ffff88024d64dd00 000000014d64dd00 00000000001d4c00 ffffffff82be41a0
[19861.184969]  0000000000000002 ffffffff8117a700 0000000000000000 0000000000000001
[19861.186167]  ffff8801c6897b78 ffffffff810fb542 0000000000000003 0000000000000008
[19861.187355] Call Trace:
[19861.188538]  [<ffffffff8117a700>] ? drain_pages+0xc0/0xc0
[19861.189709]  [<ffffffff810fb542>] on_each_cpu_mask+0x42/0xc0
[19861.190853]  [<ffffffff811768b1>] drain_all_pages+0x101/0x120
[19861.191989]  [<ffffffff8117af40>] __alloc_pages_nodemask+0x7d0/0xb20
[19861.193130]  [<ffffffff811c2b11>] alloc_pages_vma+0xf1/0x1b0
[19861.194258]  [<ffffffff811d705c>] ? do_huge_pmd_anonymous_page+0x10c/0x3e0
[19861.195367]  [<ffffffff811d705c>] do_huge_pmd_anonymous_page+0x10c/0x3e0
[19861.196450]  [<ffffffff811a10dc>] handle_mm_fault+0x14c/0xe90
[19861.197509]  [<ffffffff81041940>] ? __do_page_fault+0x140/0x600
[19861.198540]  [<ffffffff810419a4>] __do_page_fault+0x1a4/0x600
[19861.199550]  [<ffffffff810a3bcd>] ? get_parent_ip+0xd/0x50
[19861.200539]  [<ffffffff810a3d2b>] ? preempt_count_sub+0x6b/0xf0
[19861.201514]  [<ffffffff810c0b6e>] ? put_lock_stats.isra.23+0xe/0x30
[19861.202467]  [<ffffffff8136ad3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[19861.203407]  [<ffffffff81041e0c>] do_page_fault+0xc/0x10
[19861.204331]  [<ffffffff817b7d72>] page_fault+0x22/0x30
[19861.205249] Code: 00 41 89 c4 39 f0 0f 8d 25 fe ff ff 48 63 d0 48 8b 0b 48 03 0c d5 a0 b9 d1 81 f6 41 18 01 74 14 0f 1f 44 00 00 f3 90 f6 41 18 01 <75> f8 48 63 35 45 3b c2 00 83 f8 ff 48 8b 7b 08 74 b0 39 c6 77 
[19861.207272] NMI backtrace for cpu 0
[19861.207376] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 42.050 msecs
[19861.209220] CPU: 0 PID: 28128 Comm: trinity-c242 Not tainted 3.17.0+ #2
[19861.210200] Hardware name: Intel Corporation Shark Bay Client platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 01/28/2013
[19861.211210] task: ffff8802168716f0 ti: ffff88007467c000 task.ti: ffff88007467c000
[19861.212215] RIP: 0010:[<ffffffff810c26ea>]  [<ffffffff810c26ea>] __lock_acquire.isra.31+0xfa/0x9f0
[19861.213248] RSP: 0000:ffff880244003cb0  EFLAGS: 00000046
[19861.214281] RAX: 0000000000000046 RBX: ffff8802168716f0 RCX: 0000000000000000
[19861.215318] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88023fcbbc40
[19861.216346] RBP: ffff880244003d18 R08: 0000000000000001 R09: 0000000000000000
[19861.217378] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[19861.218399] R13: 0000000000000000 R14: ffff88023fcbbc40 R15: 0000000000000000
[19861.219410] FS:  00007f6f89eeb740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[19861.220425] CS:  0010 DS: 0000 ES: 0[19861.273167] NMI backtrace for cpu 3
[19861.273315] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 107.946 msecs
[19861.274821] CPU: 3 PID: 27913 Comm: trinity-c37 Not tainted 3.17.0+ #2
[19861.275672] Hardware name: Intel Corporation Shark Bay Client platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 01/28/2013
[19861.276543] task: ffff88009a735bc0 ti: ffff8801eda8c000 task.ti: ffff8801eda8c000
[19861.277422] RIP: 0010:[<ffffffff810fb322>]  [<ffffffff810fb322>] smp_call_function_many+0x272/0x320
[19861.278339] RSP: 0000:ffff8801eda8fb00  EFLAGS: 00000202
[19861.279220] RAX: 0000000000000001 RBX: ffff8802447d4c40 RCX: ffff8802443da428
[19861.280115] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 0000000000000000
[19861.281021] RBP: ffff8801eda8fb40 R08: ffff880242469a40 R09: 0000000100180011
[19861.281917] R10: ffff880243c04240 R11: 0000000000000000 R12: 0000000000000001
[19861.282813] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000008
[19861.283690] FS:  00007f6f89eeb740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[19861.284570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19861.285466] CR2: 0000000002400000 CR3: 00000001cdd92000 CR4: 00000000001407e0
[19861.286363] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19861.287255] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[19861.288142] Stack:
[19861.289024]  ffff88024d64dd00 000000014d64dd00 00000000001d4c00 ffffffff82be41a0
[19861.289934]  0000000000000003 ffffffff8117a700 0000000000000000 0000000000000001
[19861.290845]  ffff8801eda8fb78 ffffffff810fb542 0000000000000003 0000000000000008
[19861.291763] Call Trace:
[19861.292664]  [<ffffffff8117a700>] ? drain_pages+0xc0/0xc0
[19861.293582]  [<ffffffff810fb542>] on_each_cpu_mask+0x42/0xc0
[19861.294501]  [<ffffffff811768b1>] drain_all_pages+0x101/0x120
[19861.295439]  [<ffffffff8117af40>] __alloc_pages_nodemask+0x7d0/0xb20
[19861.296369]  [<ffffffff811c2b11>] alloc_pages_vma+0xf1/0x1b0
[19861.297292]  [<ffffffff811d705c>] ? do_huge_pmd_anonymous_page+0x10c/0x3e0
[19861.298218]  [<ffffffff811d705c>] do_huge_pmd_anonymous_page+0x10c/0x3e0
[19861.299146]  [<ffffffff811a10dc>] handle_mm_fault+0x14c/0xe90
[19861.300078]  [<ffffffff81041940>] ? __do_page_fault+0x140/0x600
[19861.301011]  [<ffffffff810419a4>] __do_page_fault+0x1a4/0x600
[19861.301946]  [<ffffffff810a3bcd>] ? get_parent_ip+0xd/0x50
[19861.302874]  [<ffffffff810a3d2b>] ? preempt_count_sub+0x6b/0xf0
[19861.303805]  [<ffffffff810c0b6e>] ? put_lock_stats.isra.23+0xe/0x30
[19861.304736]  [<ffffffff8136ad3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[19861.305665]  [<ffffffff81041e0c>] do_page_fault+0xc/0x10
[19861.306590]  [<ffffffff817b7d72>] page_fault+0x22/0x30
[19861.307527] Code: 35 78 3b c2 00 41 89 c4 39 f0 0f 8d 25 fe ff ff 48 63 d0 48 8b 0b 48 03 0c d5 a0 b9 d1 81 f6 41 18 01 74 14 0f 1f 44 00 00 f3 90 <f6> 41 18 01 75 f8 48 63 35 45 3b c2 00 83 f8 ff 48 8b 7b 08 74 
[19861.309600] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 144.376 msecs


So 3.17 also has this problem.
Good news I guess in that it's not a regression, but damn I really didn't
want to have to go digging through the mists of time to find the last 'good' point.
At least it shouldn't hold up 3.18

I'll do a couple builds to run over the holidays, but next week
I think I'm going to need to approach this differently to add
more debugging somewhere/somehow.

	Dave

