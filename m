Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaLRFO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:14:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaLRFOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:14:23 -0500
Date: Thu, 18 Dec 2014 00:13:27 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141218051327.GA31988@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
 <20141215055707.GA26225@redhat.com>
 <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 03:46:41PM -0800, Linus Torvalds wrote:
 > On Mon, Dec 15, 2014 at 10:21 AM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > So let's just fix it. Here's a completely untested patch.
 > 
 > So after looking at this more, I'm actually really convinced that this
 > was a pretty nasty bug.
 > 
 > I'm *not* convinced that it's necessarily *your* bug, but I still
 > think it could be.

Bah, I was getting all optimistic.
I came home this evening to a locked up machine.
Serial console had a *lot* more traces than usual though.
Full log below.  The 12xxx.xxxxxx traces we seemed to recover from,
followed by silence for a while, before the real fun begins at 157xx.xxxxxx


[12525.310743] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [trinity-c60:28574]
[12525.311429] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12525.315877] CPU: 2 PID: 28574 Comm: trinity-c60 Not tainted 3.18.0+ #106
[12525.318136] task: ffff880153a20000 ti: ffff8801c251c000 task.ti: ffff8801c251c000
[12525.318931] RIP: 0010:[<ffffffff81373805>]  [<ffffffff81373805>] copy_user_enhanced_fast_string+0x5/0x10
[12525.319758] RSP: 0018:ffff8801c251fbe0  EFLAGS: 00010206
[12525.320555] RAX: 00007f9c44b07f1d RBX: 0000000000000003 RCX: 00000000000009c0
[12525.321403] RDX: 0000000000001000 RSI: 00007f9c44b0855d RDI: ffff88007cb1f640
[12525.322227] RBP: ffff8801c251fc28 R08: 0000000000000000 R09: 0000000000000001
[12525.323046] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff817cf22b
[12525.323854] R13: ffff8801c251fb68 R14: ffff880061dccd40 R15: ffff880061dcce60
[12525.324676] FS:  00007f9c4714c740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12525.325468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12525.326262] CR2: 00007f9c45b905b8 CR3: 000000022a30b000 CR4: 00000000001407e0
[12525.327065] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12525.327867] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12525.328666] Stack:
[12525.329459]  ffffffff8119fe56 ffff8801c251fbf8 140000010718f000 0000000000001000
[12525.330283]  140000010718f000 0000000000001000 ffff8801c251fd60 0000000000000000
[12525.331139]  ffff880061dcd070 ffff8801c251fcc8 ffffffff81175fe7 ffff8801c251fc88
[12525.331969] Call Trace:
[12525.332801]  [<ffffffff8119fe56>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[12525.333642]  [<ffffffff81175fe7>] generic_perform_write+0xf7/0x1f0
[12525.334475]  [<ffffffff81178722>] __generic_file_write_iter+0x162/0x350
[12525.335315]  [<ffffffff811e7940>] ? new_sync_read+0xd0/0xd0
[12525.336149]  [<ffffffff8117894f>] generic_file_write_iter+0x3f/0xb0
[12525.336981]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12525.337809]  [<ffffffff811e7a88>] do_iter_readv_writev+0x78/0xc0
[12525.338630]  [<ffffffff811e92b8>] do_readv_writev+0xd8/0x2a0
[12525.339435]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12525.340238]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12525.341068]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12525.341865]  [<ffffffff817cf310>] ? _raw_spin_unlock_irq+0x30/0x40
[12525.342664]  [<ffffffff811e950c>] vfs_writev+0x3c/0x50
[12525.343486]  [<ffffffff811e98d2>] SyS_pwritev+0xc2/0xf0
[12525.344292]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12525.345099] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[12525.346820] sending NMI to other CPUs:
[12525.347621] NMI backtrace for cpu 3
[12525.348409] CPU: 3 PID: 25560 Comm: trinity-c201 Not tainted 3.18.0+ #106
[12525.350733] task: ffff880095342da0 ti: ffff8801c048c000 task.ti: ffff8801c048c000
[12525.351503] RIP: 0010:[<ffffffff810fbc4e>]  [<ffffffff810fbc4e>] generic_exec_single+0xee/0x1b0
[12525.352270] RSP: 0018:ffff8801c048f9f8  EFLAGS: 00000202
[12525.353017] RAX: 0000000000000008 RBX: ffff8801c048fa10 RCX: 0000000000000038
[12525.353757] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[12525.354479] RBP: ffff8801c048fa58 R08: ffff8802437418f0 R09: 0000000000000000
[12525.355187] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[12525.355878] R13: 0000000000000001 R14: ffff880061e34fc0 R15: 0000000000000003
[12525.356558] FS:  00007f9c4714c740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12525.357236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12525.357905] CR2: 0000000001ac9498 CR3: 00000002247cb000 CR4: 00000000001407e0
[12525.358577] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12525.359246] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12525.359911] Stack:
[12525.360568]  0000000000000000 0000000000000000 ffff8801c048fa78 0000000000000000
[12525.361250]  ffffffff81048cd0 ffff8801c048fb08 0000000000000003 00000000639bd7ce
[12525.361928]  ffff880095342da0 00000000ffffffff 0000000000000002 ffffffff81048cd0
[12525.362601] Call Trace:
[12525.363259]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12525.363926]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12525.364589]  [<ffffffff810fbdb0>] smp_call_function_single+0x70/0xd0
[12525.365250]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12525.365904]  [<ffffffff810fc4a9>] smp_call_function_many+0x2b9/0x320
[12525.366556]  [<ffffffff811a396d>] ? unmap_single_vma+0x50d/0x900
[12525.367204]  [<ffffffff81049020>] flush_tlb_mm_range+0x90/0x1d0
[12525.367843]  [<ffffffff811a25b2>] tlb_flush_mmu_tlbonly+0x42/0x50
[12525.368476]  [<ffffffff811a2bac>] tlb_flush_mmu+0x1c/0x30
[12525.369102]  [<ffffffff811a2bd4>] tlb_finish_mmu+0x14/0x40
[12525.369726]  [<ffffffff811a3e78>] zap_page_range_single+0x118/0x160
[12525.370348]  [<ffffffff811a4044>] unmap_mapping_range+0x134/0x190
[12525.370971]  [<ffffffff81192a5d>] shmem_fallocate+0x4fd/0x520
[12525.371591]  [<ffffffff810bcb77>] ? prepare_to_wait+0x27/0x90
[12525.372210]  [<ffffffff811e6062>] do_fallocate+0x132/0x1d0
[12525.372825]  [<ffffffff811b8558>] SyS_madvise+0x398/0x870
[12525.373439]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12525.374061] Code: 48 89 de 48 03 14 c5 a0 f2 d1 81 48 89 df e8 fa e0 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[12525.375458] NMI backtrace for cpu 0
[12525.375565] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 27.836 msecs
[12525.376788] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0+ #106
[12525.378827] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[12525.379514] RIP: 0010:[<ffffffff813d6cab>]  [<ffffffff813d6cab>] intel_idle+0xdb/0x180
[12525.380215] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[12525.380905] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[12525.381588] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[12525.382254] RBP: ffffffff81c03e68 R08: 000000008baf8a0b R09: 0000000000000000
[12525.382911] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[12525.383558] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[12525.384194] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:00000000000000[12525.398359] NMI backtrace for cpu 1
[12525.398368] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 50.720 msecs
[12525.399764] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0+ #106
[12525.401932] task: ffff8802434b96d0 ti: ffff880243748000 task.ti: ffff880243748000
[12525.402687] RIP: 0010:[<ffffffff813d6cab>]  [<ffffffff813d6cab>] intel_idle+0xdb/0x180
[12525.403457] RSP: 0018:ffff88024374be08  EFLAGS: 00000046
[12525.404241] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[12525.405038] RDX: 0000000000000000 RSI: ffff88024374bfd8 RDI: 0000000000000001
[12525.405832] RBP: ffff88024374be38 R08: 000000008baf8a0b R09: 0000000000000000
[12525.406611] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[12525.407377] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243748000
[12525.408131] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12525.408881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12525.409601] CR2: 00000000000000d2 CR3: 0000000001c11000 CR4: 00000000001407e0
[12525.410310] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12525.411011] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12525.411694] Stack:
[12525.412363]  000000014374be38 b532cae23f43ed20 ffffe8ffff003200 0000000000000005
[12525.413051]  ffffffff81cb1bc0 0000000000000001 ffff88024374be88 ffffffff8165f7b5
[12525.413744]  00000b65f893e397 ffffffff81cb1d90 ffffffff81cb1bc0 ffffffff81d215f0
[12525.414439] Call Trace:
[12525.415125]  [<ffffffff8165f7b5>] cpuidle_enter_state+0x55/0x190
[12525.415824]  [<ffffffff8165f9a7>] cpuidle_enter+0x17/0x20
[12525.416523]  [<ffffffff810bd665>] cpu_startup_entry+0x355/0x410
[12525.417216]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[12525.417904] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[12525.419435] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 71.790 msecs
[12549.296847] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c60:28574]
[12549.297585] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12549.302426] CPU: 2 PID: 28574 Comm: trinity-c60 Tainted: G             L 3.18.0+ #106
[12549.304874] task: ffff880153a20000 ti: ffff8801c251c000 task.ti: ffff8801c251c000
[12549.305730] RIP: 0010:[<ffffffff81373805>]  [<ffffffff81373805>] copy_user_enhanced_fast_string+0x5/0x10
[12549.306609] RSP: 0018:ffff8801c251fbe0  EFLAGS: 00010206
[12549.307502] RAX: 00007f9c44b07f1d RBX: 0000000000000003 RCX: 00000000000009c0
[12549.308400] RDX: 0000000000001000 RSI: 00007f9c44b0855d RDI: ffff88007cb1f640
[12549.309284] RBP: ffff8801c251fc28 R08: 0000000000000000 R09: 0000000000000001
[12549.310159] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff817cf22b
[12549.311018] R13: ffff8801c251fb68 R14: ffff880061dccd40 R15: ffff880061dcce60
[12549.311862] FS:  00007f9c4714c740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12549.312716] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12549.313581] CR2: 00007f9c45b905b8 CR3: 000000022a30b000 CR4: 00000000001407e0
[12549.314418] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12549.315239] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12549.316051] Stack:
[12549.316861]  ffffffff8119fe56 ffff8801c251fbf8 140000010718f000 0000000000001000
[12549.317679]  140000010718f000 0000000000001000 ffff8801c251fd60 0000000000000000
[12549.318514]  ffff880061dcd070 ffff8801c251fcc8 ffffffff81175fe7 ffff8801c251fc88
[12549.319338] Call Trace:
[12549.320153]  [<ffffffff8119fe56>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[12549.320988]  [<ffffffff81175fe7>] generic_perform_write+0xf7/0x1f0
[12549.321824]  [<ffffffff81178722>] __generic_file_write_iter+0x162/0x350
[12549.322658]  [<ffffffff811e7940>] ? new_sync_read+0xd0/0xd0
[12549.323484]  [<ffffffff8117894f>] generic_file_write_iter+0x3f/0xb0
[12549.324306]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12549.325133]  [<ffffffff811e7a88>] do_iter_readv_writev+0x78/0xc0
[12549.325961]  [<ffffffff811e92b8>] do_readv_writev+0xd8/0x2a0
[12549.326783]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12549.327646]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12549.328470]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12549.329279]  [<ffffffff817cf310>] ? _raw_spin_unlock_irq+0x30/0x40
[12549.330078]  [<ffffffff811e950c>] vfs_writev+0x3c/0x50
[12549.330874]  [<ffffffff811e98d2>] SyS_pwritev+0xc2/0xf0
[12549.331672]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12549.332471] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[12549.334222] sending NMI to other CPUs:
[12549.335023] NMI backtrace for cpu 3
[12549.335811] CPU: 3 PID: 25560 Comm: trinity-c201 Tainted: G             L 3.18.0+ #106
[12549.338137] task: ffff880095342da0 ti: ffff8801c048c000 task.ti: ffff8801c048c000
[12549.338904] RIP: 0010:[<ffffffff810fbc4e>]  [<ffffffff810fbc4e>] generic_exec_single+0xee/0x1b0
[12549.339670] RSP: 0018:ffff8801c048f9f8  EFLAGS: 00000202
[12549.340416] RAX: 0000000000000008 RBX: ffff8801c048fa10 RCX: 0000000000000038
[12549.341157] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[12549.341879] RBP: ffff8801c048fa58 R08: ffff8802437418f0 R09: 0000000000000000
[12549.342587] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[12549.343280] R13: 0000000000000001 R14: ffff880061e34fc0 R15: 0000000000000003
[12549.343961] FS:  00007f9c4714c740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12549.344639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12549.345309] CR2: 0000000001ac9498 CR3: 00000002247cb000 CR4: 00000000001407e0
[12549.345981] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12549.346649] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12549.347313] Stack:
[12549.347969]  0000000000000000 0000000000000000 ffff8801c048fa78 0000000000000000
[12549.348648]  ffffffff81048cd0 ffff8801c048fb08 0000000000000003 00000000639bd7ce
[12549.349325]  ffff880095342da0 00000000ffffffff 0000000000000002 ffffffff81048cd0
[12549.349997] Call Trace:
[12549.350653]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12549.351319]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12549.351983]  [<ffffffff810fbdb0>] smp_call_function_single+0x70/0xd0
[12549.352644]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12549.353298]  [<ffffffff810fc4a9>] smp_call_function_many+0x2b9/0x320
[12549.353954]  [<ffffffff811a396d>] ? unmap_single_vma+0x50d/0x900
[12549.354604]  [<ffffffff81049020>] flush_tlb_mm_range+0x90/0x1d0
[12549.355245]  [<ffffffff811a25b2>] tlb_flush_mmu_tlbonly+0x42/0x50
[12549.355881]  [<ffffffff811a2bac>] tlb_flush_mmu+0x1c/0x30
[12549.356508]  [<ffffffff811a2bd4>] tlb_finish_mmu+0x14/0x40
[12549.357131]  [<ffffffff811a3e78>] zap_page_range_single+0x118/0x160
[12549.357756]  [<ffffffff811a4044>] unmap_mapping_range+0x134/0x190
[12549.358379]  [<ffffffff81192a5d>] shmem_fallocate+0x4fd/0x520
[12549.359001]  [<ffffffff810bcb77>] ? prepare_to_wait+0x27/0x90
[12549.359620]  [<ffffffff811e6062>] do_fallocate+0x132/0x1d0
[12549.360239]  [<ffffffff811b8558>] SyS_madvise+0x398/0x870
[12549.360855]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12549.361476] Code: 48 89 de 48 03 14 c5 a0 f2 d1 81 48 89 df e8 fa e0 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[12549.362876] NMI backtrace for cpu 1
[12549.363530] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.18.0+ #106
[12549.365548] task: ffff8802434b96d0 ti: ffff880243748000 task.ti: ffff880243748000
[12549.366222] RIP: 0010:[<ffffffff813d6cab>]  [<ffffffff813d6cab>] intel_idle+0xdb/0x180
[12549.366902] RSP: 0018:ffff88024374be08  EFLAGS: 00000046
[12549.367578] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[12549.368258] RDX: 0000000000000000 RSI: ffff88024374bfd8 RDI: 0000000000000001
[12549.368920] RBP: ffff88024374be38 R08: 000000008baf89f8 R09: 0000000000000000
[12549.369565] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[12549.370201] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243748000
[12549.370828] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12549.371451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12549.372069][12563.088868] INFO: rcu_sched self-detected stall on CPU
[12563.089596] 	2: (1 GPs behind) idle=d4b/140000000000001/0 softirq=781780/781781 
[12563.090304] 	 (t=6000 jiffies g=382738 c=382737 q=0)
[12563.090996] Task dump for CPU 2:
[12563.091676] trinity-c60     R  running task    12768 28574  19163 0x0000000c
[12563.092378]  ffff880153a20000 000000005c7b7872 ffff880245203d68 ffffffff810a743c
[12563.093085]  ffffffff810a73a2 0000000000000002 0000000000000004 0000000000000002
[12563.093810]  ffffffff81c52380 0000000000000092 ffff880245203d88 ffffffff810ab4ed
[12563.094507] Call Trace:
[12563.095197]  <IRQ>  [<ffffffff810a743c>] sched_show_task+0x11c/0x190
[12563.095910]  [<ffffffff810a73a2>] ? sched_show_task+0x82/0x190
[12563.096636]  [<ffffffff810ab4ed>] dump_cpu_task+0x3d/0x50
[12563.097336]  [<ffffffff810d9b90>] rcu_dump_cpu_stacks+0x90/0xd0
[12563.098019]  [<ffffffff810e0723>] rcu_check_callbacks+0x503/0x770
[12563.098712]  [<ffffffff8113058c>] ? acct_account_cputime+0x1c/0x20
[12563.099408]  [<ffffffff810abe27>] ? account_system_time+0x97/0x180
[12563.100022]  [<ffffffff810e63fb>] update_process_times+0x4b/0x80
[12563.100623]  [<ffffffff810f6db3>] ? tick_sched_timer+0x23/0x1b0
[12563.101214]  [<ffffffff810f6ddf>] tick_sched_timer+0x4f/0x1b0
[12563.101795]  [<ffffffff810e729f>] __run_hrtimer+0xaf/0x240
[12563.102370]  [<ffffffff810e75ab>] ? hrtimer_interrupt+0x8b/0x260
[12563.102941]  [<ffffffff810f6d90>] ? tick_init_highres+0x20/0x20
[12563.103514]  [<ffffffff810e7627>] hrtimer_interrupt+0x107/0x260
[12563.104086]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[12563.104660]  [<ffffffff817d29c5>] smp_apic_timer_interrupt+0x45/0x60
[12563.105234]  [<ffffffff817d0daf>] apic_timer_interrupt+0x6f/0x80
[12563.105805]  <EOI>  [<ffffffff81373805>] ? copy_user_enhanced_fast_string+0x5/0x10
[12563.106387]  [<ffffffff8119fe56>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[12563.106965]  [<ffffffff81175fe7>] generic_perform_write+0xf7/0x1f0
[12563.107545]  [<ffffffff81178722>] __generic_file_write_iter+0x162/0x350
[12563.108128]  [<ffffffff811e7940>] ? new_sync_read+0xd0/0xd0
[12563.108705]  [<ffffffff8117894f>] generic_file_write_iter+0x3f/0xb0
[12563.109299]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12563.109869]  [<ffffffff811e7a88>] do_iter_readv_writev+0x78/0xc0
[12563.110440]  [<ffffffff811e92b8>] do_readv_writev+0xd8/0x2a0
[12563.111003]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12563.111566]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12563.112125]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12563.112686]  [<ffffffff817cf310>] ? _raw_spin_unlock_irq+0x30/0x40
[12563.113248]  [<ffffffff811e950c>] vfs_writev+0x3c/0x50
[12563.113810]  [<ffffffff811e98d2>] SyS_pwritev+0xc2/0xf0
[12563.114373]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12577.290614] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c201:25560]
[12577.291259] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12577.295639] CPU: 3 PID: 25560 Comm: trinity-c201 Tainted: G             L 3.18.0+ #106
[12577.297656] task: ffff880095342da0 ti: ffff8801c048c000 task.ti: ffff8801c048c000
[12577.298367] RIP: 0010:[<ffffffff810fbc4a>]  [<ffffffff810fbc4a>] generic_exec_single+0xea/0x1b0
[12577.299091] RSP: 0018:ffff8801c048f9f8  EFLAGS: 00000202
[12577.299825] RAX: 0000000000000008 RBX: ffffffff817d0ae0 RCX: 0000000000000038
[12577.300553] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[12577.301296] RBP: ffff8801c048fa58 R08: ffff8802437418f0 R09: 0000000000000000
[12577.302007] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c048f968
[12577.302726] R13: 0000000000001a4a R14: ffff8801c048c000 R15: ffff880095342da0
[12577.303444] FS:  00007f9c4714c740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12577.304169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12577.304897] CR2: 0000000001ac9498 CR3: 00000002247cb000 CR4: 00000000001407e0
[12577.305636] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12577.306386] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12577.307114] Stack:
[12577.307830]  0000000000000000 0000000000000000 ffff8801c048fa78 0000000000000000
[12577.308585]  ffffffff81048cd0 ffff8801c048fb08 0000000000000003 00000000639bd7ce
[12577.309355]  ffff880095342da0 00000000ffffffff 0000000000000002 ffffffff81048cd0
[12577.310106] Call Trace:
[12577.310898]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12577.311664]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12577.312440]  [<ffffffff810fbdb0>] smp_call_function_single+0x70/0xd0
[12577.313196]  [<ffffffff81048cd0>] ? do_flush_tlb_all+0x60/0x60
[12577.313935]  [<ffffffff810fc4a9>] smp_call_function_many+0x2b9/0x320
[12577.314684]  [<ffffffff811a396d>] ? unmap_single_vma+0x50d/0x900
[12577.315429]  [<ffffffff81049020>] flush_tlb_mm_range+0x90/0x1d0
[12577.316182]  [<ffffffff811a25b2>] tlb_flush_mmu_tlbonly+0x42/0x50
[12577.316913]  [<ffffffff811a2bac>] tlb_flush_mmu+0x1c/0x30
[12577.317664]  [<ffffffff811a2bd4>] tlb_finish_mmu+0x14/0x40
[12577.318399]  [<ffffffff811a3e78>] zap_page_range_single+0x118/0x160
[12577.319123]  [<ffffffff811a4044>] unmap_mapping_range+0x134/0x190
[12577.319871]  [<ffffffff81192a5d>] shmem_fallocate+0x4fd/0x520
[12577.320624]  [<ffffffff810bcb77>] ? prepare_to_wait+0x27/0x90
[12577.321411]  [<ffffffff811e6062>] do_fallocate+0x132/0x1d0
[12577.322149]  [<ffffffff811b8558>] SyS_madvise+0x398/0x870
[12577.322868]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12577.323617] Code: c0 3a 1d 00 48 89 de 48 03 14 c5 a0 f2 d1 81 48 89 df e8 fa e0 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[12577.325246] sending NMI to other CPUs:
[12577.325989] NMI backtrace for cpu 2
[12577.326717] CPU: 2 PID: 28574 Comm: trinity-c60 Tainted: G             L 3.18.0+ #106
[12577.328845] task: ffff880153a20000 ti: ffff8801c251c000 task.ti: ffff8801c251c000
[12577.329548] RIP: 0010:[<ffffffff810c523d>]  [<ffffffff810c523d>] __lock_acquire.isra.31+0x33d/0x9f0
[12577.330250] RSP: 0018:ffff880245203d88  EFLAGS: 00000097
[12577.330933] RAX: 0000000000000000 RBX: ffff880153a20000 RCX: ffff8802453cff98
[12577.331610] RDX: 0000000000000980 RSI: 0000000000000010 RDI: 0000000000000000
[12577.332272] RBP: ffff880245203df8 R08: 0000000000000001 R09: 0000000000000000
[12577.332924] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000097
[12577.333564] R13: 0000000000000002 R14: ffff8802453cc898 R15: ffff880153a207e0
[12577.334195] FS:  00007f9c4714c740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12577.334831] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12577.335469] CR2: 00007f9c45b905b8 CR3: 000000022a30b000 CR4: 00000000001407e0
[12577.336116] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12577.336759] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12577.337399] Stack:
[12577.338024]  ffff880153a20000 0000000000000046 ffff880245203dd8 0000000000000092
[12577.338671]  ffff8802453d2f18 ffff8802453d2f00 0000000000000002 0000000000000000
[12577.339313]  ffff880245203dc8 0000000000000046 0000000000000000 0000000000000000
[12577.339955] Call Trace:
[12577.340585]  <IRQ> 
[12577.340593]  [<ffffffff810c5fff>] lock_acquire+0x9f/0x120
[12577.341830]  [<ffffffff810e72c6>] ? __run_hrtimer+0xd6/0x240
[12577.342450]  [<ffffffff810f6db3>] ? tick_sched_timer+0x23/0x1b0
[12577.343065]  [<ffffffff817cee9e>] _raw_spin_lock+0x3e/0x80
[12577.343673]  [<ffffffff810e72c6>] ? __run_hrtimer+0xd6/0x240
[12577.344277]  [<ffffffff810e72c6>] __run_hrtimer+0xd6/0x240
[12577.344886]  [<ffffffff810e75ab>] ? hrtimer_interrupt+0x8b/0x260
[12577.345493]  [<ffffffff810f6d90>] ? tick_init_highres+0x20/0x20
[12577.346099]  [<ffffffff810e7627>] hrtimer_interrupt+0x107/0x260
[12577.346703]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[12577.347309]  [<ffffffff817d29c5>] smp_apic_timer_interrupt+0x45/0x60
[12577.347916]  [<ffffffff817d0daf>] apic_timer_interrupt+0x6f/0x80
[12577.348522]  <EOI> 
[12577.348529]  [<ffffffff81373805>] ? copy_user_enhanced_fast_string+0x5/0x10
[12577.349750]  [<ffffffff8119fe56>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[12577.350375]  [<ffffffff81175fe7>] generic_perform_write+0xf7/0x1f0
[12577.351001]  [<ffffffff81178722>] __generic_file_write_iter+0x162/0x350
[12577.351626]  [<ffffffff811e7940>] ? new_sync_read+0xd0/0xd0
[12577.352253]  [<ffffffff8117894f>] generic_file_write_iter+0x3f/0xb0
[12577.352883]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12577.353515]  [<ffffffff811e7a88>] do_iter_readv_writev+0x78/0xc0
[12577.354147]  [<ffffffff811e92b8>] do_readv_writev+0xd8/0x2a0
[12577.354763]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12577.355366]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12577.355956]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12577.356550]  [<ffffffff817cf310>] ? _raw_spin_unlock_irq+0x30/0x40
[12577.357141]  [<ffffffff811e950c>] vfs_writev+0x3c/0x50
[12577.357713]  [<ffffffff811e98d2>] SyS_pwritev+0xc2/0xf0
[12577.358267]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12577.358815] Code: 00 00 48 83 c4 48 44 89 e8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 2e 0f 1f 84 00 00 00 00 00 41 81 fc fe 1f 00 00 0f 87 34 04 00 00 <45> 85 ed 48 8b 83 60 07 00 00 75 09 48 85 c0 0f 85 df 03 00 00 
[12577.360038] NMI backtrace for cpu 0
[12577.360598] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #106
[12577.381697] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.18.0+ #106
[12577.383862] task: ffff8802434b96d0 ti: ffff880243748000 task.ti: ffff880243748000
[12577.384585] RIP: 0010:[<ffffffff813d6cab>]  [<ffffffff813d6cab>] intel_idle+0xdb/0x180
[12577.385332] RSP: 0018:ffff88024374be08  EFLAGS: 00000046
[12577.386066] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[12577.386807] RDX: 0000000000000000 RSI: ffff88024374bfd8 RDI: 0000000000000001
[12577.387545] RBP: ffff88024374be38 R08: 000000008baf89e1 R09: 0000000000000000
[12577.388285] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[12577.389028] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243748000
[12577.389752] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12577.390463] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12577.391170] CR2: 00007f5271c07000 CR3: 0000000001c11000 CR4: 00000000001407e0
[12577.391888] DR0: 00007f6c9030b000 DR1: 0000000000000000 DR2: 0000000000000000
[12577.392584] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12577.393258] Stack:
[12577.393915]  000000014374be38 b532cae23f43ed20 ffffe8ffff003200 0000000000000005
[12577.394595]  ffffffff81cb1bc0 0000000000000001 ffff88024374be88 ffffffff8165f7b5
[12577.395278]  00000b72149ea4e1 ffffffff81cb1d90 ffffffff81cb1bc0 ffffffff81d215f0
[12577.395972] Call Trace:
[12577.396643]  [<ffffffff8165f7b5>] cpuidle_enter_state+0x55/0x190
[12577.397327]  [<ffffffff8165f9a7>] cpuidle_enter+0x17/0x20
[12577.398010]  [<ffffffff810bd665>] cpu_startup_entry+0x355/0x410
[12577.398691]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[12577.399364] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[12577.400864] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 74.851 msecs
[12591.532403] sched: RT throttling activated
[12613.269774] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 21s! [trinity-c12:30629]
[12613.270528] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12613.275557] CPU: 3 PID: 30629 Comm: trinity-c12 Tainted: G             L 3.18.0+ #106
[12613.278212] task: ffff8802433b5b40 ti: ffff880180f34000 task.ti: ffff880180f34000
[12613.279152] RIP: 0010:[<ffffffff8117e2df>]  [<ffffffff8117e2df>] free_hot_cold_page+0x11f/0x1a0
[12613.280117] RSP: 0018:ffff880180f37b38  EFLAGS: 00000202
[12613.281030] RAX: 0000000000000003 RBX: 0000000000000002 RCX: 0000000000000240
[12613.281939] RDX: ffff88024540d380 RSI: 0000000000000000 RDI: ffff88024e5d3f40
[12613.282817] RBP: ffff880180f37b78 R08: 0000000000000000 R09: 000000000024e600
[12613.283701] R10: 0000000000000002 R11: 0000000000000000 R12: ffff88024e5d3f40
[12613.284572] R13: 0000000180f37b08 R14: ffffffff8117df5b R15: ffff880180f37b28
[12613.285454] FS:  00007f688fc33740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12613.286408] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12613.287338] CR2: 00007f688baa9000 CR3: 00000002276f9000 CR4: 00000000001407e0
[12613.288228] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12613.289102] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12613.289957] Stack:
[12613.290804]  00000000001ddf58 ffff88024e5d3e80 ffff8802433b5b40 ffffea00076a8540
[12613.291675]  ffffea000777d600 0000000000000000 ffffea00062ec580 ffff880180f37c00
[12613.292574]  ffff880180f37bb8 ffffffff8117e3c5 000000000000000d ffffea00076a8540
[12613.293471] Call Trace:
[12613.294325]  [<ffffffff8117e3c5>] free_hot_cold_page_list+0x65/0xd0
[12613.295179]  [<ffffffff81184f2d>] release_pages+0x1bd/0x270
[12613.296027]  [<ffffffff81185f63>] __pagevec_release+0x43/0x60
[12613.296869]  [<ffffffff81191f80>] shmem_undo_range+0x460/0x710
[12613.297704]  [<ffffffff81192248>] shmem_truncate_range+0x18/0x40
[12613.298541]  [<ffffffff811924d6>] shmem_setattr+0x116/0x1a0
[12613.299383]  [<ffffffff812075d1>] notify_change+0x241/0x390
[12613.300250]  [<ffffffff811e5ad5>] do_truncate+0x75/0xc0
[12613.301103]  [<ffffffff811e5e4a>] ? do_sys_ftruncate.constprop.14+0xda/0x160
[12613.301962]  [<ffffffff811e5e7f>] do_sys_ftruncate.constprop.14+0x10f/0x160
[12613.302815]  [<ffffffff81374f6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[12613.303656]  [<ffffffff811e5f0e>] SyS_ftruncate+0xe/0x10
[12613.304497]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12613.305362] Code: 8d 7b 20 e8 64 3b 20 00 41 8b 04 24 83 c0 01 41 3b 44 24 04 41 89 04 24 7d 52 41 f7 c6 00 02 00 00 74 31 e8 94 bf fc ff 41 56 9d <48> 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 90 49 8d 34 04 
[12613.307230] sending NMI to other CPUs:
[12613.308088] NMI backtrace for cpu 2
[12613.308871] CPU: 2 PID: 30778 Comm: trinity-c161 Tainted: G             L 3.18.0+ #106
[12613.311213] task: ffff8800478eada0 ti: ffff8802251dc000 task.ti: ffff8802251dc000
[12613.311995] RIP: 0010:[<ffffffff810c96bd>]  [<ffffffff810c96bd>] do_raw_spin_trylock+0x2d/0x50
[12613.312776] RSP: 0018:ffff8802251dfd88  EFLAGS: 00000246
[12613.313536] RAX: 0000000000008f8f RBX: ffff880235610238 RCX: 0000000000000000
[12613.314287] RDX: 0000000000008f8f RSI: 000000000000908f RDI: ffff880235610238
[12613.315022] RBP: ffff8802251dfd88 R08: 0000000000000000 R09: 0000000000000000
[12613.315743] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880235610250
[12613.316446] R13: ffff88009f3cc640 R14: 0000000000000000 R15: ffff8802356103c0
[12613.317133] FS:  00007f688fc33740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12613.317813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12613.318483] CR2: 000000288076098d CR3: 000000022a0d2000 CR4: 00000000001407e0
[12613.319155] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12613.319819] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12613.320475] Stack:
[12613.321122]  ffff8802251dfdb8 ffffffff817ceea6 ffffffff81214c6a ffffffff817cf22b
[12613.321796]  ffff8802356101b0 ffff880235610238 ffff8802251dff08 ffffffff81214c6a
[12613.322474]  00000000251dfde8 7fffffffffffffff ffff88009f3cc520 ffff88017b9a3c28
[12613.323153] Call Trace:
[12613.323815]  [<ffffffff817ceea6>] _raw_spin_lock+0x46/0x80
[12613.324479]  [<ffffffff81214c6a>] ? sync_inodes_sb+0x1ca/0x2b0
[12613.325138]  [<ffffffff817cf22b>] ? _raw_spin_unlock+0x2b/0x40
[12613.325798]  [<ffffffff81214c6a>] sync_inodes_sb+0x1ca/0x2b0
[12613.326458]  [<ffffffff817cb01f>] ? wait_for_completion+0xff/0x130
[12613.327114]  [<ffffffff8121c560>] ? vfs_fsync+0x40/0x40
[12613.327761]  [<ffffffff8121c579>] sync_inodes_one_sb+0x19/0x20
[12613.328404]  [<ffffffff811ec002>] iterate_supers+0xb2/0x110
[12613.329041]  [<ffffffff8121c824>] sys_sync+0x44/0xb0
[12613.329669]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12613.330292] Code: 44 00 00 0f b7 17 55 31 c9 48 89 e5 38 d6 74 0e 89 c8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 8d b2 00 01 00 00 89 d0 f0 66 0f b1 37 <66> 39 d0 75 e0 b1 01 5d 65 8b 04 25 2c a0 00 00 89 47 08 65 48 
[12613.331704] NMI backtrace for cpu 0
[12613.332380] CPU: 0 PID: 1460 Comm: trinity-c155 Tainted: G             L 3.18.0+ #106
[12613.334512] task: ffff880232a72da0 ti: ffff880232820000 task.ti: ffff880232820000
[12613.335239] RIP: 0033:[<000000336ee93d7d>]  [<000000336ee93d7d>] 0x336ee93d7d
[12613.335984] RSP: 002b:00007fff9d870a18  EFLAGS: 00000206
[12613.336708] RAX: ffffff68f0ef8610 RBX: 0000000000000200 RCX: 00007fff9d870f00
[12613.337440] RDX: 00007fff9d871a00 RSI: 00007f688e769020 RDI: 00007fff9d870a20
[12613.338173] RBP: 00007fff9d871a60 R08: ffffff68f0ef8600 R09: ffffff68f0ef85f0
[12613.338905] R10: ffffff68f0ef85e0 R11: 0000000000000246 R12: 0000000000000129
[12613.339627] R13: 0000000000001000 R14: 0000000000001000 R15: 00007f688e6a9000
[12613.340332] FS:  00007f688fc33740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[12613.341040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12613.341753] CR2: 00007f688e702000 CR3: 00000001c9675000 CR4: 00000000001407f0
[12613.342468] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12613.343161] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12613.343836] 
[12613.344498] NMI backtrace for cpu 1
[12613.345187] CPU: 1 PID: 30783 Comm: trinity-c166 Tainted: G             L 3.18.0+ #106
[12613.347247] task: ffff8801c059ada0 ti: ffff880227058000 task.ti: ffff880227058000
[12613.347978] RIP: 0033:[<000000336ee39bc0>]  [<000000336ee39bc0>] 0x336ee39bc0
[12613.348715] RSP: 002b:00007fff9d8719d8  EFLAGS: 00000202
[12613.349440] RAX: e8ffff3573f747e9 RBX: 00007f688f22e000 RCX: 0000000000000000
[12613.350175] RDX: 8000000000000000 RSI: 00007fff9d8719cc RDI: 000000336f1b76e0
[12613.350903] RBP: 00007f688f22e068 R08: 000000336f1b7120 R09: 000000336f1b7140
[12613.351639] R10: ffffffffffff9f00 R11: 0000000000000202 R12: 00007f688fbb7528
[12613.352362] R13: 00007f688f22e068 R14: 0000000000000000 R15: 0000000000000000
[12613.353089] FS:  00007f688fc33740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12613.353814] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12613.354537] CR2: 0000000000000008 CR3: 0000000153ac1000 CR4: 00000000001407e0
[12613.355265] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12613.355989] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12613.356701] 
[12641.253566] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [trinity-main:30108]
[12641.254492] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12641.260655] CPU: 3 PID: 30108 Comm: trinity-main Tainted: G             L 3.18.0+ #106
[12641.263755] task: ffff8800a0d15b40 ti: ffff880234ec4000 task.ti: ffff880234ec4000
[12641.264753] RIP: 0010:[<ffffffff811729d7>]  [<ffffffff811729d7>] task_bp_pinned.isra.6.constprop.12+0x37/0x90
[12641.265768] RSP: 0018:ffff880234ec7a40  EFLAGS: 00000287
[12641.266763] RAX: ffff88023f199d18 RBX: 000000000000005c RCX: 00000000001ce490
[12641.267751] RDX: ffff8801c87c2fa8 RSI: ffff8801ad860000 RDI: 0000000000000007
[12641.268728] RBP: ffff880234ec7a70 R08: ffffffff81d215f8 R09: ffff880245dce490
[12641.269700] R10: 0000000000000000 R11: 0000000000000008 R12: ffff880234ec7a30
[12641.270657] R13: ffffffff810abaf5 R14: ffff880234ec79b0 R15: ffffea000252c000
[12641.271618] FS:  00007f688fc33740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12641.272585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12641.273547] CR2: 000000336f1b8490 CR3: 0000000229035000 CR4: 00000000001407e0
[12641.274502] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12641.275443] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000017060a
[12641.276381] Stack:
[12641.277317]  0000000000000002 ffff8800a0d15b40 ffff880234ec7aa0 0000000000000001
[12641.278267]  ffff880094b06618 0000000000000007 ffff880234ec7ad0 ffffffff81172af6
[12641.279214]  ffffffff81c64868 0000000100000246 00000000001ce490 ffffffff81d215f8
[12641.280161] Call Trace:
[12641.281101]  [<ffffffff81172af6>] toggle_bp_slot.constprop.7+0xc6/0x1b0
[12641.282055]  [<ffffffff81172dfb>] __reserve_bp_slot+0x1eb/0x230
[12641.283017]  [<ffffffff81172e77>] reserve_bp_slot+0x27/0x40
[12641.283972]  [<ffffffff81172f68>] register_perf_hw_breakpoint+0x18/0x60
[12641.284884]  [<ffffffff81172fdf>] hw_breakpoint_event_init+0x2f/0x50
[12641.285766]  [<ffffffff8116fcfb>] perf_init_event+0x17b/0x1e0
[12641.286650]  [<ffffffff8116fb80>] ? perf_bp_event+0xd0/0xd0
[12641.287512]  [<ffffffff811700f8>] perf_event_alloc+0x398/0x440
[12641.288373]  [<ffffffff810e3c1c>] ? do_init_timer+0x5c/0x60
[12641.289239]  [<ffffffff81170e3e>] inherit_event.isra.90+0x8e/0x260
[12641.290095]  [<ffffffff8117104e>] inherit_task_group.isra.92.part.93+0x3e/0xe0
[12641.290959]  [<ffffffff811716e3>] perf_event_init_task+0x163/0x2e0
[12641.291812]  [<ffffffff81075756>] copy_process.part.26+0x726/0x1a40
[12641.292664]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[12641.293514]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12641.294347]  [<ffffffff810424b2>] ? __do_page_fault+0x232/0x610
[12641.295158]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[12641.295969]  [<ffffffff811ea0b1>] ? __fput+0x191/0x200
[12641.296791]  [<ffffffff81374fe4>] ? lockdep_sys_exit_thunk+0x35/0x67
[12641.297597]  [<ffffffff81077066>] SyS_clone+0x16/0x20
[12641.298395]  [<ffffffff817d0299>] stub_clone+0x69/0x90
[12641.299173]  [<ffffffff817cff12>] ? system_call_fastpath+0x12/0x17
[12641.299935] Code: 54 53 48 83 ec 18 48 8b 05 57 1f af 00 48 8d 98 c0 fe ff ff 48 3d 10 49 c6 81 74 4c 41 89 fd 45 31 e4 eb 17 48 8b 93 40 01 00 00 <48> 8d 9a c0 fe ff ff 48 81 fa 10 49 c6 81 74 39 48 3b b3 28 01 
[12641.301567] sending NMI to other CPUs:
[12641.302311] NMI backtrace for cpu 1
[12641.303001] CPU: 1 PID: 3545 Comm: trinity-c7 Tainted: G             L 3.18.0+ #106
[12641.305035] task: ffff8800963f96d0 ti: ffff880215b28000 task.ti: ffff880215b28000
[12641.305715] RIP: 0010:[<ffffffff810fc466>]  [<ffffffff810fc466>] smp_call_function_many+0x276/0x320
[12641.306405] RSP: 0000:ffff880215b2baa8  EFLAGS: 00000202
[12641.307074] RAX: 0000000000000003 RBX: ffff8802451d3b00 RCX: ffff8802455d9488
[12641.307748] RDX: 0000000000000003 RSI: 0000000000000008 RDI: 0000000000000000
[12641.308423] RBP: ffff880215b2baf8 R08: ffff880243741e30 R09: 0000000100180011
[12641.309097] R10: ffff880244804240 R11: 0000000000000000 R12: 0000000000000003
[12641.309770] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000008
[12641.310436] FS:  00007f688fc33740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12641.311099] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12641.311757] CR2: 0000000002258ff8 CR3: 0000000180fec000 CR4: 00000000001407e0
[12641.312420] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12641.313082] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12641.313744] Stack:
[12641.314390]  ffff88024e5d4d00 0000000000000001 0000000100000003 00000000001d3ac0
[12641.315059]  0000004000000000 ffffffff82bea298 0000000000000001 ffffffff8117e150
[12641.315726]  0000000000000000 0000000000000000 ffff880215b2bb28 ffffffff810fc652
[12641.316393] Call Trace:
[12641.317045]  [<ffffffff8117e150>] ? drain_pages+0xc0/0xc0
[12641.317698]  [<ffffffff810fc652>] on_each_cpu_mask+0x32/0xa0
[12641.318351]  [<ffffffff8117c371>] drain_all_pages+0x101/0x120
[12641.319003]  [<ffffffff8118024f>] __alloc_pages_nodemask+0x7af/0xb40
[12641.319657]  [<ffffffff811c8ebe>] alloc_pages_vma+0xee/0x1b0
[12641.320310]  [<ffffffff811a416a>] ? do_wp_page+0xca/0x770
[12641.320959]  [<ffffffff811a416a>] do_wp_page+0xca/0x770
[12641.321608]  [<ffffffff811a69bb>] handle_mm_fault+0x6cb/0xe90
[12641.322258]  [<ffffffff8104241d>] ? __do_page_fault+0x19d/0x610
[12641.322910]  [<ffffffff8104248c>] __do_page_fault+0x20c/0x610
[12641.323557]  [<ffffffff811aa2dc>] ? validate_mm+0x15c/0x2c0
[12641.324204]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[12641.324847]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12641.325494]  [<ffffffff81374fad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[12641.326142]  [<ffffffff8104289c>] do_page_fault+0xc/0x10
[12641.326785]  [<ffffffff817d1b32>] page_fault+0x22/0x30
[12641.327423] Code: 00 41 89 c4 39 f0 0f 8d 27 fe ff ff 48 63 d0 48 8b 0b 48 03 0c d5 a0 f2 d1 81 f6 41 18 01 74 14 0f 1f 44 00 00 f3 90 f6 41 18 01 <75> f8 48 63 35 05 63 c2 00 83 f8 ff 48 8b 7b 08 74 b0 39 c6 77 
[12641.328871] NMI backtrace for cpu 0
[12641.329555] CPU: 0 PID: 30823 Comm: trinity-c206 Tainted: G             L 3.18.0+ #106
[12641.331677] task: ffff8801ad862da0 ti: ffff88017d7d0000 task.ti: ffff88017d7d0000
[12641.332396] RIP: 0010:[<ffffffff810fc466>]  [<ffffffff810fc466>] smp_call_function_many+0x276/0x320
[12641.333117] RSP: 0000:ffff88017d7d3a18  EFLAGS: 00000202
[12641.333827] RAX: 0000000000000003 RBX: ffff880244fd3b00 RCX: ffff8802455d7228
[12641.334546] RDX: 0000000000000003 RSI: 0000000000000008 RDI: 0000000000000000
[12641.335264] RBP: ffff88017d7d3a68 R08: ffff88024483b650 R09: 0000000100180011
[12641.335968] R10: ffff880244804240 R11: 0000000000000000 R12: 0000000000000003
[12641.336653] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000008
[12641.337327] FS:  00007f688fc33740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[12641.338000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12641.338665] CR2: 0000000002258ff8 CR3: 0000000232b93000 CR4: 00000000001407f0
[126[12641.356633] NMI backtrace for cpu 2
[12641.357349] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #106
[12641.359555] task: ffff8802434bc470 ti: ffff880243758000 task.ti: ffff880243758000
[12641.360314] RIP: 0010:[<ffffffff813d6cab>]  [<ffffffff813d6cab>] intel_idle+0xdb/0x180
[12641.361070] RSP: 0000:ffff88024375be08  EFLAGS: 00000046
[12641.361812] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[12641.362561] RDX: 0000000000000000 RSI: ffff88024375bfd8 RDI: 0000000000000002
[12641.363289] RBP: ffff88024375be38 R08: 000000008baf89af R09: 0000000000000000
[12641.363998] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[12641.364680] R13: 0000000000000000 R14: 0000000000000001 R15: ffff880243758000
[12641.365350] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12641.366017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12641.366678] CR2: 0000000002258ff8 CR3: 0000000097dd1000 CR4: 00000000001407e0
[12641.367347] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12641.368016] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[12641.368680] Stack:
[12641.369340]  000000024375be38 5dccb806cd27b931 ffffe8ffff203200 0000000000000001
[12641.370021]  ffffffff81cb1bc0 0000000000000002 ffff88024375be88 ffffffff8165f7b5
[12641.370710]  00000b80fc4e5dd1 ffffffff81cb1c30 ffffffff81cb1bc0 ffffffff81d215f0
[12641.371403] Call Trace:
[12641.372073]  [<ffffffff8165f7b5>] cpuidle_enter_state+0x55/0x190
[12641.372758]  [<ffffffff8165f9a7>] cpuidle_enter+0x17/0x20
[12641.373441]  [<ffffffff810bd665>] cpu_startup_entry+0x355/0x410
[12641.374108]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[12641.374769] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[12669.237353] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [trinity-c59:7816]
[12669.238086] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[12669.242957] CPU: 3 PID: 7816 Comm: trinity-c59 Tainted: G             L 3.18.0+ #106
[12669.245468] task: ffff8802258796d0 ti: ffff88007df64000 task.ti: ffff88007df64000
[12669.246378] RIP: 0010:[<ffffffff810c6014>]  [<ffffffff810c6014>] lock_acquire+0xb4/0x120
[12669.247281] RSP: 0018:ffff88007df67da8  EFLAGS: 00000246
[12669.248181] RAX: ffff8802258796d0 RBX: ffffffff810c512c RCX: ffff8802455cff98
[12669.249074] RDX: 00000000000001e0 RSI: 0000000000000010 RDI: 0000000000000000
[12669.249977] RBP: ffff88007df67e08 R08: 0000000000000000 R09: 0000000000000000
[12669.250881] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff810abaf5
[12669.251790] R13: ffff88007df67d18 R14: ffffffff810abaf5 R15: ffff88007df67d08
[12669.252693] FS:  00007f688fc33740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[12669.253585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12669.254486] CR2: 000000336f1b7740 CR3: 00000000a0ef4000 CR4: 00000000001407e0
[12669.255431] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12669.256368] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12669.257263] Stack:
[12669.258097]  ffffffff81086b05 0000000000000000 0000000000000000 0000000000000246
[12669.258933]  0000000000000002 ffffffff81c50e20 ffff88007df67e48 00000000000024ca
[12669.259768]  0000000000000000 ffff88007df67eb0 ffff8800953896d0 0000000000000000
[12669.260638] Call Trace:
[12669.261471]  [<ffffffff81086b05>] ? group_send_sig_info+0x5/0xc0
[12669.262318]  [<ffffffff81086b48>] group_send_sig_info+0x48/0xc0
[12669.263170]  [<ffffffff81086b05>] ? group_send_sig_info+0x5/0xc0
[12669.264028]  [<ffffffff81086d05>] kill_pid_info+0x65/0xb0
[12669.264945]  [<ffffffff81086ca5>] ? kill_pid_info+0x5/0xb0
[12669.265851]  [<ffffffff81086e3c>] SYSC_kill+0xcc/0x240
[12669.266674]  [<ffffffff81086df8>] ? SYSC_kill+0x88/0x240
[12669.267508]  [<ffffffff8107aebb>] ? SyS_wait4+0x8b/0x110
[12669.268328]  [<ffffffff81088cde>] SyS_kill+0xe/0x10
[12669.269145]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12669.269958] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[12669.271728] sending NMI to other CPUs:
[12669.272548] NMI backtrace for cpu 1
[12669.273314] CPU: 1 PID: 7878 Comm: trinity-c219 Tainted: G             L 3.18.0+ #106
[12669.275686] task: ffff880096860000 ti: ffff880097f2c000 task.ti: ffff880097f2c000
[12669.276489] RIP: 0010:[<ffffffff811037c2>]  [<ffffffff811037c2>] is_module_text_address+0x22/0x30
[12669.277296] RSP: 0018:ffff880097f2f9e8  EFLAGS: 00000046
[12669.278089] RAX: 0000000000000000 RBX: ffff880097f2fd70 RCX: 0000000000000004
[12669.278876] RDX: ffff880227e01b80 RSI: 0000000000000000 RDI: ffff880097f2fd70
[12669.279650] RBP: ffff880097f2fa00 R08: ffff880097f2fb40 R09: 0000000000000000
[12669.280408] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[12669.281147] R13: ffff880097f2fd80 R14: ffff880097f2fd50 R15: ffffffff81801b30
[12669.281874] FS:  00007f688fc33740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[12669.282595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12669.283299] CR2: 0000000001cb9a28 CR3: 00000000948d4000 CR4: 00000000001407e0
[12669.283997] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12669.284677] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12669.285348] Stack:
[12669.286003]  ffffffff810973c8 0000000000000000 ffff880097f2fd70 ffff880097f2fa70
[12669.286678]  ffffffff81006a7f ffff880097f2fa20 ffff880097f2fff8 ffff880097f2c000
[12669.287346]  ffff880097f2fd80 ffff880097f2fb40 ffffffffffffc000 0000000000000000
[12669.288011] Call Trace:
[12669.288672]  [<ffffffff810973c8>] ? __kernel_text_address+0x58/0x80
[12669.289343]  [<ffffffff81006a7f>] print_context_stack+0x8f/0x100
[12669.290009]  [<ffffffff8100559f>] dump_trace+0x16f/0x350
[12669.290668]  [<ffffffff811b22a9>] ? anon_vma_clone+0x49/0x140
[12669.291321]  [<ffffffff811b22a9>] ? anon_vma_clone+0x49/0x140
[12669.291963]  [<ffffffff810135bf>] save_stack_trace+0x2f/0x50
[12669.292603]  [<ffffffff811ce860>] set_track+0x70/0x140
[12669.293240]  [<ffffffff817c26de>] alloc_debug_processing+0x92/0x118
[12669.293872]  [<ffffffff817c33b2>] __slab_alloc+0x4da/0x58f
[12669.294498]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[12669.295119]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[12669.295745]  [<ffffffff811b22a9>] ? anon_vma_clone+0x49/0x140
[12669.296362]  [<ffffffff811b22a9>] ? anon_vma_clone+0x49/0x140
[12669.296969]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[12669.297577]  [<ffffffff811b22a9>] anon_vma_clone+0x49/0x140
[12669.298185]  [<ffffffff811b23cd>] anon_vma_fork+0x2d/0x100
[12669.298790]  [<ffffffff81076392>] copy_process.part.26+0x1362/0x1a40
[12669.299398]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[12669.300009]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[12669.300619]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[12669.301232]  [<ffffffff81374fe4>] ? lockdep_sys_exit_thunk+0x35/0x67
[12669.301850]  [<ffffffff81077066>] SyS_clone+0x16/0x20
[12669.302466]  [<ffffffff817d0299>] stub_clone+0x69/0x90
[12669.303062]  [<ffffffff817cff12>] ? system_call_fastpath+0x12/0x17
[12669.303646] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 65 ff 04 25 e0 a9 00 00 e8 4a b7 ff ff 65 ff 0c 25 e0 a9 00 00 48 85 c0 5d <0f> 95 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
[12669.304961] NMI backtrace for cpu 0
[12669.305579] CPU: 0 PID: 5863 Comm: trinity-c230 Tainted: G             L 3.18.0+ #106
[12669.307401] task: ffff88023f830000 ti: ffff880096b74000 task.ti: ffff880096b74000
[12669.308023] RIP: 0010:[<ffffffff81191f24>]  [<ffffffff81191f24>] shmem_undo_range+0x404/0x710
[12669.308649] RSP: 0000:ffff880096b77c78  EFLAGS: 00000246
[12669.309266] RAX: 002ffe000008003d RBX: 000000000000000c RCX: 0000000000000835
[12669.309888] RDX: ffffea0005e915c0 RSI: ffffea0005e91580 RDI:[12669.325471] NMI backtrace for cpu 2
[12669.326185] CPU: 2 PID: 7188 Comm: trinity-c210 Tainted: G             L 3.18.0+ #106
[12669.328331] task: ffff8800a0d14470 ti: ffff8801c96d4000 task.ti: ffff8801c96d4000
[12669.329085] RIP: 0010:[<ffffffff810c4f21>]  [<ffffffff810c4f21>] __lock_acquire.isra.31+0x21/0x9f0
[12669.329858] RSP: 0018:ffff8801c96d79b8  EFLAGS: 00000096
[12669.330627] RAX: ffffffff81185068 RBX: ffff8800a0d14470 RCX: 0000000000000000
[12669.331406] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88024e5d3c58
[12669.332191] RBP: ffff8801c96d7a28 R08: 0000000000000001 R09: 0000000000000000
[12669.332984] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[12669.333780] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[12669.334577] FS:  00007f688fc33740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[12669.335370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12669.336152] CR2: 00007f688d8a9000 CR3: 00000002271f7000 CR4: 00000000001407e0
[12669.336934] DR0: 00007f688e6a9000 DR1: 0000000000000000 DR2: 0000000000000000
[12669.337707] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[12669.338474] Stack:
[12669.339224]  ffff8801c96d79f8 0000000093c05f9b 00000000000000d0 ffffffff82c00cc0
[12669.340023]  ffff8800a0d14470 00000000000200da ffff8800a0d15780 0000000000000000
[12669.340803]  ffff8801c96d7a08 0000000000000046 0000000000000000 0000000000000000
[12669.341541] Call Trace:
[12669.342270]  [<ffffffff810c5fff>] lock_acquire+0x9f/0x120
[12669.342998]  [<ffffffff81185068>] ? pagevec_lru_move_fn+0x88/0x100
[12669.343728]  [<ffffffff817cf0a9>] _raw_spin_lock_irqsave+0x49/0x90
[12669.344455]  [<ffffffff81185068>] ? pagevec_lru_move_fn+0x88/0x100
[12669.345190]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12669.345916]  [<ffffffff81185068>] pagevec_lru_move_fn+0x88/0x100
[12669.346640]  [<ffffffff81185160>] ? __pagevec_lru_add+0x20/0x20
[12669.347374]  [<ffffffff81185811>] __lru_cache_add+0x71/0x90
[12669.348097]  [<ffffffff81185bf9>] lru_cache_add_anon+0x19/0x20
[12669.348811]  [<ffffffff81190b08>] shmem_getpage_gfp+0x528/0x7a0
[12669.349559]  [<ffffffff81190dc2>] shmem_write_begin+0x42/0x70
[12669.350260]  [<ffffffff81175fc4>] generic_perform_write+0xd4/0x1f0
[12669.350957]  [<ffffffff81178722>] __generic_file_write_iter+0x162/0x350
[12669.351655]  [<ffffffff811e7940>] ? new_sync_read+0xd0/0xd0
[12669.352348]  [<ffffffff8117894f>] generic_file_write_iter+0x3f/0xb0
[12669.353037]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12669.353738]  [<ffffffff811e7a88>] do_iter_readv_writev+0x78/0xc0
[12669.354434]  [<ffffffff811e92b8>] do_readv_writev+0xd8/0x2a0
[12669.355126]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12669.355828]  [<ffffffff81178910>] ? __generic_file_write_iter+0x350/0x350
[12669.356531]  [<ffffffff810c361f>] ? lock_release_holdtime.part.24+0xf/0x190
[12669.357228]  [<ffffffff817cf310>] ? _raw_spin_unlock_irq+0x30/0x40
[12669.357921]  [<ffffffff811e950c>] vfs_writev+0x3c/0x50
[12669.358596]  [<ffffffff811e967c>] SyS_writev+0x5c/0x100
[12669.359258]  [<ffffffff817cff12>] system_call_fastpath+0x12/0x17
[12669.359905] Code: 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 48 44 8b 25 48 80 be 00 65 48 8b 1c 25 00 aa 00 00 <45> 85 e4 0f 84 ef 00 00 00 44 8b 1d e7 32 ab 01 49 89 fe 41 89 
[12669.361354] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 88.798 msecs
[15739.449422] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u16:3:14112]
[15739.450087] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15739.454475] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G             L 3.18.0+ #106
[15739.456686] Workqueue: khelper __call_usermodehelper
[15739.457473] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: ffff880227eac000
[15739.458231] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] __slab_alloc+0x52f/0x58f
[15739.459015] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
[15739.459794] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 00000000000002e0
[15739.460570] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: ffff880244802000
[15739.461343] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 0000000000000000
[15739.462113] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810135bf
[15739.462885] R13: ffff880227eaf878 R14: 0000000100160015 R15: ffffffff8138278d
[15739.463648] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15739.464431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15739.465203] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 00000000001407e0
[15739.465985] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15739.466766] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15739.467542] Stack:
[15739.468308]  000000000000005c ffff880240f8d790 ffff880240f8d790 ffff880240f8dd00
[15739.469106]  0000000180230020 000000010000000f ffffffff8112ee12 0000000000000000
[15739.469912]  ffff8802453d7260 000000020023001f ffff880227eaf968 ffffffff8138278d
[15739.470717] Call Trace:
[15739.471511]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
[15739.472325]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15739.473138]  [<ffffffff811ce860>] ? set_track+0x70/0x140
[15739.473947]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
[15739.474757]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15739.475571]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[15739.476374]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
[15739.477174]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
[15739.477983]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
[15739.478781]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
[15739.479590]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
[15739.480387]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
[15739.481184]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15739.481983]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15739.482797]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
[15739.483598]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[15739.484382]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15739.485160]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15739.485922]  [<ffffffff81077006>] kernel_thread+0x26/0x30
[15739.486669]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
[15739.487407]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
[15739.488126]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15739.488834]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
[15739.489529]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
[15739.490197]  [<ffffffff81098c89>] kthread+0xf9/0x110
[15739.490845]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15739.491474]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15739.492092]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
[15739.492689]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15739.493288] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 22 46 
[15739.494617] sending NMI to other CPUs:
[15739.495221] NMI backtrace for cpu 3
[15739.495787] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G             L 3.18.0+ #106
[15739.497539] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: ffff880180e04000
[15739.498153] RIP: 0010:[<ffffffff810c6014>]  [<ffffffff810c6014>] lock_acquire+0xb4/0x120
[15739.498772] RSP: 0018:ffff880180e07dd8  EFLAGS: 00000246
[15739.499382] RAX: ffff8801adac4470 RBX: 0000000000000246 RCX: ffff8802455cff98
[15739.499994] RDX: 00000000000006a0 RSI: 0000000000000000 RDI: 0000000000000000
[15739.500609] RBP: ffff880180e07e38 R08: 0000000000000000 R09: 0000000000000000
[15739.501224] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[15739.501829] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
[15739.502422] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15739.503021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15739.503621] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 00000000001407e0
[15739.504217] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15739.504812] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15739.505403] Stack:
[15739.505988]  ffffffff8107a8e9 0000000000000000 ffff8801adac4470 0000000000000246
[15739.506603]  0000000127cc4da0 ffffffff81c0a098 ffff8801adac4470 ffffffff81c0a080
[15739.507220]  ffffffff81c0a098 ffff8801adac4470 ffff8801adac4470 ffff8801adac4470
[15739.507839] Call Trace:
[15739.508448]  [<ffffffff8107a8e9>] ? do_wait+0xd9/0x280
[15739.509064]  [<ffffffff817cf3d1>] _raw_read_lock+0x41/0x80
[15739.509678]  [<ffffffff8107a8e9>] ? do_wait+0xd9/0x280
[15739.510293]  [<ffffffff8107a8e9>] do_wait+0xd9/0x280
[15739.510907]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
[15739.511518]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
[15739.512130]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
[15739.512739] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15739.514121] NMI backtrace for cpu 1
[15739.514769] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G             L 3.18.0+ #106
[15739.516771] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: ffff880153a4c000
[15739.517467] RIP: 0010:[<ffffffff810961f9>]  [<ffffffff810961f9>] find_pid_ns+0x39/0x90
[15739.518177] RSP: 0018:ffff880153a4fe78  EFLAGS: 00000207
[15739.518884] RAX: ffff88024e517120 RBX: 0000000000000d7f RCX: 0000000000000034
[15739.519599] RDX: ffff880094be6500 RSI: ffffffff81c486c0 RDI: 0000000000000d7f
[15739.520316] RBP: ffff880153a4fe78 R08: 0000000000000000 R09: 0000000000000000
[15739.521036] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[15739.521752] R13: ffff880096b4c470 R14: 0000000000000000 R15: 0000000000000000
[15739.522464] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15739.523181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15739.523882] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 00000000001407e0
[15739.524580] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15739.525269] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15739.525957] Stack:
[15739.526632]  ffff880153a4fe88 ffffffff8109627f ffff880153a4ff68 ffffffff81086e2a
[15739.527319]  ffffffff81086df8 0000000000000000 ffff880096b4c840 0000000000000000
[15739.527992]  ffff880100000000 000003e800000b21 ffff880094be64c0 00007fff123fb870
[15739.528656] Call Trace:
[15739.529301]  [<ffffffff8109627f>] find_vpid+0x2f/0x50
[15739.529947]  [<ffffffff81086e2a>] SYSC_kill+0xba/0x240
[15739.530587]  [<ffffffff81086df8>] ? SYSC_kill+0x88/0x240
[15739[15763.435537] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u16:3:14112]
[15763.436252] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15763.441025] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G             L 3.18.0+ #106
[15763.443320] Workqueue: khelper __call_usermodehelper
[15763.444090] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: ffff880227eac000
[15763.444861] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] __slab_alloc+0x52f/0x58f
[15763.445654] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
[15763.446422] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 00000000000002e0
[15763.447201] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: ffff880244802000
[15763.447985] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 0000000000000000
[15763.448764] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810135bf
[15763.449545] R13: ffff880227eaf878 R14: 0000000100160015 R15: ffffffff8138278d
[15763.450319] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15763.451100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15763.451876] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 00000000001407e0
[15763.452662] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15763.453451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15763.454230] Stack:
[15763.455003]  000000000000005c ffff880240f8d790 ffff880240f8d790 ffff880240f8dd00
[15763.455818]  0000000180230020 000000010000000f ffffffff8112ee12 0000000000000000
[15763.456608]  ffff8802453d7260 000000020023001f ffff880227eaf968 ffffffff8138278d
[15763.457393] Call Trace:
[15763.458166]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
[15763.458960]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15763.459753]  [<ffffffff811ce860>] ? set_track+0x70/0x140
[15763.460544]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
[15763.461338]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15763.462127]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[15763.462921]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
[15763.463707]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
[15763.464503]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
[15763.465294]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
[15763.466086]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
[15763.466875]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
[15763.467664]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15763.468458]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15763.469251]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
[15763.470041]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[15763.470828]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15763.471603]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15763.472371]  [<ffffffff81077006>] kernel_thread+0x26/0x30
[15763.473120]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
[15763.473854]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
[15763.474578]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15763.475287]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
[15763.475975]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
[15763.476640]  [<ffffffff81098c89>] kthread+0xf9/0x110
[15763.477285]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15763.477915]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15763.478532]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
[15763.479131]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15763.479741] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 22 46 
[15763.481087] sending NMI to other CPUs:
[15763.481693] NMI backtrace for cpu 3
[15763.482255] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G             L 3.18.0+ #106
[15763.484005] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: ffff880180e04000
[15763.484618] RIP: 0010:[<ffffffff810c47f5>]  [<ffffffff810c47f5>] lock_acquired+0x45/0x370
[15763.485234] RSP: 0018:ffff880180e07db8  EFLAGS: 00000046
[15763.485841] RAX: 0000000000000001 RBX: ffff880227cc4da0 RCX: 0000000000000001
[15763.486453] RDX: 000000000000dbdb RSI: ffffffff810bcc8d RDI: ffff880227cc4db8
[15763.487068] RBP: ffff880180e07df8 R08: 0000000000000000 R09: 0000000000000001
[15763.487687] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801adac4470
[15763.488303] R13: ffff880227cc4db8 R14: 0000000000000046 R15: ffff8801adac4460
[15763.488909] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15763.489522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15763.490133] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 00000000001407e0
[15763.490747] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15763.491356] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15763.491964] Stack:
[15763.492564]  0000000100000002 ffffffff810bcc8d ffff880180e07dd8 ffff880227cc4da0
[15763.493194]  ffff880227cc4db8 0000000000000292 ffff8801adac4470 ffff8801adac4460
[15763.493828]  ffff880180e07e38 ffffffff817cf0d5 ffffffff810bcc8d 0000000000000296
[15763.494464] Call Trace:
[15763.495088]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
[15763.495726]  [<ffffffff817cf0d5>] _raw_spin_lock_irqsave+0x75/0x90
[15763.496364]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
[15763.497005]  [<ffffffff810bcc8d>] remove_wait_queue+0x1d/0x40
[15763.497645]  [<ffffffff8107a95b>] do_wait+0x14b/0x280
[15763.498283]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
[15763.498917]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
[15763.499551]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
[15763.500183] Code: b8 00 45 85 c9 0f 84 d8 00 00 00 65 4c 8b 24 25 00 aa 00 00 45 8b 84 24 6c 07 00 00 45 85 c0 0f 85 be 00 00 00 49 89 fd 9c 41 5e <fa> 8b 35 1c 3a ab 01 41 c7 84 24 6c 07 00 00 01 00 00 00 41 8b 
[15763.501611] NMI backtrace for cpu 1
[15763.502274] CPU: 1 PID: 3298 Comm: trinity-c183 Tainted: G             L 3.18.0+ #106
[15763.504345] task: ffff880227de16d0 ti: ffff880071060000 task.ti: ffff880071060000
[15763.505065] RIP: 0033:[<000000336eebc2fc>]  [<000000336eebc2fc>] 0x336eebc2fc
[15763.505796] RSP: 002b:00007fff123fb868  EFLAGS: 00000246
[15763.506522] RAX: 0000000000000000 RBX: 0000000000000d7b RCX: ffffffffffffffff
[15763.507257] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 0000000000000d7b
[15763.507994] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 0000000000000000
[15763.508729] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7996cf6000
[15763.509460] R13: 00007f7996cf6068 R14: 0000000000000000 R15: 0000000000000000
[15763.510188] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15763.510908] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15763.511612] CR2: 00007f7996f24220 CR3: 000000009a646000 CR4: 00000000001407e0
[15763.512319] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15763.513027] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15763.513727] 
[15763.514403] NMI backtrace for cpu 0
[15763.515067] CPU: 0 PID: 1876 Comm: trinity-c189 Tainted: G             L 3.18.0+ #106
[15763.517087] task: ffff880096b4ada0 ti: ffff8802253d0000 task.ti: ffff8802253d0000
[15763.517776] RIP: 0010:[<[15779.306349] INFO: rcu_sched detected stalls on CPUs/tasks:
[15779.307024] 	(detected by 0, t=6002 jiffies, g=481360, c=481359, q=0)
[15779.307662] INFO: Stall ended before state dump start
[15787.421647] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u16:3:14112]
[15787.422333] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15787.426946] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G             L 3.18.0+ #106
[15787.429181] Workqueue: khelper __call_usermodehelper
[15787.429945] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: ffff880227eac000
[15787.430719] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] __slab_alloc+0x52f/0x58f
[15787.431507] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
[15787.432297] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 00000000000002e0
[15787.433094] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: ffff880244802000
[15787.433886] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 0000000000000000
[15787.434671] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810135bf
[15787.435452] R13: ffff880227eaf878 R14: 0000000100160015 R15: ffffffff8138278d
[15787.436234] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15787.437028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15787.437816] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 00000000001407e0
[15787.438605] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15787.439400] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15787.440183] Stack:
[15787.440959]  000000000000005c ffff880240f8d790 ffff880240f8d790 ffff880240f8dd00
[15787.441792]  0000000180230020 000000010000000f ffffffff8112ee12 0000000000000000
[15787.442615]  ffff8802453d7260 000000020023001f ffff880227eaf968 ffffffff8138278d
[15787.443422] Call Trace:
[15787.444217]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
[15787.445027]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15787.445833]  [<ffffffff811ce860>] ? set_track+0x70/0x140
[15787.446647]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
[15787.447449]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15787.448258]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[15787.449067]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
[15787.449879]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
[15787.450688]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
[15787.451497]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
[15787.452307]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
[15787.453122]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
[15787.453928]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15787.454733]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15787.455524]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
[15787.456299]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[15787.457062]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15787.457826]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15787.458587]  [<ffffffff81077006>] kernel_thread+0x26/0x30
[15787.459336]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
[15787.460078]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
[15787.460794]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15787.461495]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
[15787.462182]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
[15787.462850]  [<ffffffff81098c89>] kthread+0xf9/0x110
[15787.463496]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15787.464124]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15787.464742]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
[15787.465341]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15787.465947] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 22 46 
[15787.467291] sending NMI to other CPUs:
[15787.467904] NMI backtrace for cpu 3
[15787.468463] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G             L 3.18.0+ #106
[15787.470211] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: ffff880180e04000
[15787.470824] RIP: 0033:[<000000336eebc2fc>]  [<000000336eebc2fc>] 0x336eebc2fc
[15787.471440] RSP: 002b:00007fff123fb868  EFLAGS: 00000246
[15787.472043] RAX: 0000000000000000 RBX: 0000000000000d7e RCX: ffffffffffffffff
[15787.472652] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 0000000000000d7e
[15787.473259] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 0000000000000000
[15787.473868] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7997265000
[15787.474468] R13: 00007f7997265068 R14: 0000000000000000 R15: 0000000000000000
[15787.475063] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15787.475660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15787.476254] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 00000000001407e0
[15787.476851] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15787.477442] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15787.478032] 
[15787.478615] NMI backtrace for cpu 1
[15787.479205] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G             L 3.18.0+ #106
[15787.481052] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: ffff880153a4c000
[15787.481696] RIP: 0010:[<ffffffff817cfea0>]  [<ffffffff817cfea0>] system_call+0x0/0x3
[15787.482351] RSP: 0018:00007fff123fb868  EFLAGS: 00000046
[15787.483007] RAX: 000000000000003d RBX: 0000000000000d7f RCX: 000000336eebc2fc
[15787.483674] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 0000000000000d7f
[15787.484338] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 0000000000000000
[15787.485000] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f799716e000
[15787.485658] R13: 00007f799716e068 R14: 0000000000000000 R15: 0000000000000000
[15787.486314] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15787.486979] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15787.487641] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 00000000001407e0
[15787.488311] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15787.488982] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15787.489650] Stack:
[15787.490312]  000000000041401b 00007f79976944e8 00007f799716e000 0000000000000001
[15787.490999]  00007f799716e07c 00007f799716e000 0000000000000000 00007f799716e07c
[15787.491690]  0000000000416c03 00000000000066b2 0000000000000155 00000000cccccccd
[15787.492383] Call Trace:
[15787.493063]  <UNK> 
[15787.493070] Code: 8b 3c 24 4c 8b 74 24 08 4c 8b 6c 24 10 4c 8b 64 24 18 48 8b 6c 24 20 48 8b 5c 24 28 48 83 c4 30 e9 74 02 00 00 66 0f 1f 44 00 00 <0f> 01 f8 65 48 89 24 25 80 a0 00 00 65 48 8b 24 25 08 aa 00 00 
[15787.495270] NMI backtrace for cpu 0
[15787.495987] CPU: 0 PID: 1876 Comm: trinity-c189 Tainted: G             L 3.18.0+ #106
[15787.498136] task: ffff880096b4ada0 ti: ffff8802253d0000 task.ti: ffff8802253d0000
[15787.498870] RIP: 0010:[<ffffffff810c9698>]  [<ffffffff810c9698>] do_raw_spin_trylock+0x8/0x50
[15787.499618] RSP: 0018:ffff880244e03d00  EFLAGS: 00000092
[15787.500344] RAX: ffff880096b4ada0 RBX: ffff880240c51578 RCX: ffff880244fcff98
[15787.501064] RDX: 0000000000004a4a RSI: 0000000000000018 RDI: ffff880240c51578
[15787.501780] RBP: ffff880244e03d38 R08: 0000000000000001 R09: 0000000000000000
[15787.502487] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880240c51590
[15787.503190] R13: 0000000000000092 R14: ff[15811.407761] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u16:3:14112]
[15811.408334] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15811.412296] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G             L 3.18.0+ #106
[15811.414324] Workqueue: khelper __call_usermodehelper
[15811.415025] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: ffff880227eac000
[15811.415733] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] __slab_alloc+0x52f/0x58f
[15811.416455] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
[15811.417171] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 00000000000002e0
[15811.417913] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: ffff880244802000
[15811.418645] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 0000000000000000
[15811.419374] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810135bf
[15811.420102] R13: ffff880227eaf878 R14: 0000000100160015 R15: ffffffff8138278d
[15811.420831] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15811.421572] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15811.422317] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 00000000001407e0
[15811.423070] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15811.423828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15811.424583] Stack:
[15811.425327]  000000000000005c ffff880240f8d790 ffff880240f8d790 ffff880240f8dd00
[15811.426099]  0000000180230020 000000010000000f ffffffff8112ee12 0000000000000000
[15811.426872]  ffff8802453d7260 000000020023001f ffff880227eaf968 ffffffff8138278d
[15811.427657] Call Trace:
[15811.428437]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
[15811.429231]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15811.430025]  [<ffffffff811ce860>] ? set_track+0x70/0x140
[15811.430814]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
[15811.431600]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15811.432394]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[15811.433180]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
[15811.433972]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
[15811.434768]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
[15811.435559]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
[15811.436349]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
[15811.437141]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
[15811.437937]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15811.438725]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15811.439519]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
[15811.440307]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[15811.441094]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15811.441871]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15811.442637]  [<ffffffff81077006>] kernel_thread+0x26/0x30
[15811.443385]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
[15811.444121]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
[15811.444838]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15811.445538]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
[15811.446219]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
[15811.446883]  [<ffffffff81098c89>] kthread+0xf9/0x110
[15811.447527]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15811.448159]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15811.448776]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
[15811.449371]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15811.449968] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 22 46 
[15811.451292] sending NMI to other CPUs:
[15811.451901] NMI backtrace for cpu 3
[15811.452459] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G             L 3.18.0+ #106
[15811.454206] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: ffff880180e04000
[15811.454817] RIP: 0010:[<ffffffff810c511a>]  [<ffffffff810c511a>] __lock_acquire.isra.31+0x21a/0x9f0
[15811.455437] RSP: 0018:ffff880180e07d18  EFLAGS: 00000002
[15811.456045] RAX: 0000000000000008 RBX: ffff8801adac4470 RCX: 0000000000000000
[15811.456660] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[15811.457274] RBP: ffff880180e07d88 R08: 0000000000000001 R09: 0000000000000000
[15811.457889] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000014e
[15811.458493] R13: 0000000000000000 R14: ffff880227cc4db8 R15: ffff8801adac4be0
[15811.459092] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15811.459699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15811.460303] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 00000000001407e0
[15811.460907] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15811.461507] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15811.462108] Stack:
[15811.462702]  ffff880180e07d98 ffffffff810c512c 0000000000000102 0000000000000000
[15811.463325]  ffff880180e07d48 ffffffff810abaf5 ffff880180e07dc8 0000000000000000
[15811.463945]  ffff880180e07dd8 0000000000000046 0000000000000000 0000000000000000
[15811.464564] Call Trace:
[15811.465173]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15811.465797]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15811.466421]  [<ffffffff810c5fff>] lock_acquire+0x9f/0x120
[15811.467047]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
[15811.467672]  [<ffffffff817cf0a9>] _raw_spin_lock_irqsave+0x49/0x90
[15811.468300]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
[15811.468924]  [<ffffffff810bcc8d>] remove_wait_queue+0x1d/0x40
[15811.469546]  [<ffffffff8107a95b>] do_wait+0x14b/0x280
[15811.470166]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
[15811.470782]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
[15811.471398]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
[15811.472011] Code: e0 7f 44 09 d0 41 88 47 31 41 0f b6 47 32 83 e0 f0 45 85 c0 0f 95 c2 09 c8 c1 e2 03 09 d0 41 88 47 32 0f b7 55 18 41 0f b7 47 32 <c1> e2 04 83 e0 0f 09 d0 66 41 89 47 32 e8 a4 69 fe ff 4c 8b 4d 
[15811.473409] NMI backtrace for cpu 1
[15811.474061] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G             L 3.18.0+ #106
[15811.476098] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: ffff880153a4c000
[15811.476808] RIP: 0010:[<ffffffff810c63cf>]  [<ffffffff810c63cf>] lock_release+0x1f/0x240
[15811.477535] RSP: 0018:ffff880153a4fe40  EFLAGS: 00000246
[15811.478253] RAX: ffff880096b4c470 RBX: 0000000000000000 RCX: 00000000000003a0
[15811.478982] RDX: ffffffff81086d0c RSI: 0000000000000001 RDI: ffffffff81c50e20
[15811.479707] RBP: ffff880153a4fe48 R08: 0000000000000000 R09: 0000000000000000
[15811.480419] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880094be64c0
[15811.481115] R13: ffff880153a4feb0 R14: 0000000000000000 R15: 0000000000000000
[15811.481803] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15811.482504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15811.483200] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 00000000001407e0
[15811.483890] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15811.484562] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15811.485221] Stack:
[15811.485862]  0000000000000000 ffff880153a4fe88 ffffffff81086d24 ffffffff81086ca5
[15811.486521]  0000000000000d7f 0000000000000d7f 0000000000000000 ffff880096[15835.393872] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u16:3:14112]
[15835.394432] Modules linked in: bridge 8021q garp stp snd_seq_dummy dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15835.398378] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G             L 3.18.0+ #106
[15835.400379] Workqueue: khelper __call_usermodehelper
[15835.401080] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: ffff880227eac000
[15835.401795] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] __slab_alloc+0x52f/0x58f
[15835.402534] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
[15835.403252] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 00000000000002e0
[15835.403995] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: ffff880244802000
[15835.404727] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 0000000000000000
[15835.405456] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810135bf
[15835.406185] R13: ffff880227eaf878 R14: 0000000100160015 R15: ffffffff8138278d
[15835.406916] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15835.407667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15835.408410] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 00000000001407e0
[15835.409165] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 0000000000000000
[15835.409924] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15835.410679] Stack:
[15835.411433]  000000000000005c ffff880240f8d790 ffff880240f8d790 ffff880240f8dd00
[15835.412226]  0000000180230020 000000010000000f ffffffff8112ee12 0000000000000000
[15835.413002]  ffff8802453d7260 000000020023001f ffff880227eaf968 ffffffff8138278d
[15835.413784] Call Trace:
[15835.414563]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
[15835.415358]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15835.416162]  [<ffffffff811ce860>] ? set_track+0x70/0x140
[15835.416952]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
[15835.417745]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
[15835.418533]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
[15835.419328]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
[15835.420114]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
[15835.420904]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
[15835.421701]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
[15835.422491]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
[15835.423282]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
[15835.424077]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15835.424865]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15835.425658]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
[15835.426447]  [<ffffffff81076c37>] do_fork+0xe7/0x490
[15835.427239]  [<ffffffff810c512c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15835.428018]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15835.428776]  [<ffffffff81077006>] kernel_thread+0x26/0x30
[15835.429525]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
[15835.430259]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
[15835.430986]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
[15835.431694]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
[15835.432374]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
[15835.433049]  [<ffffffff81098c89>] kthread+0xf9/0x110
[15835.433694]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
[15835.434328]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15835.434947]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
[15835.435543]  [<ffffffff81098b90>] ? kthread_create_on_node+0x250/0x250
[15835.436148] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 22 46 
[15835.437494] sending NMI to other CPUs:


