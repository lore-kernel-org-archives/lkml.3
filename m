Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLSO5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaLSO5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:57:13 -0500
Date: Fri, 19 Dec 2014 09:55:28 -0500
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
Message-ID: <20141219145528.GC13404@redhat.com>
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
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com>
 <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 08:48:24PM -0800, Linus Torvalds wrote:
 > On Thu, Dec 18, 2014 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > So the only thing that was on that could cause spinlock overhead
 > > was DEBUG_SPINLOCK (and LOCK_STAT, though iirc that's not huge either)
 > 
 > So DEBUG_SPINLOCK does have one big downside if I recall correctly -
 > the debugging spinlocks are very much not fair. So they don't work
 > like the real ticket spinlocks. That might have serious effects on the
 > contention case, with some thread not making any progress due to just
 > the implementation of the debug spinlocks.

Wish DEBUG_SPINLOCK disabled, I see the same behaviour.
Lots of traces spewed, but it seems to run and run (at least so far).

	Dave

[24053.092097] trinity-c206 (26510) used greatest stack depth: 8888 bytes left
[24998.017355] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c205:636]
[24998.017457] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[24998.019523] CPU: 1 PID: 636 Comm: trinity-c205 Not tainted 3.18.0+ #108
[24998.021412] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[24998.022367] RIP: 0010:[<ffffffff810ee9ca>]  [<ffffffff810ee9ca>] generic_exec_single+0xea/0x1b0
[24998.023332] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[24998.024287] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[24998.025245] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[24998.026194] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[24998.027143] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[24998.028144] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[24998.029095] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[24998.030050] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24998.031005] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[24998.031967] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[24998.032930] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24998.033898] Stack:
[24998.034855]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[24998.035843]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[24998.036832]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[24998.037855] Call Trace:
[24998.038837]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[24998.039826]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[24998.040804]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[24998.041779]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[24998.042748]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[24998.043705]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[24998.044647]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[24998.045585]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[24998.046528]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[24998.047510]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[24998.048456]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[24998.049409]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[24998.050361]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[24998.051309]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[24998.052260]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[24998.053209]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[24998.054156]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[24998.055100]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[24998.056044]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[24998.056992]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[24998.057963] Code: 00 2b 01 00 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[24998.059993] sending NMI to other CPUs:
[24998.060963] NMI backtrace for cpu 0
[24998.061989] CPU: 0 PID: 2940 Comm: trinity-c150 Not tainted 3.18.0+ #108
[24998.064073] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[24998.065137] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[24998.066226] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[24998.067310] RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
[24998.068407] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[24998.069491] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[24998.070569] R10: 0000000000000526 R11: 000000000000000f R12: 000016bf99600917
[24998.071642] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[24998.072713] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[24998.073771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24998.074813] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[24998.075855] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[24998.076891] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24998.077903] Stack:
[24998.078886]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[24998.079872]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[24998.080832]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[24998.081769] Call Trace:
[24998.082680]  <IRQ> 

[24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[24998.090435]  <EOI> 

[24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[24998.094605]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[24998.095420] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[24998.097220] NMI backtrace for cpu 3
[24998.098074] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0+ #108
[24998.099812] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[24998.100708] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[24998.101617] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[24998.102529] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[24998.103448] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[24998.104364] RBP: ffff88024471be38 R08: 0000000000000010 R09: 000000000000265a
[24998.105283] R10: 0000000000007d5b R11: 00000000000003ff R12: 0000000000000005
[24998.106201] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[24998.107115] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[24998.108039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24998.108962] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[24998.109894] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[24998.110820] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24998.111747] Stack:
[24998.112668]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[24998.113610]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[24998.114553]  000016bfb0c185fc ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[24998.115501] Call Trace:
[24998.116440]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[24998.117389]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[24998.118309]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[24998.119208]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[24998.120106] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[24998.122074] NMI backtrace for cpu 2
[24998.122981] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.18.0+ #108
[24998.124771] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[24998.125679] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[24998.126593] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[24998.127528] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[24998.128444] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[24998.129357] RBP: ffff88024470fe38 R08: ffff88024e28ecf0 R09: 00000000ffffffff
[24998.130267] R10: 000000000000265c R11: 00000000000003ff R12: 0000000000000005
[24998.131172] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[24998.132071] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[24998.132974] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24998.133876] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[24998.134789] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[24998.135694] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24998.136589] Stack:
[24998.137505]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[24998.138424]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[24998.139340]  000016bfb0c18159 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[24998.140262] Call Trace:
[24998.141176]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[24998.142103]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[24998.143026]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[24998.143948]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[24998.144868] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25026.001132] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c205:636]
[25026.002121] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25026.007365] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25026.009524] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25026.010591] RIP: 0010:[<ffffffff810ee9ce>]  [<ffffffff810ee9ce>] generic_exec_single+0xee/0x1b0
[25026.011710] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25026.012787] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25026.013854] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25026.014902] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25026.015941] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25026.016982] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25026.018019] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25026.019065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25026.020113] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25026.021205] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25026.022263] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25026.023310] Stack:
[25026.024349]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25026.025411]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25026.026472]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25026.027535] Call Trace:
[25026.028585]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25026.029640]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25026.030683]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25026.031747]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25026.032771]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25026.033800]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25026.034826]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25026.035854]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25026.036883]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25026.037896]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25026.038886]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25026.039875]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25026.040865]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25026.041867]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25026.042818]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25026.043763]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25026.044707]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25026.045647]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25026.046587]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25026.047529]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25026.048469] Code: 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[25026.050509] sending NMI to other CPUs:
[25026.051516] NMI backtrace for cpu 0
[25026.052541] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25026.054635] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25026.055696] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25026.056761] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[25026.057822] RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000
[25026.058886] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[25026.059947] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[25026.061009] R10: 0000000000000526 R11: 000000000000000f R12: 000016c61e4e2117
[25026.062073] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[25026.063139] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25026.064215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25026.065271] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25026.066314] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25026.067349] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25026.068359] Stack:
[25026.069339]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[25026.070326]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[25026.071289]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[25026.072225] Call Trace:
[25026.073133]  <IRQ> 

[25026.074028]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25026.074902]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[25026.075767]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25026.076622]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25026.077476]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25026.078328]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25026.079183]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25026.080035]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25026.080885]  <EOI> 

[25026.081728]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25026.082565]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25026.083397]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25026.084226]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25026.085050]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25026.085867] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25026.087667] NMI backtrace for cpu 3
[25026.088525] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25026.090268] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25026.091168] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25026.092081] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25026.092994] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25026.093915] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25026.094834] RBP: ffff88024471be38 R08: ffff88024e2ced08 R09: 00000000ffffffff
[25026.095754] R10: 000000000000265a R11: 00000000000003ff R12: 0000000000000005
[25026.096677] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25026.097598] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25026.098526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25026.099454] CR2: 00007fffcba6fea0 CR3: 0000000001c11000 CR4: 00000000001407e0
[25026.100392] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25026.101324] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25026.102257] Stack:
[25026.103183]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25026.104133]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25026.105083]  000016c63648391d ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25026.106036] Call Trace:
[25026.106984]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25026.107936]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25026.108865]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25026.109771]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25026.110674] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25026.112654] NMI backtrace for cpu 2
[25026.113565] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25026.115375] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25026.116284] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25026.117207] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25026.118123] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25026.119041] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25026.119958] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25026.120875] R10: 0000000000002659 R11: 00000000000003ff R12: 0000000000000005
[25026.121814] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25026.122719] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25026.123625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25026.124533] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25026.125450] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25026.126361] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25026.127262] Stack:
[25026.128157]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25026.129079]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25026.129996]  000016c636483734 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25026.130920] Call Trace:
[25026.131864]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25026.132794]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25026.133725]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25026.134652]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25026.135579] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25037.184648] INFO: rcu_sched detected stalls on CPUs/tasks:
[25037.185608] 	(detected by 0, t=6002 jiffies, g=777861, c=777860, q=0)
[25037.186536] INFO: Stall ended before state dump start
[25053.984908] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c205:636]
[25053.985884] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25053.991028] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25053.993097] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25053.994131] RIP: 0010:[<ffffffff810ee9ca>]  [<ffffffff810ee9ca>] generic_exec_single+0xea/0x1b0
[25053.995202] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25053.996223] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25053.997247] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25053.998270] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25053.999294] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25054.000323] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25054.001349] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25054.002384] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25054.003420] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25054.004455] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25054.005522] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25054.006552] Stack:
[25054.007575]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25054.008619]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25054.009658]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25054.010692] Call Trace:
[25054.011716]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25054.012743]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25054.013763]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25054.014779]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25054.015830]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25054.016846]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25054.017846]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25054.018823]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25054.019798]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25054.020774]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25054.021732]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25054.022671]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25054.023604]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25054.024534]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25054.025495]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25054.026421]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25054.027353]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25054.028281]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25054.029206]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25054.030136]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25054.031054] Code: 00 2b 01 00 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[25054.033040] sending NMI to other CPUs:
[25054.033992] NMI backtrace for cpu 0
[25054.035027] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25054.037117] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25054.038172] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25054.039238] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[25054.040297] RAX: 0000000091ca7f65 RBX: 0000000000513346 RCX: 0000000000000000
[25054.041365] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[25054.042436] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[25054.043514] R10: 0000000000000526 R11: 0000000000aaaaaa R12: 000016cca33c3917
[25054.044572] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[25054.045606] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25054.046645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25054.047685] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25054.048728] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25054.049763] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25054.050774] Stack:
[25054.051757]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[25054.052744]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[25054.053709]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[25054.054649] Call Trace:
[25054.055559]  <IRQ> 

[25054.056455]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25054.057326]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[25054.058194]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25054.059050]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25054.059904]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25054.060759]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25054.061614]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25054.062466]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25054.063317]  <EOI> 

[25054.064159]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25054.064994]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25054.065826]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25054.066656]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25054.067480]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25054.068297] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25054.070095] NMI backtrace for cpu 2
[25054.070949] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25054.072692] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25054.073589] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25054.074498] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25054.075411] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25054.076329] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25054.077248] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25054.078167] R10: 000000000000265b R11: 00000000000003ff R12: 0000000000000005
[25054.079087] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25054.080007] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25054.080934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25054.081856] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25054.082790] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25054.083721] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25054.084651] Stack:
[25054.085578]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25054.086525]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25054.087477]  000016ccba9dadfd ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25054.088429] Call Trace:
[25054.089371]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25054.090324]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25054.091251]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25054.092158]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25054.093059] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25054.095041] NMI backtrace for cpu 3
[25054.095952] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25054.097763] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25054.098676] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25054.099598] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25054.100517] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25054.101441] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25054.102360] RBP: ffff88024471be38 R08: 0000000000000018 R09: 0000000000002655
[25054.103278] R10: 000000000000be78 R11: 00000000000003ff R12: 0000000000000005
[25054.104189] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25054.105118] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25054.106026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25054.106933] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25054.107847] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25054.108756] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25054.109656] Stack:
[25054.110546]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25054.111466]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25054.112383]  000016ccba9dc98b ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25054.113305] Call Trace:
[25054.114222]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25054.115173]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25054.116098]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25054.117022]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25054.117945] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25081.968684] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c205:636]
[25081.969644] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25081.974748] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25081.976852] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25081.977892] RIP: 0010:[<ffffffff810ee9ca>]  [<ffffffff810ee9ca>] generic_exec_single+0xea/0x1b0
[25081.978981] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25081.980030] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25081.981068] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25081.982090] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25081.983107] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25081.984121] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25081.985132] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25081.986155] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25081.987179] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25081.988208] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25081.989271] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25081.990294] Stack:
[25081.991306]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25081.992338]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25081.993369]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25081.994406] Call Trace:
[25081.995430]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25081.996456]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25081.997470]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25081.998481]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25081.999512]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25082.000509]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25082.001510]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25082.002510]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25082.003514]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25082.004498]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25082.005463]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25082.006425]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25082.007386]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25082.008335]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25082.009300]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25082.010222]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25082.011144]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25082.012057]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25082.012971]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25082.013889]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25082.014807] Code: 00 2b 01 00 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[25082.016796] sending NMI to other CPUs:
[25082.017742] NMI backtrace for cpu 0
[25082.018768] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25082.020865] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25082.021929] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25082.022996] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[25082.024057] RAX: 00000000a9afbd0d RBX: 000000000051491e RCX: 0000000000000000
[25082.025125] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[25082.026185] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[25082.027248] R10: 0000000000000526 R11: 0000000000aaaaaa R12: 000016d3282a5117
[25082.028317] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[25082.029383] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25082.030459] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25082.031518] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25082.032563] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25082.033598] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25082.034612] Stack:
[25082.035595]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[25082.036582]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[25082.037546]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[25082.038485] Call Trace:
[25082.039397]  <IRQ> 

[25082.040290]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25082.041164]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[25082.042032]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25082.042890]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25082.043748]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25082.044603]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25082.045460]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25082.046317]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25082.047170]  <EOI> 

[25082.048018]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25082.048856]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25082.049691]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25082.050520]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25082.051347]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25082.052166] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25082.053966] NMI backtrace for cpu 3
[25082.054824] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25082.056568] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25082.057464] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25082.058376] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25082.059292] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25082.060214] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25082.061132] RBP: ffff88024471be38 R08: ffff88024e2ced08 R09: 00000000ffffffff
[25082.062054] R10: 0000000000002655 R11: 00000000000003ff R12: 0000000000000005
[25082.062977] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25082.063899] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25082.064825] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25082.065751] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25082.066685] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25082.067618] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25082.068552] Stack:
[25082.069477]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25082.070426]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25082.071378]  000016d33f8be858 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25082.072334] Call Trace:
[25082.073279]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25082.074233]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25082.075161]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25082.076066]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25082.076968] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25082.078949] NMI backtrace for cpu 2
[25082.079865] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25082.081672] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25082.082586] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25082.083507] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25082.084424] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25082.085345] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25082.086261] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25082.087178] R10: 000000000000265b R11: 00000000000003ff R12: 0000000000000005
[25082.088088] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25082.089016] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25082.089919] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25082.090826] CR2: 00007f274c4061c0 CR3: 0000000001c11000 CR4: 00000000001407e0
[25082.091740] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25082.092652] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25082.093556] Stack:
[25082.094451]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25082.095371]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25082.096293]  000016d33f8bcc84 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25082.097220] Call Trace:
[25082.098141]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25082.099095]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25082.100026]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25082.100956]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25082.101882] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25097.149884] INFO: rcu_sched self-detected stall on CPU
[25097.149885] INFO: rcu_sched self-detected stall on CPU

[25097.149886] 	1: (5973 ticks this GP) idle=6b3/140000000000001/0 softirq=1672732/1672732 
[25097.149897] 	
[25097.149898]  (t=6000 jiffies g=777862 c=777861 q=0)
[25097.149899] Task dump for CPU 0:
[25097.149899] trinity-c150    R
[25097.149900]   running task    
[25097.149908] 13312  2940  29562 0x10000008
[25097.149909]  ffff880197e0c000
[25097.149909]  000000002e7fd874
[25097.149909]  ffff880197e0fb88
[25097.149910]  ffffffff810f1c86

[25097.149910]  ffff8801bf3536b0
[25097.149910]  00007fffa4bfd708
[25097.149911]  ffff880197e0fb98
[25097.149911]  000000002e7fd874

[25097.149911]  ffff880197e0fbb8
[25097.149911]  ffffffff810f1c86
[25097.149912]  ffff880197e0fc08
[25097.149912]  00007fffa4bfd708

[25097.149912] Call Trace:

[25097.149915]  [<ffffffff810f1c86>] ? __module_text_address+0x16/0x80

[25097.149917]  [<ffffffff810f1c86>] ? __module_text_address+0x16/0x80

[25097.149919]  [<ffffffff810f63f6>] ? is_module_text_address+0x16/0x30

[25097.149921]  [<ffffffff810942f8>] ? __kernel_text_address+0x58/0x80

[25097.149923]  [<ffffffff81006a2f>] ? print_context_stack+0x8f/0x100

[25097.149925]  [<ffffffff8100556f>] ? dump_trace+0x16f/0x350

[25097.149926]  [<ffffffff811e2966>] ? link_path_walk+0x266/0x850

[25097.149927]  [<ffffffff811e5dff>] ? getname_flags+0x4f/0x1a0

[25097.149929]  [<ffffffff811e5d86>] ? final_putname+0x26/0x50

[25097.149930]  [<ffffffff810133af>] ? save_stack_trace+0x2f/0x50

[25097.149941]  [<ffffffff811bc6e0>] ? set_track+0x70/0x140

[25097.149943]  [<ffffffff8178e291>] ? free_debug_processing+0x1de/0x232

[25097.149944]  [<ffffffff8178e407>] ? __slab_free+0x122/0x2e9

[25097.149946]  [<ffffffff81352ef4>] ? timerqueue_del+0x24/0x70

[25097.149948]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0

[25097.149950]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0

[25097.149951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0

[25097.149953]  [<ffffffff812c8d6d>] ? SyS_msgget+0x4d/0x70

[25097.149955]  [<ffffffff817994c4>] ? tracesys_phase2+0xd4/0xd9
[25097.149955] Task dump for CPU 1:
[25097.149956] trinity-c205    R
[25097.149956]   running task    
[25097.149958] 13312   636  29562 0x10000008
[25097.149959]  ffff8800962fed60
[25097.149959]  0000000077930768
[25097.149959]  ffff88024e243d78
[25097.149959]  ffffffff810a3932

[25097.149960]  0000000000000001
[25097.149960]  ffffffff81c4bf80
[25097.149960]  ffff88024e243d98
[25097.149960]  ffffffff810a76dd

[25097.149961]  ffff88024e24c440
[25097.149961]  0000000000000002
[25097.149961]  ffff88024e243dc8
[25097.149961]  ffffffff810ce920

[25097.149962] Call Trace:
[25097.149962]  <IRQ> 

[25097.149964]  [<ffffffff810a3932>] sched_show_task+0xd2/0x140

[25097.149965]  [<ffffffff810a76dd>] dump_cpu_task+0x3d/0x50

[25097.149969]  [<ffffffff810ce920>] rcu_dump_cpu_stacks+0x90/0xd0

[25097.149970]  [<ffffffff810d4c33>] rcu_check_callbacks+0x4c3/0x730

[25097.149973]  [<ffffffff81120b4c>] ? acct_account_cputime+0x1c/0x20

[25097.149974]  [<ffffffff810a800e>] ? account_system_time+0x8e/0x190

[25097.149976]  [<ffffffff810da34b>] update_process_times+0x4b/0x80

[25097.149977]  [<ffffffff810e9cff>] tick_sched_timer+0x4f/0x160

[25097.149978]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0

[25097.149979]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20

[25097.149980]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260

[25097.149982]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70

[25097.149983]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60

[25097.149985]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25097.149985]  <EOI> 

[25097.149987]  [<ffffffff81799e0d>] ? retint_restore_args+0xe/0xe

[25097.149989]  [<ffffffff810ee9ce>] ? generic_exec_single+0xee/0x1b0

[25097.149990]  [<ffffffff810eea09>] ? generic_exec_single+0x129/0x1b0

[25097.149991]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0

[25097.149992]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0

[25097.149993]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60

[25097.149994]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60

[25097.149995]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0

[25097.149998]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280

[25097.149999]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60

[25097.150000]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320

[25097.150001]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0

[25097.150003]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50

[25097.150004]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900

[25097.150006]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50

[25097.150007]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160

[25097.150009]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190

[25097.150011]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0

[25097.150012]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122

[25097.150013]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0

[25097.150015]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860

[25097.150016]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0

[25097.150018]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9

[25097.206563] 	0: (1 GPs behind) idle=845/140000000000001/0 softirq=1616166/1616167 
[25097.207170] 	 (t=6000 jiffies g=777862 c=777861 q=0)
[25097.207778] Task dump for CPU 0:
[25097.208382] trinity-c150    R  running task    13312  2940  29562 0x10000008
[25097.209002]  ffff8801bf3536b0 000000002e7fd874 ffff88024e203d78 ffffffff810a3932
[25097.209635]  0000000000000000 ffffffff81c4bf80 ffff88024e203d98 ffffffff810a76dd
[25097.210304]  ffff88024e20c440 0000000000000001 ffff88024e203dc8 ffffffff810ce920
[25097.210965] Call Trace:
[25097.211614]  <IRQ>  [<ffffffff810a3932>] sched_show_task+0xd2/0x140
[25097.212284]  [<ffffffff810a76dd>] dump_cpu_task+0x3d/0x50
[25097.212955]  [<ffffffff810ce920>] rcu_dump_cpu_stacks+0x90/0xd0
[25097.213628]  [<ffffffff810d4c33>] rcu_check_callbacks+0x4c3/0x730
[25097.214300]  [<ffffffff81120b4c>] ? acct_account_cputime+0x1c/0x20
[25097.214973]  [<ffffffff810a800e>] ? account_system_time+0x8e/0x190
[25097.215645]  [<ffffffff810da34b>] update_process_times+0x4b/0x80
[25097.216317]  [<ffffffff810e9cff>] tick_sched_timer+0x4f/0x160
[25097.216996]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25097.217676]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25097.218359]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25097.219040]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25097.219719]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25097.220415]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25097.221091]  <EOI>  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25097.221778]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25097.222454]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25097.223125]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25097.223793]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25097.224461] Task dump for CPU 1:
[25097.225124] trinity-c205    R  running task    13312   636  29562 0x10000008
[25097.225806]  00000000458261c0 ffff880066bae1b8 ffff880066bae1f0 ffff88021cbef200
[25097.226496]  ffff88024267bd20 0000000000000001 ffff88024267bd78 ffffffff811927cf
[25097.227190]  0000000000000000 0000000000000000 ffff880066bae1b8 0000000000000000
[25097.227889] Call Trace:
[25097.228578]  [<ffffffff811927cf>] ? unmap_mapping_range+0x12f/0x190
[25097.229279]  [<ffffffff8118193d>] ? shmem_fallocate+0x38d/0x4c0
[25097.230004]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25097.230708]  [<ffffffff811d38af>] ? do_fallocate+0x12f/0x1d0
[25097.231409]  [<ffffffff811a6995>] ? SyS_madvise+0x385/0x860
[25097.232106]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25097.232810]  [<ffffffff817994c4>] ? tracesys_phase2+0xd4/0xd9
[25121.945509] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c205:636]
[25121.946236] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25121.950189] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25121.951854] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25121.952705] RIP: 0010:[<ffffffff810ee9ce>]  [<ffffffff810ee9ce>] generic_exec_single+0xee/0x1b0
[25121.953566] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25121.954428] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25121.955296] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25121.956199] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25121.957065] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25121.957937] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25121.958811] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25121.959692] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25121.960571] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25121.961462] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25121.962346] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25121.963231] Stack:
[25121.964105]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25121.965010]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25121.965945]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25121.966838] Call Trace:
[25121.967723]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25121.968615]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25121.969494]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25121.970371]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25121.971239]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25121.972107]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25121.972968]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25121.973829]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25121.974690]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25121.975592]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25121.976454]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25121.977319]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25121.978178]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25121.979044]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25121.979905]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25121.980768]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25121.981636]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25121.982501]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25121.983362]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25121.984228]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25121.985086] Code: 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[25121.986993] sending NMI to other CPUs:
[25121.987891] NMI backtrace for cpu 0
[25121.988871] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25121.990863] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25121.991871] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25121.992886] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[25121.993898] RAX: 00000000cbd1340c RBX: 000000000051684a RCX: 0000000000000000
[25121.994911] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[25121.995923] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[25121.996942] R10: 0000000000000526 R11: 0000000000aaaaaa R12: 000016dc7859e117
[25121.997961] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[25121.998975] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25122.000003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25122.001032] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25122.002066] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25122.003094] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25122.004099] Stack:
[25122.005070]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[25122.006050]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[25122.007005]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[25122.007936] Call Trace:
[25122.008841]  <IRQ> 

[25122.009729]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25122.010594]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[25122.011453]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25122.012301]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25122.013148]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25122.013996]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25122.014843]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25122.015690]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25122.016534]  <EOI> 

[25122.017374]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25122.018207]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25122.019037]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25122.019859]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25122.020679]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25122.021490] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25122.023285] NMI backtrace for cpu 2
[25122.024138] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25122.025877] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25122.026772] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25122.027680] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25122.028590] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25122.029511] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25122.030427] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25122.031345] R10: 000000000000265b R11: 00000000000003ff R12: 0000000000000005
[25122.032268] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25122.033189] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25122.034115] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25122.035042] CR2: 00007f6b1f71a000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25122.035977] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25122.036911] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25122.037844] Stack:
[25122.038768]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25122.039719]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25122.040671]  000016dc8fbb58a7 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25122.041629] Call Trace:
[25122.042576]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25122.043530]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25122.044462]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25122.045370]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25122.046275] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25122.048261] NMI backtrace for cpu 3
[25122.049177] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25122.050992] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25122.051911] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25122.052836] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25122.053757] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25122.054682] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25122.055628] RBP: ffff88024471be38 R08: ffff88024e2ced08 R09: 00000000ffffffff
[25122.056550] R10: 0000000000002655 R11: 00000000000003ff R12: 0000000000000005
[25122.057466] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25122.058374] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25122.059282] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25122.060191] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25122.061107] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25122.062020] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25122.062925] Stack:
[25122.063822]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25122.064744]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25122.065690]  000016dc8fbb74c1 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25122.066617] Call Trace:
[25122.067536]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25122.068470]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25122.069400]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25122.070329]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25122.071258] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25149.929286] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c205:636]
[25149.930256] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25149.935393] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25149.937508] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25149.938555] RIP: 0010:[<ffffffff810ee9ce>]  [<ffffffff810ee9ce>] generic_exec_single+0xee/0x1b0
[25149.939652] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25149.940706] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25149.941751] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25149.942780] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25149.943803] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25149.944822] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25149.945839] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25149.946862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25149.947891] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25149.948928] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25149.949997] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25149.951027] Stack:
[25149.952045]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25149.953082]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25149.954119]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25149.955159] Call Trace:
[25149.956184]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25149.957219]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25149.958239]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25149.959258]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25149.960299]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25149.961305]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25149.962310]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25149.963313]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25149.964320]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25149.965312]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25149.966281]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25149.967249]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25149.968212]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25149.969163]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25149.970131]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25149.971056]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25149.971977]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25149.972895]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25149.973812]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25149.974735]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25149.975654] Code: 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[25149.977642] sending NMI to other CPUs:
[25149.978587] NMI backtrace for cpu 0
[25149.979615] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25149.981704] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25149.982766] RIP: 0010:[<ffffffff810cf1db>]  [<ffffffff810cf1db>] invoke_rcu_core+0x2b/0x50
[25149.983834] RSP: 0018:ffff88024e203db8  EFLAGS: 00000093
[25149.984894] RAX: ffffffff81cfe330 RBX: 0000000000000000 RCX: 00000000000bde85
[25149.985959] RDX: 00000000000bde86 RSI: ffff88024e20c440 RDI: ffffffff81c4bf80
[25149.987021] RBP: ffff88024e203dc8 R08: 0000000000000000 R09: 000000000000000f
[25149.988084] R10: 0000000000000526 R11: 0000000000aaaaaa R12: ffffffff81c4bf80
[25149.989155] R13: ffffffff81c4bf80 R14: 0000000000000000 R15: 000016eacc784674
[25149.990227] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25149.991310] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25149.992374] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25149.993420] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25149.994462] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25149.995477] Stack:
[25149.996463]  ffff8801bf3536b0 ffff88024e20c440 ffff88024e203e38 ffffffff810d48f3
[25149.997456]  ffff88024e203de8 ffffffff81120b4c ffff88024e203e28 ffffffff810a800e
[25149.998421]  ffff88024e203e08 ffffffff81cfe338 ffff88024e203e38 ffff8801bf3536b0
[25149.999364] Call Trace:
[25150.000280]  <IRQ> 

[25150.001179]  [<ffffffff810d48f3>] rcu_check_callbacks+0x183/0x730
[25150.002063]  [<ffffffff81120b4c>] ? acct_account_cputime+0x1c/0x20
[25150.002939]  [<ffffffff810a800e>] ? account_system_time+0x8e/0x190
[25150.003805]  [<ffffffff810da34b>] update_process_times+0x4b/0x80
[25150.004669]  [<ffffffff810e9cff>] tick_sched_timer+0x4f/0x160
[25150.005530]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25150.006391]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25150.007248]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25150.008106]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25150.008958]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25150.009803]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25150.010645]  <EOI> 

[25150.011487]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25150.012328]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25150.013162]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25150.013991]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25150.014809]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25150.015627] Code: 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 65 8b 1c 25 2c a0 00 00 3b 1d e8 02 c3 00 73 24 89 db 48 8b 05 31 3e 74 00 48 0f a3 18 <19> db 85 db 74 0a bf 09 00 00 00 e8 b5 be fa ff 48 83 c4 08 5b 
[25150.017421] NMI backtrace for cpu 2
[25150.018283] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25150.020063] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25150.020972] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25150.021897] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25150.022819] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25150.023745] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25150.024669] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25150.025595] R10: 000000000000265b R11: 00000000000003ff R12: 0000000000000005
[25150.026523] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25150.027445] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25150.028378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25150.029311] CR2: 00007f6b1f71a000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25150.030250] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25150.031190] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25150.032125] Stack:
[25150.033056]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25150.034012]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25150.034966]  000016e314a978e8 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25150.035903] Call Trace:
[25150.036807]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25150.037724]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25150.038637]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25150.039548]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25150.040438] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25150.042345] NMI backtrace for cpu 3
[25150.043231] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25150.045019] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25150.045926] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25150.046843] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25150.047755] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25150.048670] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25150.049598] RBP: ffff88024471be38 R08: ffff88024e2ced08 R09: 00000000ffffffff
[25150.050500] R10: 0000000000002655 R11: 00000000000003ff R12: 0000000000000005
[25150.051406] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25150.052313] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25150.053216] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25150.054114] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25150.055021] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25150.055929] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25150.056829] Stack:
[25150.057727]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25150.058649]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25150.059600]  000016e314a99619 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25150.060530] Call Trace:
[25150.061450]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25150.062380]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25150.063303]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25150.064231]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25150.065157] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25177.913063] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c205:636]
[25177.914027] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25177.919143] CPU: 1 PID: 636 Comm: trinity-c205 Tainted: G             L 3.18.0+ #108
[25177.921249] task: ffff8800962fed60 ti: ffff880242678000 task.ti: ffff880242678000
[25177.922289] RIP: 0010:[<ffffffff810ee9ca>]  [<ffffffff810ee9ca>] generic_exec_single+0xea/0x1b0
[25177.923382] RSP: 0018:ffff88024267b9c8  EFLAGS: 00000202
[25177.924433] RAX: 0000000000000008 RBX: ffffffff81799e0d RCX: 0000000000000038
[25177.925476] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25177.926504] RBP: ffff88024267ba28 R08: ffff8802444f43f0 R09: 0000000000000000
[25177.927525] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024267b938
[25177.928542] R13: 0000000000406040 R14: ffff880242678000 R15: ffff8800962fed60
[25177.929556] FS:  00007ff08e78d740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25177.930580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25177.931606] CR2: 0000000000000000 CR3: 0000000228031000 CR4: 00000000001407e0
[25177.932638] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25177.933707] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25177.934735] Stack:
[25177.935750]  ffffffff8124055d ffff8801b4eff080 ffffffff8124055d 0000000000000000
[25177.936786]  ffffffff81047bb0 ffff88024267bad8 0000000000000003 0000000077930768
[25177.937819]  ffff88024267ba48 00000000ffffffff 0000000000000000 ffffffff81047bb0
[25177.938856] Call Trace:
[25177.939882]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25177.940911]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25177.941928]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25177.942941]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25177.943980]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25177.944982]  [<ffffffff81173f62>] ? release_pages+0x1c2/0x280
[25177.945985]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25177.946988]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25177.947993]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25177.948984]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25177.949951]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25177.950920]  [<ffffffff8116d377>] ? __free_pages+0x37/0x50
[25177.951886]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25177.952837]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25177.953805]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25177.954730]  [<ffffffff8178df51>] ? cmpxchg_double_slab.isra.49+0xd8/0x122
[25177.955653]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25177.956573]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25177.957491]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25177.958414]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25177.959332] Code: 00 2b 01 00 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[25177.961321] sending NMI to other CPUs:
[25177.962268] NMI backtrace for cpu 0
[25177.963295] CPU: 0 PID: 2940 Comm: trinity-c150 Tainted: G             L 3.18.0+ #108
[25177.965391] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
[25177.966456] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25177.967525] RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
[25177.968586] RAX: 00000000fb9d303f RBX: 00000000005193fc RCX: 0000000000000000
[25177.969651] RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
[25177.970712] RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
[25177.971777] R10: 0000000000000526 R11: 0000000000aaaaaa R12: 000016e982361117
[25177.972846] R13: 0000000000000000 R14: ffff88024e20c700 R15: 000016eacc784674
[25177.973915] FS:  00007ff08e78d740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25177.974998] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25177.976058] CR2: 0000000000000001 CR3: 0000000229d22000 CR4: 00000000001407f0
[25177.977103] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25177.978139] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25177.979151] Stack:
[25177.980134]  ffff88024e203e68 ffffffff810e0d3e ffff88024e20ca80 ffff88024e20ca80
[25177.981123]  ffff880197e0fe38 ffff88024e20c6c0 ffff88024e203e98 ffffffff810e9cd3
[25177.982089]  ffff88024e203f28 ffff88024e20ca80 ffff88024e203f28 ffff88024e20c6c0
[25177.983029] Call Trace:
[25177.983943]  <IRQ> 

[25177.984839]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25177.985714]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[25177.986581]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[25177.987439]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[25177.988296]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[25177.989149]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[25177.990007]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[25177.990862]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[25177.991714]  <EOI> 

[25177.992558]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[25177.993396]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[25177.994233]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[25177.995063]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
[25177.995891]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25177.996712] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25177.998518] NMI backtrace for cpu 2
[25177.999377] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25178.001121] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25178.002019] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25178.002932] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25178.003849] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25178.004771] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25178.005688] RBP: ffff88024470fe38 R08: ffff88024e28ed08 R09: 00000000ffffffff
[25178.006609] R10: 000000000000265b R11: 00000000000003ff R12: 0000000000000005
[25178.007532] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25178.008453] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25178.009379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25178.010307] CR2: 00007f6b1f71a000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25178.011246] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25178.012181] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25178.013112] Stack:
[25178.014036]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25178.014985]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25178.015936]  000016e99997935a ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25178.016893] Call Trace:
[25178.017836]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25178.018791]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25178.019719]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25178.020625]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25178.021526] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25178.023504] NMI backtrace for cpu 3
[25178.024417] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25178.026229] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25178.027145] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25178.028067] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25178.028983] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25178.029906] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25178.030826] RBP: ffff88024471be38 R08: ffff88024e2ced08 R09: 00000000ffffffff
[25178.031744] R10: 0000000000002656 R11: 00000000000003ff R12: 0000000000000005
[25178.032657] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25178.033586] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25178.034496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25178.035401] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25178.036319] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25178.037229] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25178.038130] Stack:
[25178.039023]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25178.039948]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25178.040867]  000016e99997b046 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25178.041793] Call Trace:
[25178.042713]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25178.043663]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25178.044589]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25178.045515]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25178.046441] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25183.090076] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 88.570 msecs
[25183.090087] sched: RT throttling activated
[25205.896861] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 21s! [trinity-c65:8051]
[25205.897959] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25205.904284] CPU: 1 PID: 8051 Comm: trinity-c65 Tainted: G             L 3.18.0+ #108
[25205.906737] task: ffff8800a1b98000 ti: ffff880071a70000 task.ti: ffff880071a70000
[25205.907986] RIP: 0010:[<ffffffff8178ecca>]  [<ffffffff8178ecca>] __slab_alloc+0x4e5/0x53b
[25205.909296] RSP: 0018:ffff880071a739f8  EFLAGS: 00000246
[25205.910532] RAX: 0000000000000001 RBX: ffff88022f966c40 RCX: 0000000180240022
[25205.911789] RDX: 0000000000000024 RSI: ffffea0008be5800 RDI: ffff880245827cc0
[25205.913018] RBP: ffff880071a73ac8 R08: ffff88022f965138 R09: 0000000000000000
[25205.914222] R10: 0000000000000092 R11: 0000000000000000 R12: ffffffff810133af
[25205.915459] R13: ffff880071a73978 R14: 0000000100240021 R15: ffffffff8134f019
[25205.916728] FS:  00007f2805635740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25205.917955] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25205.919158] CR2: 0000000001a86a10 CR3: 0000000097832000 CR4: 00000000001407e0
[25205.920348] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25205.921514] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25205.922678] Stack:
[25205.923828]  ffff880071a73a68 ffffffff811b7057 ffff8800a1b98000 ffff8800a1b98000
[25205.925006]  0000000000000000 ffff88022f9669f0 0000000200000000 ffffffff8134f019
[25205.926179]  ffffffff00000000 0000000000000246 0000000000000000 0000000000000000
[25205.927394] Call Trace:
[25205.928579]  [<ffffffff811b7057>] ? alloc_pages_vma+0x97/0x160
[25205.929762]  [<ffffffff8134f019>] ? __radix_tree_preload+0x49/0xc0
[25205.930972]  [<ffffffff8117ccde>] ? shmem_alloc_page+0x6e/0xc0
[25205.932185]  [<ffffffff8134fd05>] ? __radix_tree_create+0x85/0x220
[25205.933398]  [<ffffffff8134f019>] ? __radix_tree_preload+0x49/0xc0
[25205.934603]  [<ffffffff811c012b>] kmem_cache_alloc+0x1bb/0x1e0
[25205.935825]  [<ffffffff8134f019>] __radix_tree_preload+0x49/0xc0
[25205.937011]  [<ffffffff8134f101>] radix_tree_maybe_preload+0x21/0x30
[25205.938175]  [<ffffffff8117fa46>] shmem_getpage_gfp+0x466/0x810
[25205.939323]  [<ffffffff8109bd1a>] ? finish_task_switch+0x4a/0x100
[25205.940453]  [<ffffffff8117fe2f>] shmem_write_begin+0x3f/0x60
[25205.941549]  [<ffffffff811652e4>] generic_perform_write+0xd4/0x1f0
[25205.942627]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25205.943694]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25205.944754]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25205.945813]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.946885]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25205.948034]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25205.949150]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.950297]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.951463]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25205.952586]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25205.953678]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25205.954747]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25205.955854]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25205.956941] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 07 b4 9a ff 4c 89 e0 eb 0f e8 fd b4 9a ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 75 c8 65 48 33 34 25 28 00 00 00 74 32 e8 ff 79 
[25205.959247] sending NMI to other CPUs:
[25205.960438] NMI backtrace for cpu 2
[25205.961454] CPU: 2 PID: 7491 Comm: trinity-c14 Tainted: G             L 3.18.0+ #108
[25205.963519] task: ffff88022b98a0d0 ti: ffff880096408000 task.ti: ffff880096408000
[25205.964574] RIP: 0010:[<ffffffff811741ea>]  [<ffffffff811741ea>] __lru_cache_add+0x4a/0x90
[25205.965645] RSP: 0018:ffff88009640bb38  EFLAGS: 00000293
[25205.966690] RAX: 000000000000000c RBX: ffff88024e28e0c0 RCX: 000000000001602a
[25205.967724] RDX: 000000000000000d RSI: 0000000000000018 RDI: ffffea00042410c0
[25205.968745] RBP: ffff88009640bb48 R08: ffff8801020dae90 R09: 0000000000000000
[25205.969761] R10: 0000000000000001 R11: 0000000000000000 R12: ffffea00042410c0
[25205.970773] R13: 0000000000000000 R14: ffff880096339f18 R15: 0000000000000000
[25205.971763] FS:  00007f2805635740(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25205.972737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25205.973689] CR2: 0000003370219050 CR3: 000000009ab9e000 CR4: 00000000001407e0
[25205.974628] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25205.975543] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25205.976440] Stack:
[25205.977315]  0000000000000003 0000000000000000 ffff88009640bb58 ffffffff81174919
[25205.978198]  ffff88009640bc18 ffffffff8117fa80 ffff88009640bb98 ffffffff8109bdb0
[25205.979071]  ffff8802292c8980 ffff88009640bc80 0000000000000000 00000000000000d0
[25205.979939] Call Trace:
[25205.980791]  [<ffffffff81174919>] lru_cache_add_anon+0x19/0x20
[25205.981659]  [<ffffffff8117fa80>] shmem_getpage_gfp+0x4a0/0x810
[25205.982526]  [<ffffffff8109bdb0>] ? finish_task_switch+0xe0/0x100
[25205.983385]  [<ffffffff8117fe2f>] shmem_write_begin+0x3f/0x60
[25205.984245]  [<ffffffff811652e4>] generic_perform_write+0xd4/0x1f0
[25205.985098]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25205.985946]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25205.986787]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25205.987629]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.988479]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25205.989323]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25205.990156]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.990994]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25205.991822]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25205.992644]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25205.993461]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25205.994277]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25205.995089]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25205.995900] Code: 48 03 1c 25 68 bd 00 00 48 8b 07 f6 c4 80 75 47 41 8b 44 24 1c 85 c0 7e 4c f0 41 ff 44 24 1c 48 8b 03 83 f8 0e 74 1a 48 8d 50 01 <48> 89 13 4c 89 64 c3 10 5b 65 ff 0c 25 60 a8 00 00 41 5c 5d c3 
[25205.997698] NMI backtrace for cpu 3
[25205.998563] CPU: 3 PID: 10185 Comm: trinity-c162 Tainted: G             L 3.18.0+ #108
[25206.000332] task: ffff880197ea2bc0 ti: ffff8801c6410000 task.ti: ffff8801c6410000
[25206.001236] RIP: 0010:[<ffffffff810ee9ce>]  [<ffffffff810ee9ce>] generic_exec_single+0xee/0x1b0
[25206.002161] RSP: 0018:ffff8801c64139c8  EFLAGS: 00000202
[25206.003077] RAX: 0000000000000008 RBX: ffff8801c64139e0 RCX: 0000000000000038
[25206.004003] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[25206.004926] RBP: ffff8801c6413a28 R08: ffff8802444f47e0 R09: 0000000000000000
[25206.005848] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[25206.006769] R13: 0000000000000001 R14: ffff880229f27a00 R15: 0000000000000003
[25206.007683] FS:  00007f2805635740(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25206.008612] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25206.009539] CR2: 00007f28048e2220 CR3: 000000021ca6c000 CR4: 00000000001407e0
[25206.010484] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25206.011426] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25206.012367] Stack:
[25206.013300]  ffffffff8124055d ffff8801e640ddc0 ffffffff8124055d 0000000000000000
[25206.014263]  ffffffff81047bb0 ffff8801c6413ad8 0000000000000003 00000000e731055f
[25206.015228]  ffff8801c6413a48 00000000ffffffff 0000000000000001 ffffffff81047bb0
[25206.016172] Call Trace:
[25206.017090]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25206.018026]  [<ffffffff8124055d>] ? proc_alloc_inode+0x1d/0xb0
[25206.018958]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25206.019879]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25206.020766]  [<ffffffff810eeb30>] smp_call_function_single+0x70/0xd0
[25206.021637]  [<ffffffff81047bb0>] ? do_flush_tlb_all+0x60/0x60
[25206.022498]  [<ffffffff810ef229>] smp_call_function_many+0x2b9/0x320
[25206.023356]  [<ffffffff81184681>] ? zone_statistics+0x81/0xa0
[25206.024210]  [<ffffffff81047ed0>] flush_tlb_mm_range+0x90/0x1b0
[25206.025067]  [<ffffffff81190d62>] tlb_flush_mmu_tlbonly+0x42/0x50
[25206.025914]  [<ffffffff811922c8>] unmap_single_vma+0x6d8/0x900
[25206.026757]  [<ffffffff811925ec>] zap_page_range_single+0xfc/0x160
[25206.027601]  [<ffffffff811927cf>] unmap_mapping_range+0x12f/0x190
[25206.028439]  [<ffffffff8118193d>] shmem_fallocate+0x38d/0x4c0
[25206.029270]  [<ffffffff811d38af>] do_fallocate+0x12f/0x1d0
[25206.030089]  [<ffffffff811a6995>] SyS_madvise+0x385/0x860
[25206.030910]  [<ffffffff811c029e>] ? kmem_cache_free+0x14e/0x1e0
[25206.031733]  [<ffffffff811e6029>] ? putname+0x29/0x40
[25206.032546]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25206.033361]  [<ffffffff817994c4>] tracesys_phase2+0xd4/0xd9
[25206.034170] Code: 48 89 de 48 03 14 c5 e0 bf cf 81 48 89 df e8 5a eb 26 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[25206.035960] NMI backtrace for cpu 0
[25206.036822] CPU: 0 PID: 9587 Comm: trinity-c129 Tainted: G             L 3.18.0+ #108
[25206.038638] task: ffff88009a8695e0 ti: ffff880039f48000 task.ti: ffff880039f48000
[25206.039565] RIP: 0033:[<000000336ee891e5>]  [<000000336ee891e5>] 0x336ee891e5
[25206.040510] RSP: 002b:00007fffdd789658  EFLAGS: 00000202
[25206.041437] RAX: 0000000001b33250 RBX: 0000000001b33240 RCX: 000000000202fe00
[25206.042378] RDX: 0000000002533240 RSI: 0000000000000054 RDI: 0000000001b33250
[25206.043317] RBP: 0000000000a00010 R08: 0000000001b33240 R09: 000000000000002e
[25206.044255] R10: 0000000000003666 R11: 0000000000000246 R12: 0000000002533250
[25206.045186] R13: 0000000000020db0 R14: 0000000000000000 R15: 0000000000000000
[25206.046117] FS:  00007f2805635740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25206.047047] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25206.047954] CR2: 00000000019fcad0 CR3: 000000009edfa000 CR4: 00000000001407f0
[25206.048866] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25206.049779] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600

[25206.051604] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 91.159 msecs
[25233.880621] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c251:17822]
[25233.881750] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25233.887204] CPU: 1 PID: 17822 Comm: trinity-c251 Tainted: G             L 3.18.0+ #108
[25233.889315] task: ffff8801c65ec1a0 ti: ffff88009b7b0000 task.ti: ffff88009b7b0000
[25233.890406] RIP: 0010:[<ffffffff81356ec5>]  [<ffffffff81356ec5>] copy_user_enhanced_fast_string+0x5/0x10
[25233.891548] RSP: 0018:ffff88009b7b3be0  EFLAGS: 00010206
[25233.892666] RAX: 00007f95d93d2239 RBX: ffffffff8117faa1 RCX: 00000000000000a0
[25233.893801] RDX: 0000000000001000 RSI: 00007f95d93d3199 RDI: ffff88019049ef60
[25233.894943] RBP: ffff88009b7b3c28 R08: ffff88022f8d1668 R09: 0000000000000000
[25233.896102] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[25233.897252] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000003
[25233.898395] FS:  00007f95dc296740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25233.899559] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25233.900733] CR2: 00007f95da9e0bbe CR3: 0000000095a94000 CR4: 00000000001407e0
[25233.901878] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25233.903009] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25233.904151] Stack:
[25233.905253]  ffffffff8118e606 ffff88009b7b3bf8 000000001bb22000 0000000000001000
[25233.906364]  000000001bb22000 0000000000001000 ffff88009b7b3d60 0000000000000000
[25233.907478]  ffff8800a2518d28 ffff88009b7b3cc8 ffffffff81165307 ffff88009b7b3c88
[25233.908613] Call Trace:
[25233.909759]  [<ffffffff8118e606>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[25233.910938]  [<ffffffff81165307>] generic_perform_write+0xf7/0x1f0
[25233.912164]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25233.913376]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25233.914574]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25233.915730]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25233.916890]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25233.918061]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25233.919202]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25233.920376]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25233.921584]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25233.922742]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25233.923883]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25233.925034]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25233.926189]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25233.927320] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[25233.929775] sending NMI to other CPUs:
[25233.930989] NMI backtrace for cpu 0
[25233.932037] CPU: 0 PID: 17755 Comm: trinity-c184 Tainted: G             L 3.18.0+ #108
[25233.934172] task: ffff88022d25cc90 ti: ffff880229f78000 task.ti: ffff880229f78000
[25233.935239] RIP: 0010:[<ffffffff81593482>]  [<ffffffff81593482>] usb_unanchor_urb+0x12/0x60
[25233.936302] RSP: 0018:ffff88024e203d50  EFLAGS: 00000082
[25233.937352] RAX: 0000000000000000 RBX: ffff880242a2ecb0 RCX: 0000000000000000
[25233.938412] RDX: 000000000000000e RSI: 0000000000000046 RDI: ffff880242a2ecb0
[25233.939464] RBP: ffff88024e203d68 R08: ffffffff81f5dea8 R09: 00000000000fffe2
[25233.940527] R10: fffffffff8000000 R11: 0000000000000004 R12: ffff88009f014f38
[25233.941592] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880242080000
[25233.942660] FS:  00007f95dc296740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25233.943738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25233.944808] CR2: 0000003370219050 CR3: 000000022e902000 CR4: 00000000001407f0
[25233.945886] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25233.946955] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25233.948024] Stack:
[25233.949088]  ffff88009f014f38 0000000000000000 0000000000000000 ffff88024e203d98
[25233.950171]  ffffffff8158fc9c ffff880241d1d6c0 ffff880242a2ecb0 ffff8802416a4558
[25233.951243]  ffff880241d1d6c0 ffff88024e203dc8 ffffffff8158fec0 ffff88024e203dc8
[25233.952305] Call Trace:
[25233.953331]  <IRQ> 

[25233.954339]  [<ffffffff8158fc9c>] __usb_hcd_giveback_urb+0x5c/0x120
[25233.955323]  [<ffffffff8158fec0>] usb_hcd_giveback_urb+0x40/0xf0
[25233.956290]  [<ffffffff815d276f>] xhci_irq+0xccf/0x1bc0
[25233.957234]  [<ffffffff815d3671>] xhci_msi_irq+0x11/0x20
[25233.958161]  [<ffffffff810c4d2e>] handle_irq_event_percpu+0x3e/0x1c0
[25233.959072]  [<ffffffff810c4ef2>] handle_irq_event+0x42/0x70
[25233.959958]  [<ffffffff810c801f>] handle_edge_irq+0x7f/0x150
[25233.960829]  [<ffffffff81005371>] handle_irq+0xb1/0x140
[25233.961691]  [<ffffffff8179bbb3>] do_IRQ+0x53/0x100
[25233.962544]  [<ffffffff81799daf>] common_interrupt+0x6f/0x6f
[25233.963393]  <EOI> 

[25233.964240]  [<ffffffff81165a08>] ? unlock_page+0x18/0x90
[25233.965088]  [<ffffffff81180d42>] shmem_undo_range+0x1b2/0x710
[25233.965941]  [<ffffffff811812b8>] shmem_truncate_range+0x18/0x40
[25233.966786]  [<ffffffff81181520>] shmem_setattr+0x110/0x1a0
[25233.967622]  [<ffffffff811f3361>] notify_change+0x241/0x390
[25233.968453]  [<ffffffff811d3323>] do_truncate+0x73/0xc0
[25233.969279]  [<ffffffff811d36cc>] do_sys_ftruncate.constprop.14+0x10c/0x160
[25233.970113]  [<ffffffff8135862e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[25233.970943]  [<ffffffff811d375e>] SyS_ftruncate+0xe/0x10
[25233.971761]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25233.972581] Code: 00 49 8d 7c 24 10 31 c9 ba 01 00 00 00 be 03 00 00 00 e8 42 50 b2 ff eb cd 0f 1f 44 00 00 55 48 85 ff 48 89 e5 41 56 41 55 41 54 <53> 48 89 fb 74 35 4c 8b 67 40 4d 85 e4 74 2c 4d 8d 6c 24 28 4c 
[25233.974377] NMI backtrace for cpu 3
[25233.975270] CPU: 3 PID: 17777 Comm: trinity-c206 Tainted: G             L 3.18.0+ #108
[25233.977090] task: ffff880228aa2bc0 ti: ffff88022936c000 task.ti: ffff88022936c000
[25233.978013] RIP: 0010:[<ffffffff81165a15>]  [<ffffffff81165a15>] unlock_page+0x25/0x90
[25233.978949] RSP: 0018:ffff88022936fbf8  EFLAGS: 00000202
[25233.979880] RAX: ffffea0008ee2d80 RBX: ffffea0008ee2d80 RCX: 00000000146c9000
[25233.980816] RDX: 002ffe000008001c RSI: 9e37fffffffc0001 RDI: ffffea0008ee2d80
[25233.981761] RBP: ffff88022936fbf8 R08: 0000000000001000 R09: ffffea0008ee2d80
[25233.982702] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
[25233.983653] R13: ffff88022936fd60 R14: 0000000000000000 R15: ffff8800a251da08
[25233.984603] FS:  00007f95dc296740(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25233.985565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25233.986528] CR2: 0000000000000008 CR3: 000000022d223000 CR4: 00000000001407e0
[25233.987505] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25233.988484] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25233.989436] Stack:
[25233.990361]  ffff88022936fc28 ffffffff8117f380 00000000146c8000 0000000000001000
[25233.991308]  ffff88022936fd60 0000000000000000 ffff88022936fcc8 ffffffff8116532a
[25233.992263]  ffff88022936fd68 0000000000001000 ffff880228aa2bc0 00000000811f1681
[25233.993212] Call Trace:
[25233.994140]  [<ffffffff8117f380>] shmem_write_end+0x40/0xf0
[25233.995056]  [<ffffffff8116532a>] generic_perform_write+0x11a/0x1f0
[25233.995969]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25233.996873]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25233.997776]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25233.998673]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25233.999570]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25234.000462]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25234.001357]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25234.002277]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25234.003155]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25234.004045]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25234.004942]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25234.005827]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25234.006705]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25234.007581] Code: 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 f8 48 8b 17 48 89 e5 83 e2 01 74 60 f0 80 27 fe 48 be 01 00 fc ff ff ff 37 9e 48 8b 17 <48> 0f af f7 48 89 d1 48 c1 ea 34 83 e2 03 48 c1 e9 36 48 8d 14 
[25234.009513] NMI backtrace for cpu 2
[25234.010438] CPU: 2 PID: 17723 Comm: trinity-c152 Tainted: G             L 3.18.0+ #108
[25234.012415] task: ffff880229a50af0 ti: ffff88022e918000 task.ti: ffff88022e918000
[25234.013417] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>] read_hpet+0x16/0x20
[25234.014445] RSP: 0018:ffff88022e91be58  EFLAGS: 00000046
[25234.015465] RAX: 000000002b67efe4 RBX: 000000000051c224 RCX: 0000000000000004
[25234.016505] RDX: 0000000000004949 RSI: ffff88022e91be98 RDI: ffffffff81c26f40
[25234.017547] RBP: ffff88022e91be58 R08: 0000000000000004 R09: 00000000004323f1
[25234.018587] R10: 0000000000000004 R11: 0000000000000202 R12: 000016f68c124117
[25234.019640] R13: 0000000000000000 R14: ffff880229825108 R15: 0000000000000000
[25234.020693] FS:  00007f95dc296740(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25234.021740] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25234.022761] CR2: 00007f95dc055220 CR3: 000000014fecd000 CR4: 00000000001407e0
[25234.023813] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25234.024844] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25234.025871] Stack:
[25234.026890]  ffff88022e91be88 ffffffff810e0d3e ffff88022e91be98 ffff880229825108
[25234.027926]  000016f6dfac1843 ffff88022e91bf18 ffff88022e91beb8 ffffffff810da9da
[25234.028977]  0000000000000086 00000000749a29d5 ffff880229825108 ffff88022e91bf38
[25234.030035] Call Trace:
[25234.031074]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[25234.032113]  [<ffffffff810da9da>] hrtimer_get_remaining+0x3a/0x70
[25234.033154]  [<ffffffff810dbbf6>] itimer_get_remtime+0x16/0x60
[25234.034172]  [<ffffffff810dc242>] do_setitimer+0xb2/0x260
[25234.035175]  [<ffffffff810dc439>] alarm_setitimer+0x49/0x90
[25234.036173]  [<ffffffff810da3ae>] SyS_alarm+0xe/0x20
[25234.037171]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25234.038136] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 d3 c8 ec 00 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d 29 c8 ec 00 
[25234.040197] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 109.194 msecs
[25261.864386] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c24:30558]
[25261.865435] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25261.871111] CPU: 1 PID: 30558 Comm: trinity-c24 Tainted: G             L 3.18.0+ #108
[25261.873609] task: ffff88009b63abc0 ti: ffff8802283d4000 task.ti: ffff8802283d4000
[25261.874875] RIP: 0033:[<0000000000412fc8>]  [<0000000000412fc8>] 0x412fc8
[25261.876181] RSP: 002b:00007fff73bbaf70  EFLAGS: 00000202
[25261.877378] RAX: 00000000759aa432 RBX: ffffffff81799dfa RCX: 0000000000000038
[25261.878584] RDX: 000000000bc2aa05 RSI: 00007fff73bbaf4c RDI: 000000336f1b76e0
[25261.879738] RBP: 0000000000000002 R08: 000000336f1b70e8 R09: 000000336f1b7140
[25261.880885] R10: 0000000000000000 R11: 0000000000000206 R12: ffff8802283d7f78
[25261.882058] R13: 0000000000000000 R14: ffff8802283d4000 R15: ffff88009b63abc0
[25261.883248] FS:  00007f95dc296740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25261.884396] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25261.885546] CR2: 0000000000000001 CR3: 0000000235a45000 CR4: 00000000001407e0
[25261.886701] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25261.887903] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600

[25261.890230] sending NMI to other CPUs:
[25261.891374] NMI backtrace for cpu 0
[25261.892452] CPU: 0 PID: 30551 Comm: trinity-c4 Tainted: G             L 3.18.0+ #108
[25261.894667] task: ffff880229a515e0 ti: ffff88000e014000 task.ti: ffff88000e014000
[25261.895791] RIP: 0010:[<ffffffff81799260>]  [<ffffffff81799260>] system_call+0x0/0x3
[25261.896927] RSP: 0018:00007fff73bbafa8  EFLAGS: 00000046
[25261.898061] RAX: 000000000000003d RBX: 0000000000007780 RCX: 000000336eebc2fc
[25261.899206] RDX: 000000000000000b RSI: 00007fff73bbafb0 RDI: 0000000000007780
[25261.900327] RBP: 0000000000000000 R08: 00007f95dc296740 R09: 0000000000000000
[25261.901427] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f95dc0cb000
[25261.902524] R13: 00007f95dc0cb068 R14: 0000000000000000 R15: 0000000000000000
[25261.903615] FS:  00007f95dc296740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25261.904695] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25261.905755] CR2: 000000336f1b7740 CR3: 0000000095b7d000 CR4: 00000000001407f0
[25261.906819] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25261.907870] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25261.908922] Stack:
[25261.909964]  000000000041401b 00007f95dc216768 00007f95dc0cb000 0000000000000000
[25261.911029]  00007f95dc0cb07c 00007f95dc0cb000 0000000000000000 00007f95dc0cb07c
[25261.912090]  0000000000416c03 00000000000042bc 0000000000000017 00000000cccccccd
[25261.913152] Call Trace:
[25261.914193]  <UNK> 
[25261.914200] Code: 
[25261.915236] 8b 3c 24 4c 8b 74 24 08 4c 8b 6c 24 10 4c 8b 64 24 18 48 8b 6c 24 20 48 8b 5c 24 28 48 83 c4 30 e9 6f 02 00 00 66 0f 1f 44 00 00 <0f> 01 f8 65 48 89 24 25 80 a0 00 00 65 48 8b 24 25 88 a8 00 00 
[25261.917470] NMI backtrace for cpu 3
[25261.918589] CPU: 3 PID: 30572 Comm: trinity-c230 Tainted: G             L 3.18.0+ #108
[25261.920852] task: ffff8800967736b0 ti: ffff88022cbc0000 task.ti: ffff88022cbc0000
[25261.922001] RIP: 0010:[<ffffffff8118f1c4>]  [<ffffffff8118f1c4>] iov_iter_fault_in_readable+0x64/0x80
[25261.923165] RSP: 0018:ffff88022cbc3c18  EFLAGS: 00000206
[25261.924316] RAX: 0000000000000000 RBX: 00000000029ef000 RCX: 0000000000001007
[25261.925475] RDX: 00007f95d952b800 RSI: 0000000000001000 RDI: 000000000001e800
[25261.926633] RBP: ffff88022cbc3c28 R08: ffff880066aca360 R09: 0000000000094524
[25261.927794] R10: ffff88022cbc3af8 R11: 00000000000003ff R12: 0000000000001000
[25261.928954] R13: ffff88022cbc3d60 R14: 0000000000001000 R15: ffff8800a2518d28
[25261.930112] FS:  00007f95dc296740(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25261.931280] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25261.932458] CR2: 00007f95d9a2036e CR3: 000000022b2d6000 CR4: 00000000001407e0
[25261.933618] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25261.934753] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25261.935873] Stack:
[25261.936974]  0000000000001000 00ff8800a2518d28 ffff88022cbc3cc8 ffffffff811652b8
[25261.938081]  ffff88022cbc3c98 0000000000001000 ffff8800967736b0 00000000811f1681
[25261.939164]  0000000000f60000 0000000000000000 ffff88009f3c9400 ffffffff81828380
[25261.940227] Call Trace:
[25261.941261]  [<ffffffff811652b8>] generic_perform_write+0xa8/0x1f0
[25261.942290]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25261.943300]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25261.944291]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25261.945270]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25261.946243]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25261.947210]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25261.948174]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25261.949141]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25261.950106]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25261.951068]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25261.952027]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25261.952982]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25261.953928]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25261.954865] Code: 10 0f 1f 00 40 8a 39 0f 1f 00 85 d2 40 88 7d ff 75 2d 48 63 f6 48 8d 54 31 ff 48 31 d1 48 f7 c1 00 f0 ff ff 74 0f 0f 1f 00 8a 12 <0f> 1f 00 88 55 ff 0f b6 55 ff c9 f3 c3 0f 1f 80 00 00 00 00 c9 
[25261.956947] NMI backtrace for cpu 2
[25261.957928] CPU: 2 PID: 30581 Comm: trinity-c42 Tainted: G             L 3.18.0+ #108
[25261.959978] task: ffff88022c1f2bc0 ti: ffff8800a2604000 task.ti: ffff8800a2604000
[25261.961020] RIP: 0033:[<00007fff73bd3bfe>]  [<00007fff73bd3bfe>] 0x7fff73bd3bfe
[25261.962065] RSP: 002b:00007fff73bbaf20  EFLAGS: 00000246
[25261.963081] RAX: 0000000043481221 RBX: 00007f95dbedd068 RCX: 000000336eeef4b9
[25261.964103] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00007f95dbedd000
[25261.965115] RBP: 00007fff73bbaf20 R08: 002b34bd7fef2fdf R09: 00000000004d1e4c
[25261.966125] R10: 0000000000000002 R11: 0000000000000246 R12: 00007f95dbedd000
[25261.967135] R13: 00000000000001ff R14: 0000000000000000 R15: 00007f95dc2966a0
[25261.968161] FS:  00007f95dc296740(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25261.969187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25261.970198] CR2: 0000000000000008 CR3: 0000000040239000 CR4: 00000000001407e0
[25261.971236] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25261.972260] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600

[25289.848160] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c27:31317]
[25289.849258] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25289.855194] CPU: 1 PID: 31317 Comm: trinity-c27 Tainted: G             L 3.18.0+ #108
[25289.857533] task: ffff8802415a0af0 ti: ffff8802290e4000 task.ti: ffff8802290e4000
[25289.858723] RIP: 0010:[<ffffffff81356c07>]  [<ffffffff81356c07>] clear_page_c_e+0x7/0x10
[25289.859915] RSP: 0000:ffff8802290e7ce0  EFLAGS: 00010246
[25289.861099] RAX: 0000000000000000 RBX: ffff8802415a0af0 RCX: 00000000000001c0
[25289.862267] RDX: 0000000000007a55 RSI: 0000000000000ead RDI: ffff880123d7ae40
[25289.863466] RBP: ffff8802290e7d18 R08: ffffea00048f0000 R09: 00000000000160f0
[25289.864660] R10: ffff88024e5d4d80 R11: 0000000000000000 R12: 0000000000000000
[25289.865808] R13: ffff8802415a0af0 R14: ffff88024e5d5b00 R15: 0000000200000000
[25289.866970] FS:  00007fd3c5236740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25289.868134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25289.869294] CR2: 0000000001c00000 CR3: 0000000227866000 CR4: 00000000001407e0
[25289.870491] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25289.871683] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25289.872843] Stack:
[25289.874017]  ffffffff81196633 ffff880235814070 0000000001c00000 0000000000000000
[25289.875201]  ffff8800967dcc00 ffff880235814070 ffff8801c64b4600 ffff8802290e7d78
[25289.876372]  ffffffff811ca951 ffff8802290e7e18 ffffffff8115f002 ffffea00048f0000
[25289.877537] Call Trace:
[25289.878705]  [<ffffffff81196633>] ? clear_huge_page+0xa3/0x160
[25289.879878]  [<ffffffff811ca951>] do_huge_pmd_anonymous_page+0x151/0x3b0
[25289.881085]  [<ffffffff8115f002>] ? __perf_sw_event+0x1b2/0x200
[25289.882274]  [<ffffffff81194c1b>] handle_mm_fault+0x14b/0xe90
[25289.883439]  [<ffffffff810413cc>] __do_page_fault+0x20c/0x610
[25289.884554]  [<ffffffff8119b61d>] ? do_brk+0x24d/0x350
[25289.885663]  [<ffffffff8135866a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[25289.886786]  [<ffffffff810417dc>] do_page_fault+0xc/0x10
[25289.887911]  [<ffffffff8179ae62>] page_fault+0x22/0x30
[25289.889033] Code: bc 0f 1f 00 e8 fb fa d1 ff 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 f3 48 ab c3 0f 1f 44 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[25289.891387] sending NMI to other CPUs:
[25289.892488] NMI backtrace for cpu 2
[25289.893575] CPU: 2 PID: 350 Comm: trinity-c163 Tainted: G             L 3.18.0+ #108
[25289.895771] task: ffff8802293236b0 ti: ffff88009ab34000 task.ti: ffff88009ab34000
[25289.896886] RIP: 0010:[<ffffffff8136544a>]  [<ffffffff8136544a>] __list_add+0x1a/0xc0
[25289.898020] RSP: 0000:ffff88009ab37b08  EFLAGS: 00000092
[25289.899149] RAX: 0000000000000030 RBX: ffffea00079e7c20 RCX: 000000000000000d
[25289.900265] RDX: ffffea00079e7c60 RSI: ffff88024e296120 RDI: ffffea00079e7c20
[25289.901361] RBP: ffff88009ab37b28 R08: ffff88024e296120 R09: 00000000001e79f0
[25289.902457] R10: 0000000000000002 R11: 0000000000000002 R12: ffffea00079e7c60
[25289.903549] R13: ffff88024e296120 R14: 0000000000000002 R15: 0000000000000202
[25289.904623] FS:  00007fd3c5236740(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25289.905686] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25289.906746] CR2: 000000336ef629f2 CR3: 00000002359ea000 CR4: 00000000001407e0
[25289.907809] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25289.908869] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25289.909925] Stack:
[25289.910974]  002ffe000008000c ffffea00079e7c00 ffff88024e2960f0 0000000000000000
[25289.912045]  ffff88009ab37b78 ffffffff8116d218 00000000001e79f0 ffff88024e5d4d80
[25289.913122]  ffff880238414300 ffffea00079e7cc0 ffffea00079e7c00 0000000000000000
[25289.914193] Call Trace:
[25289.915250]  [<ffffffff8116d218>] free_hot_cold_page+0x148/0x1b0
[25289.916316]  [<ffffffff8116d2ce>] free_hot_cold_page_list+0x4e/0xc0
[25289.917375]  [<ffffffff81223d4f>] ? locks_alloc_lock+0x1f/0x70
[25289.918438]  [<ffffffff81173f62>] release_pages+0x1c2/0x280
[25289.919489]  [<ffffffff81174c93>] __pagevec_release+0x43/0x60
[25289.920534]  [<ffffffff81180ff0>] shmem_undo_range+0x460/0x710
[25289.921557]  [<ffffffff811812b8>] shmem_truncate_range+0x18/0x40
[25289.922553]  [<ffffffff81181520>] shmem_setattr+0x110/0x1a0
[25289.923527]  [<ffffffff811f3361>] notify_change+0x241/0x390
[25289.924478]  [<ffffffff811d3323>] do_truncate+0x73/0xc0
[25289.925401]  [<ffffffff811d36cc>] do_sys_ftruncate.constprop.14+0x10c/0x160
[25289.926315]  [<ffffffff8135862e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[25289.927214]  [<ffffffff811d3770>] compat_SyS_ftruncate+0x10/0x20
[25289.928093]  [<ffffffff8179b9e9>] ia32_do_call+0x13/0x13
[25289.928958] Code: ff ff e9 3b ff ff ff b8 f4 ff ff ff e9 31 ff ff ff 55 48 89 e5 41 55 49 89 f5 41 54 49 89 d4 53 48 89 fb 48 83 ec 08 4c 8b 42 08 <49> 39 f0 75 2e 4d 8b 45 00 4d 39 c4 75 6c 4c 39 e3 74 42 4c 39 
[25289.930848] NMI backtrace for cpu 3
[25289.931762] CPU: 3 PID: 31454 Comm: trinity-c164 Tainted: G             L 3.18.0+ #108
[25289.933619] task: ffff88009f3f95e0 ti: ffff880229bf4000 task.ti: ffff880229bf4000
[25289.934573] RIP: 0010:[<ffffffff811753f9>]  [<ffffffff811753f9>] cancel_dirty_page+0x39/0xc0
[25289.935536] RSP: 0000:ffff880229bf7c28  EFLAGS: 00000286
[25289.936482] RAX: 00000000fffffffb RBX: ffff8800a2518d28 RCX: 0000000000001fdd
[25289.937434] RDX: ffffea0008433d00 RSI: 0000000000001000 RDI: ffffea0008433d00
[25289.938386] RBP: ffff880229bf7c48 R08: 000000000001182a R09: ffff880121d39fc8
[25289.939345] R10: ffff880229bf7bd8 R11: 0000000000000220 R12: 0000000000001000
[25289.940295] R13: ffff880229bf7d40 R14: 0000000000000000 R15: 00000000000118ee
[25289.941237] FS:  00007fd3c5236740(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25289.942185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25289.943137] CR2: 00000000014f4fd8 CR3: 000000010750d000 CR4: 00000000001407e0
[25289.944088] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25289.945036] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25289.945982] Stack:
[25289.946922]  ffff880229bf7d40 ffffea0008433d00 ffff8800a2518d28 ffff880229bf7d40
[25289.947887]  ffff880229bf7c68 ffffffff811758fe 000000000000000a ffff880229bf7cd0
[25289.948859]  ffff880229bf7df8 ffffffff81180fab ffffea00027bbe00 ffff8800a2518be0
[25289.949826] Call Trace:
[25289.950786]  [<ffffffff811758fe>] truncate_inode_page+0x4e/0x90
[25289.951752]  [<ffffffff81180fab>] shmem_undo_range+0x41b/0x710
[25289.952721]  [<ffffffff811812b8>] shmem_truncate_range+0x18/0x40
[25289.953666]  [<ffffffff81181520>] shmem_setattr+0x110/0x1a0
[25289.954589]  [<ffffffff811f3361>] notify_change+0x241/0x390
[25289.955510]  [<ffffffff811d3323>] do_truncate+0x73/0xc0
[25289.956428]  [<ffffffff811d36cc>] do_sys_ftruncate.constprop.14+0x10c/0x160
[25289.957345]  [<ffffffff8135862e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[25289.958247]  [<ffffffff811d375e>] SyS_ftruncate+0xe/0x10
[25289.959129]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25289.960005] Code: 89 f4 53 48 83 ec 08 f0 0f ba 37 04 72 14 48 83 c4 08 5b 41 5c 41 5d 5d c3 66 0f 1f 84 00 00 00 00 00 48 8b 5f 08 48 85 db 74 e3 <48> 8b 83 88 00 00 00 f6 40 20 01 75 d6 be 0b 00 00 00 e8 f0 e9 
[25289.961909] NMI backtrace for cpu 0
[25289.962833] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #108
[25289.964723] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[25289.965679] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25289.966648] RSP: 0018:ffffffff81c03e58  EFLAGS: 00000046
[25289.967596] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25289.968548] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[25289.969493] RBP: ffffffff81c03e88 R08: 0000000000000018 R09: 00000000000006c9
[25289.970443] R10: 0000000000000fc9 R11: 0000000000000400 R12: 0000000000000005
[25289.971384] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[25289.972314] FS:  0000000000000000(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25289.973248] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25289.974183] CR2: 0000000000000008 CR3: 0000000001c11000 CR4: 00000000001407f0
[25289.975117] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25289.976047] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25289.976979] Stack:
[25289.977905]  0000000081c03e88 b7fee4166800c9e8 ffffe8ffffc01ba8 0000000000000005
[25289.978865]  ffffffff81c9e440 0000000000000000 ffffffff81c03ed8 ffffffff8163a995
[25289.979820]  00001703ad828700 ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25289.980783] Call Trace:
[25289.981737]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25289.982705]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25289.983669]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25289.984636]  [<ffffffff81787ac7>] rest_init+0x87/0x90
[25289.985602]  [<ffffffff81d1e032>] start_kernel+0x483/0x4a4
[25289.986565]  [<ffffffff81d1d99f>] ? set_init_arg+0x55/0x55
[25289.987521]  [<ffffffff81d1d581>] x86_64_start_reservations+0x2a/0x2c
[25289.988488]  [<ffffffff81d1d675>] x86_64_start_kernel+0xf2/0xf6
[25289.989425] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25317.831994] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [swapper/1:0]
[25317.833213] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25317.839376] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.18.0+ #108
[25317.841869] task: ffff8802444fed60 ti: ffff880244704000 task.ti: ffff880244704000
[25317.843147] RIP: 0010:[<ffffffff8163a9b9>]  [<ffffffff8163a9b9>] cpuidle_enter_state+0x79/0x190
[25317.844445] RSP: 0018:ffff880244707e48  EFLAGS: 00000246
[25317.845727] RAX: 0000170a2fdbc2c9 RBX: ffffffff81799e0d RCX: 0000000000000019
[25317.847008] RDX: 20c49ba5e353f7cf RSI: ffff880244707fd8 RDI: ffffffff81c26f40
[25317.848288] RBP: ffff880244707e88 R08: ffff88024e24ecf0 R09: 00000000ffffffff
[25317.849570] R10: 000000000000262f R11: 0000000000aaaaaa R12: ffff880244707db8
[25317.850860] R13: 0000000000000000 R14: ffff880244704000 R15: ffff8802444fed60
[25317.852157] FS:  0000000000000000(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25317.853393] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25317.854633] CR2: 00007fda8919e000 CR3: 0000000001c11000 CR4: 00000000001407e0
[25317.855885] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25317.857121] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25317.858353] Stack:
[25317.859581]  0000170a2f44020c ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25317.860841]  ffffe8ffffc41ba8 ffff880244704000 ffffffff81c9e440 ffff880244704000
[25317.862108]  ffff880244707e98 ffffffff8163ab87 ffff880244707f08 ffffffff810b9095
[25317.863330] Call Trace:
[25317.864545]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25317.865774]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25317.866999]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25317.868218] Code: c8 48 89 df ff 50 48 41 89 c5 e8 63 63 aa ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 12 f8 af ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c0 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[25317.870820] sending NMI to other CPUs:
[25317.872055] NMI backtrace for cpu 0
[25317.873204] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #108
[25317.875524] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[25317.876676] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25317.877832] RSP: 0018:ffffffff81c03e58  EFLAGS: 00000046
[25317.878979] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25317.880133] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[25317.881280] RBP: ffffffff81c03e88 R08: 0000000000000018 R09: 0000000000000401
[25317.882431] R10: 0000000000000f4c R11: 0000000000000000 R12: 0000000000000005
[25317.883583] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[25317.884735] FS:  0000000000000000(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25317.885886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25317.887030] CR2: 00000000006392c8 CR3: 0000000001c11000 CR4: 00000000001407f0
[25317.888181] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25317.889331] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25317.890475] Stack:
[25317.891613]  0000000081c03e88 b7fee4166800c9e8 ffffe8ffffc01ba8 0000000000000005
[25317.892770]  ffffffff81c9e440 0000000000000000 ffffffff81c03ed8 ffffffff8163a995
[25317.893926]  0000170a323f875b ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25317.895082] Call Trace:
[25317.896217]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25317.897361]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25317.898503]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25317.899646]  [<ffffffff81787ac7>] rest_init+0x87/0x90
[25317.900788]  [<ffffffff81d1e032>] start_kernel+0x483/0x4a4
[25317.901931]  [<ffffffff81d1d99f>] ? set_init_arg+0x55/0x55
[25317.903073]  [<ffffffff81d1d581>] x86_64_start_reservations+0x2a/0x2c
[25317.904216]  [<ffffffff81d1d675>] x86_64_start_kernel+0xf2/0xf6
[25317.905357] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25317.907755] NMI backtrace for cpu 3
[25317.908965] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25317.911350] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25317.912485] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25317.913548] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25317.914602] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25317.915637] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25317.916642] RBP: ffff88024471be38 R08: ffff88024e2cecf0 R09: 00000000ffffffff
[25317.917629] R10: 000000000000263b R11: 0000000000000400 R12: 0000000000000005
[25317.918611] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880244718000
[25317.919581] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25317.920557] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25317.921528] CR2: 0000000000000024 CR3: 0000000001c11000 CR4: 00000000001407e0
[25317.922527] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25317.923502] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25317.924477] Stack:
[25317.925437]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000005
[25317.926419]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25317.927423]  0000170a323e077e ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25317.928430] Call Trace:
[25317.929409]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25317.930397]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25317.931370]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25317.932373]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25317.933346] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25317.935489] NMI backtrace for cpu 2
[25317.936503] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25317.938500] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25317.939486] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25317.940485] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25317.941483] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[25317.942501] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25317.943457] RBP: ffff88024470fe38 R08: ffff88024e28ecf0 R09: 00000000ffffffff
[25317.944395] R10: 0000000000002639 R11: 0000000000000400 R12: 0000000000000005
[25317.945329] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024470c000
[25317.946259] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25317.947190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25317.948124] CR2: 0000000000639058 CR3: 0000000001c11000 CR4: 00000000001407e0
[25317.949063] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25317.950009] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25317.950953] Stack:
[25317.951915]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000005
[25317.952893]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25317.953885]  0000170a323df4ab ffffffff81c9e610 ffffffff81c9e440 ffffffff81cfe330
[25317.954862] Call Trace:
[25317.955831]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25317.956807]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25317.957776]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25317.958741]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25317.959702] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25345.815706] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c103:12391]
[25345.816962] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25345.823837] CPU: 1 PID: 12391 Comm: trinity-c103 Tainted: G             L 3.18.0+ #108
[25345.826600] task: ffff88022911abc0 ti: ffff880143340000 task.ti: ffff880143340000
[25345.827931] RIP: 0010:[<ffffffff8178ecca>]  [<ffffffff8178ecca>] __slab_alloc+0x4e5/0x53b
[25345.829277] RSP: 0018:ffff880143343ca0  EFLAGS: 00000246
[25345.830607] RAX: 0000000000000001 RBX: ffff880143343c60 RCX: 000000018020001e
[25345.831928] RDX: 0000000000000020 RSI: ffffea00076ef700 RDI: ffff880245825680
[25345.833232] RBP: ffff880143343d70 R08: ffff8801dbbdc000 R09: 0000000000000000
[25345.834528] R10: 0000000000000082 R11: 00003ffffffff000 R12: 00000000000000bb
[25345.835836] R13: ffffffff810133af R14: ffff880143343c20 R15: 000000010020001d
[25345.837084] FS:  00007f5c9bc2f740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25345.838337] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25345.839599] CR2: 00000000020d4968 CR3: 00000002299b4000 CR4: 00000000001407e0
[25345.840857] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25345.842117] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25345.843379] Stack:
[25345.844620]  01ffffff00000000 ffff88022ea27288 00007f5c97aa4fff 00007f5c97a24000
[25345.845915]  0000000000000000 ffff8801dbbdc600 0000000227852b98 ffffffff810750f5
[25345.847139]  ffffffff00000000 0000000000000246 00007f5c97aa5000 00007f5c97aa4fff
[25345.848385] Call Trace:
[25345.849599]  [<ffffffff810750f5>] ? copy_process.part.29+0x12a5/0x1970
[25345.850835]  [<ffffffff810750f5>] ? copy_process.part.29+0x12a5/0x1970
[25345.852052]  [<ffffffff811c012b>] kmem_cache_alloc+0x1bb/0x1e0
[25345.853258]  [<ffffffff810750f5>] copy_process.part.29+0x12a5/0x1970
[25345.854460]  [<ffffffff811d79ad>] ? get_empty_filp+0xdd/0x1f0
[25345.855664]  [<ffffffff81075981>] do_fork+0xe1/0x3d0
[25345.856837]  [<ffffffff81012047>] ? syscall_trace_enter_phase2+0xa7/0x1e0
[25345.858003]  [<ffffffff81075cf6>] SyS_clone+0x16/0x20
[25345.859172]  [<ffffffff81799609>] stub_clone+0x69/0x90
[25345.860312]  [<ffffffff817994c4>] ? tracesys_phase2+0xd4/0xd9
[25345.861429] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 07 b4 9a ff 4c 89 e0 eb 0f e8 fd b4 9a ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 75 c8 65 48 33 34 25 28 00 00 00 74 32 e8 ff 79 
[25345.863833] sending NMI to other CPUs:
[25345.864970] NMI backtrace for cpu 2
[25345.866051] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #108
[25345.868240] task: ffff8802444f8af0 ti: ffff88024470c000 task.ti: ffff88024470c000
[25345.869350] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25345.870475] RSP: 0018:ffff88024470fe08  EFLAGS: 00000046
[25345.871594] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[25345.872721] RDX: 0000000000000000 RSI: ffff88024470ffd8 RDI: 0000000000000002
[25345.873846] RBP: ffff88024470fe38 R08: 0000000000000018 R09: 0000000000001033
[25345.874967] R10: 000000000000331d R11: 0000000000000002 R12: 0000000000000002
[25345.876083] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88024470c000
[25345.877191] FS:  0000000000000000(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25345.878306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25345.879419] CR2: 0000003370219050 CR3: 0000000229371000 CR4: 00000000001407e0
[25345.880537] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25345.881648] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25345.882753] Stack:
[25345.883844]  000000024470fe38 c6aa8015cfd0a8b5 ffffe8ffffc81ba8 0000000000000002
[25345.884958]  ffffffff81c9e440 0000000000000002 ffff88024470fe88 ffffffff8163a995
[25345.886071]  00001710b7b5ad88 ffffffff81c9e508 ffffffff81c9e440 ffffffff81cfe330
[25345.887189] Call Trace:
[25345.888301]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25345.889424]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25345.890517]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25345.891590]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25345.892652] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25345.894882] NMI backtrace for cpu 0
[25345.895925] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #108
[25345.897992] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[25345.899014] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25345.900033] RSP: 0018:ffffffff81c03e58  EFLAGS: 00000046
[25345.901026] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[25345.902020] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[25345.903001] RBP: ffffffff81c03e88 R08: 0000000000000018 R09: 000000000000032a
[25345.903982] R10: 00000000000003f6 R11: 00000000000fff9d R12: 0000000000000001
[25345.904960] R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff81c00000
[25345.905936] FS:  0000000000000000(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25345.906947] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25345.907962] CR2: 0000000000000001 CR3: 00000000973c9000 CR4: 00000000001407f0
[25345.909015] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25345.910072] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25345.911128] Stack:
[25345.912132]  0000000081c03e88 b7fee4166800c9e8 ffffe8ffffc01ba8 0000000000000001
[25345.913130]  ffffffff81c9e440 0000000000000000 ffffffff81c03ed8 ffffffff8163a995
[25345.914121]  00001710b7b5d674 ffffffff81c9e4b0 ffffffff81c9e440 ffffffff81cfe330
[25345.915112] Call Trace:
[25345.916097]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25345.917082]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25345.918056]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25345.919028]  [<ffffffff81787ac7>] rest_init+0x87/0x90
[25345.920015]  [<ffffffff81d1e032>] start_kernel+0x483/0x4a4
[25345.920988]  [<ffffffff81d1d99f>] ? set_init_arg+0x55/0x55
[25345.921960]  [<ffffffff81d1d581>] x86_64_start_reservations+0x2a/0x2c
[25345.922929]  [<ffffffff81d1d675>] x86_64_start_kernel+0xf2/0xf6
[25345.923900] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25345.926016] NMI backtrace for cpu 3
[25345.927071] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #108
[25345.929211] task: ffff8802444fe270 ti: ffff880244718000 task.ti: ffff880244718000
[25345.930264] RIP: 0010:[<ffffffff813b84eb>]  [<ffffffff813b84eb>] intel_idle+0xdb/0x180
[25345.931337] RSP: 0018:ffff88024471be08  EFLAGS: 00000046
[25345.932420] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[25345.933563] RDX: 0000000000000000 RSI: ffff88024471bfd8 RDI: 0000000000000003
[25345.934692] RBP: ffff88024471be38 R08: 0000000000000018 R09: 0000000000000d4b
[25345.935804] R10: 0000000000002da4 R11: 0000000000000002 R12: 0000000000000002
[25345.936797] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880244718000
[25345.937778] FS:  0000000000000000(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25345.938766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25345.939752] CR2: 0000000001e81930 CR3: 00000001f9d90000 CR4: 00000000001407e0
[25345.940747] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25345.941745] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25345.942743] Stack:
[25345.943728]  000000034471be38 5fbbf5c12849ac78 ffffe8ffffcc1ba8 0000000000000002
[25345.944753]  ffffffff81c9e440 0000000000000003 ffff88024471be88 ffffffff8163a995
[25345.945764]  00001710b7b5d25c ffffffff81c9e508 ffffffff81c9e440 ffffffff81cfe330
[25345.946777] Call Trace:
[25345.947789]  [<ffffffff8163a995>] cpuidle_enter_state+0x55/0x190
[25345.948807]  [<ffffffff8163ab87>] cpuidle_enter+0x17/0x20
[25345.949812]  [<ffffffff810b9095>] cpu_startup_entry+0x355/0x410
[25345.950811]  [<ffffffff8102fd0a>] start_secondary+0x1aa/0x230
[25345.951826] Code: 31 d2 65 48 8b 34 25 88 a8 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 88 a8 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[25373.799486] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c17:29947]
[25373.800608] Modules linked in: dlci bridge snd_seq_dummy fuse 8021q garp stp tun bnep rfcomm scsi_transport_iscsi af_key llc2 hidp can_bcm sctp libcrc32c can_raw nfnetlink nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq e1000e shpchp snd_seq_device usb_debug coretemp hwmon x86_pkg_temp_thermal ptp pps_core snd_pcm nfsd snd_timer snd soundcore auth_rpcgss kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw oid_registry nfs_acl lockd grace sunrpc
[25373.806511] CPU: 1 PID: 29947 Comm: trinity-c17 Tainted: G             L 3.18.0+ #108
[25373.808876] task: ffff88022908abc0 ti: ffff8801bf164000 task.ti: ffff8801bf164000
[25373.810057] RIP: 0010:[<ffffffff810933ee>]  [<ffffffff810933ee>] find_get_pid+0x1e/0x30
[25373.811282] RSP: 0018:ffff8801bf167ee8  EFLAGS: 00000202
[25373.812535] RAX: ffff8801bf33a140 RBX: ffffffff810850e0 RCX: ffff8801bf33a170
[25373.813781] RDX: 0000000000000030 RSI: ffffffff81c44840 RDI: 0000000000007d64
[25373.815031] RBP: ffff8801bf167ee8 R08: 00007f0b34598740 R09: 0000000000000000
[25373.816283] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[25373.817515] R13: ffff8801bf167eb0 R14: ffff8801bf33a140 R15: ffff8801bf167e68
[25373.818738] FS:  00007f0b34598740(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[25373.819941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25373.821149] CR2: 000000336f1b7740 CR3: 0000000242a70000 CR4: 00000000001407e0
[25373.822379] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25373.823593] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25373.824799] Stack:
[25373.825983]  ffff8801bf167f78 ffffffff81079935 0000000f00000000 ffff8801bf33a140
[25373.827203]  0000000000000000 00007fff74741110 0000000000000000 0000000000000000
[25373.828434]  ffff88022908abc0 ffffffff8135862e 0000000000000246 0000000000000000
[25373.829660] Call Trace:
[25373.830833]  [<ffffffff81079935>] SyS_wait4+0x55/0x110
[25373.832014]  [<ffffffff8135862e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[25373.833206]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25373.834409] Code: 80 00 00 00 00 31 c0 eb eb 0f 1f 40 00 0f 1f 44 00 00 55 48 89 e5 65 ff 04 25 60 a8 00 00 e8 ca fe ff ff 48 85 c0 74 03 f0 ff 00 <65> ff 0c 25 60 a8 00 00 5d c3 0f 1f 84 00 00 00 00 00 0f 1f 44 
[25373.837037] sending NMI to other CPUs:
[25373.838287] NMI backtrace for cpu 0
[25373.839429] CPU: 0 PID: 32111 Comm: modprobe Tainted: G             L 3.18.0+ #108
[25373.841745] task: ffff8802293be270 ti: ffff880103704000 task.ti: ffff880103704000
[25373.842890] RIP: 0010:[<ffffffff811f70b4>]  [<ffffffff811f70b4>] __lookup_mnt+0x64/0x80
[25373.844045] RSP: 0018:ffff880103707bb8  EFLAGS: 00000286
[25373.845190] RAX: ffff880241670780 RBX: ffff880103707da8 RCX: 000000000000000e
[25373.846327] RDX: ffff880244b56300 RSI: ffff880241b03ae8 RDI: ffff8802416707a0
[25373.847446] RBP: ffff880103707bb8 R08: 70646f6d2f6e7572 R09: ffff880103707bdc
[25373.848558] R10: ffff88014331e921 R11: 0000000000000003 R12: ffff880241b03ae8
[25373.849665] R13: ffff880103707c60 R14: ffff880103707c50 R15: ffff8802416707a0
[25373.850770] FS:  00007fdddcfb2740(0000) GS:ffff88024e200000(0000) knlGS:0000000000000000
[25373.851886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25373.853000] CR2: 00000000016211d8 CR3: 00000001c6569000 CR4: 00000000001407f0
[25373.854123] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25373.855252] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25373.856371] Stack:
[25373.857476]  ffff880103707c18 ffffffff811e082a 0000000000000081 ffff880200000001
[25373.858600]  0000000203707be8 00000000d85f4923 ffff880103707c08 ffff88014331e925
[25373.859730]  ffff8802293be270 6f636e6c2e6d7471 00000000ffffff9c ffff880103707da8
[25373.860865] Call Trace:
[25373.861983]  [<ffffffff811e082a>] lookup_fast+0xca/0x2e0
[25373.863101]  [<ffffffff811e28a5>] link_path_walk+0x1a5/0x850
[25373.864213]  [<ffffffff811e3424>] path_lookupat+0x64/0x770
[25373.865321]  [<ffffffff811c006f>] ? kmem_cache_alloc+0xff/0x1e0
[25373.866424]  [<ffffffff811e5dff>] ? getname_flags+0x4f/0x1a0
[25373.867522]  [<ffffffff811e3b5b>] filename_lookup+0x2b/0xc0
[25373.868622]  [<ffffffff811e6e23>] user_path_at_empty+0x63/0xc0
[25373.869721]  [<ffffffff811d7600>] ? fput+0xa0/0xa0
[25373.870814]  [<ffffffff812577da>] ? ext4_release_dir+0x2a/0x40
[25373.871890]  [<ffffffff811e6e91>] user_path_at+0x11/0x20
[25373.872942]  [<ffffffff811daa63>] vfs_fstatat+0x63/0xc0
[25373.873985]  [<ffffffff811d77e8>] ? __fput+0x188/0x1f0
[25373.875004]  [<ffffffff811daf8e>] SYSC_newstat+0x2e/0x60
[25373.876000]  [<ffffffff810941b4>] ? task_work_run+0xc4/0xe0
[25373.876971]  [<ffffffff81002bb9>] ? do_notify_resume+0x59/0x80
[25373.877921]  [<ffffffff8135862e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[25373.878846]  [<ffffffff811db26e>] SyS_newstat+0xe/0x10
[25373.879757]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25373.880651] Code: c2 48 8b 10 31 c0 48 85 d2 75 1c 5d c3 66 2e 0f 1f 84 00 00 00 00 00 48 39 72 18 74 23 48 8b 12 48 85 d2 74 17 66 90 48 8b 42 10 <48> 83 c0 20 48 39 c7 74 e3 48 8b 12 48 85 d2 75 eb 31 c0 5d c3 
[25373.882565] NMI backtrace for cpu 2
[25373.883509] CPU: 2 PID: 31661 Comm: trinity-c90 Tainted: G             L 3.18.0+ #108
[25373.885431] task: ffff88022e86a0d0 ti: ffff880039fc0000 task.ti: ffff880039fc0000
[25373.886415] RIP: 0010:[<ffffffff8118f1c4>]  [<ffffffff8118f1c4>] iov_iter_fault_in_readable+0x64/0x80
[25373.887422] RSP: 0018:ffff880039fc3c18  EFLAGS: 00000206
[25373.888422] RAX: 0000000000000000 RBX: 000000000468e000 RCX: 0000000000003001
[25373.889432] RDX: 00007f0b31a7ea00 RSI: 0000000000001000 RDI: 000000000026fa00
[25373.890454] RBP: ffff880039fc3c28 R08: ffff8800978c0cf0 R09: 00000000008b89e2
[25373.891462] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
[25373.892470] R13: ffff880039fc3d60 R14: 0000000000001000 R15: ffff88022e9718b0
[25373.893546] FS:  00007f0b34598740(0000) GS:ffff88024e280000(0000) knlGS:0000000000000000
[25373.894591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25373.895602] CR2: 00007f0b33620294 CR3: 000000009f3b0000 CR4: 00000000001407e0
[25373.896666] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25373.897705] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25373.898733] Stack:
[25373.899757]  0000000000001000 00ff88022e9718b0 ffff880039fc3cc8 ffffffff811652b8
[25373.900776]  0000000054940ba3 0000000000001000 ffff88022e86a0d0 0000000000000a01
[25373.901816]  000000000468dffa 0000000000000000 ffff880071a82580 ffffffff81828380
[25373.902857] Call Trace:
[25373.903836]  [<ffffffff811652b8>] generic_perform_write+0xa8/0x1f0
[25373.904819]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25373.905807]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25373.906776]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25373.907731]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.908671]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25373.909602]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25373.910526]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.911458]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.912427]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25373.913397]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25373.914320]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25373.915231]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25373.916128]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25373.917017] Code: 10 0f 1f 00 40 8a 39 0f 1f 00 85 d2 40 88 7d ff 75 2d 48 63 f6 48 8d 54 31 ff 48 31 d1 48 f7 c1 00 f0 ff ff 74 0f 0f 1f 00 8a 12 <0f> 1f 00 88 55 ff 0f b6 55 ff c9 f3 c3 0f 1f 80 00 00 00 00 c9 
[25373.918994] NMI backtrace for cpu 3
[25373.919961] CPU: 3 PID: 29575 Comm: trinity-c135 Tainted: G             L 3.18.0+ #108
[25373.921902] task: ffff88022d2fa0d0 ti: ffff88009aa0c000 task.ti: ffff88009aa0c000
[25373.922890] RIP: 0010:[<ffffffff81165a08>]  [<ffffffff81165a08>] unlock_page+0x18/0x90
[25373.923900] RSP: 0018:ffff88009aa0fbf8  EFLAGS: 00000202
[25373.924888] RAX: ffffea0001505d00 RBX: ffffea0001505d00 RCX: 007c8fc09347b000
[25373.925868] RDX: 0000000000000001 RSI: ffff88022e973770 RDI: ffffea0001505d00
[25373.926844] RBP: ffff88009aa0fbf8 R08: 0000000000001000 R09: ffffea0001505d00
[25373.927819] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
[25373.928790] R13: ffff88009aa0fd60 R14: 0000000000000000 R15: ffff88022e973770
[25373.929770] FS:  00007f0b34598740(0000) GS:ffff88024e2c0000(0000) knlGS:0000000000000000
[25373.930759] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25373.931746] CR2: 00007f0b3320417d CR3: 0000000039ddb000 CR4: 00000000001407e0
[25373.932739] DR0: 00007fade9372000 DR1: 00007fe6ed782000 DR2: 0000000000000000
[25373.933800] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25373.934848] Stack:
[25373.935836]  ffff88009aa0fc28 ffffffff8117f380 007c8fc09347a000 0000000000001000
[25373.936902]  ffff88009aa0fd60 0000000000000000 ffff88009aa0fcc8 ffffffff8116532a
[25373.938049]  ffff88009aa0fd68 0000000000001000 ffff88022d2fa0d0 0000000045806f40
[25373.939153] Call Trace:
[25373.940209]  [<ffffffff8117f380>] shmem_write_end+0x40/0xf0
[25373.941247]  [<ffffffff8116532a>] generic_perform_write+0x11a/0x1f0
[25373.942283]  [<ffffffff8116789f>] __generic_file_write_iter+0x15f/0x350
[25373.943317]  [<ffffffff811d5140>] ? new_sync_read+0xd0/0xd0
[25373.944323]  [<ffffffff81167acd>] generic_file_write_iter+0x3d/0xb0
[25373.945306]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.946298]  [<ffffffff811d5288>] do_iter_readv_writev+0x78/0xc0
[25373.947279]  [<ffffffff811d6a18>] do_readv_writev+0xd8/0x2a0
[25373.948237]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.949185]  [<ffffffff81167a90>] ? __generic_file_write_iter+0x350/0x350
[25373.950126]  [<ffffffff810dac62>] ? __hrtimer_start_range_ns+0x252/0x380
[25373.951061]  [<ffffffff810dadc8>] ? hrtimer_start+0x18/0x20
[25373.951985]  [<ffffffff811d6c69>] vfs_writev+0x39/0x50
[25373.952958]  [<ffffffff811d6dc9>] SyS_writev+0x59/0xf0
[25373.953919]  [<ffffffff817992d2>] system_call_fastpath+0x12/0x17
[25373.954946] Code: 41 f6 c4 01 0f 84 7d ff ff ff eb eb 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 f8 48 8b 17 48 89 e5 83 e2 01 74 60 f0 80 27 fe <48> be 01 00 fc ff ff ff 37 9e 48 8b 17 48 0f af f7 48 89 d1 48 
[25373.957052] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 118.758 msecs
