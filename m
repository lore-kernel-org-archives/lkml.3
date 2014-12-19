Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaLSCrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:47:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaLSCrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:09 -0500
Date: Thu, 18 Dec 2014 21:45:49 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219024549.GB1671@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
 <20141215055707.GA26225@redhat.com>
 <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218161230.GA6042@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 11:12:30AM -0500, Dave Jones wrote:
 
 >  > It might be fun to run with CONFIG_DEBUG_OBJECTS off.
 > 
 > That was going to be my next move in absense of any better ideas.

So this is interesting. So far today with that change, I've not been able
to reproduce the "NMI watchdog kicks in, and then locks up the box", but I keep
hitting lockups which cause the kernel to taint, and then the fuzzer
would usually quit. I hacked something up so it would ignore that, and keep
going, and it spews a lot of traces, but it does actually seem to be staying up.

Example of the spew-o-rama below.

	Dave


[15351.809622] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15351.809723] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15351.811011] CPU: 1 PID: 20128 Comm: trinity-c195 Not tainted 3.18.0+ #107
[15351.813048] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15351.814094] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15351.815142] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15351.816174] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15351.817211] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15351.818242] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15351.819265] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15351.820314] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15351.821343] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15351.822373] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15351.823401] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15351.824436] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15351.825473] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15351.826507] Stack:
[15351.827536]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15351.828596]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15351.829683]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15351.830752] Call Trace:
[15351.831807]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15351.832873]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15351.833942]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15351.834999]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15351.836044]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15351.837077]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15351.838105]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15351.839141]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15351.840210]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15351.841244]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15351.842280]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15351.843311]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15351.844337]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15351.845358]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15351.846384] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15351.848623] sending NMI to other CPUs:
[15351.849722] NMI backtrace for cpu 2
[15351.850796] CPU: 2 PID: 22823 Comm: trinity-c154 Not tainted 3.18.0+ #107
[15351.852950] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15351.854042] RIP: 0010:[<ffffffff810fb22a>]  [<ffffffff810fb22a>] generic_exec_single+0xea/0x1b0
[15351.855149] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15351.856246] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15351.857348] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15351.858449] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15351.859558] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15351.860668] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15351.861787] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15351.862915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15351.864023] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15351.865121] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15351.866204] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15351.867269] Stack:
[15351.868316]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15351.869381]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15351.870445]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15351.871506] Call Trace:
[15351.872550]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15351.873579]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15351.874582]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15351.875564]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15351.876525]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15351.877469]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15351.878397]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15351.879303]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15351.880192]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15351.881072]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15351.881949]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15351.882818]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15351.883684]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15351.884552]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15351.885416]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15351.886279] Code: c0 3a 1d 00 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[15351.888165] NMI backtrace for cpu 0
[15351.888278] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 38.443 msecs
[15351.889964] CPU: 0 PID: 24440 Comm: trinity-c229 Not tainted 3.18.0+ #107
[15351.891825] task: ffff880240c14470 ti: ffff880095bb4000 task.ti: ffff880095bb4000
[15351.892771] RIP: 0010:[<ffffffff810c6155>]  [<ffffffff810c6155>] lock_release+0xc5/0x240
[15351.893724] RSP: 0018:ffff880095bb7e98  EFLAGS: 00000296
[15351.894666] RAX: ffff880240c14470 RBX: ffff8802236cc380 RCX: 0000000000000360
[15351.895616] RDX: ffff880244e0db60 RSI: 0000000000000000 RDI: ffff880240c14be0
[15351.896562] RBP: ffff880095bb7eb8 R08: 0000000000000000 R09: 0000000000000000
[15351.897507] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c50da0
[15351.898452] R13: ffffffff810961fd R14: 0000000000000296 R15: 0000000000000001
[15351.899401] FS:  00007f9dcd485740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15351.900361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15351.901318] CR2: 0000000000000008 CR3: 000000009afbc000 CR4: 00000000001407f0
[15351.902288] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15351.903254] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15351.904220] Stack:
[15351.905181]  00007f9dcc74d000 00007fffe01fcb90 0000000000000000 0000000000000000
[15351.906167]  ffff880095bb7ee8 ffffffff81096215 ffffffff810961b5 00007fffe01fcb90
[15351.907153]  0000000000000000 000000000000000b ffff880095bb7f78 ffffffff8107ae75
[15351.908147] Call Trace:
[15351.909131]  [<ffffffff81096215>] find_get_pid+0x65/0x80
[15351.910101]  [<ffffffff810961b5>] ? find_get_pid+0x5/0x80
[15351.911051]  [<ffffffff8107ae75>] SyS_wait4+0x55/0x110
[15351.911995]  [<ffffffff8137432e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[15351.912944]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15351.913886] Code: 00 00 4c 89 ea 4c 89 e6 48 89 df e8 26 fc ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 41 56 9d 48 83 c4 08 5b <41> 5c 41 5d 41 5e 41 5f 5d f3 c3 65 ff 04 25 e0 a9 00 00 48 8b 
[15351.915903] NMI backtrace for cpu 3
[15351.915906] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 66.180 msecs
[15351.917854] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0+ #107
[15351.919856] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15351.920877] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15351.921916] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15351.922951] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15351.923981] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15351.925008] RBP: ffff88024372be38 R08: 000000008baf5f56 R09: 0000000000000000
[15351.926027] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15351.927053] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15351.928080] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15351.929111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15351.930133] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15351.931161] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15351.932184] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15351.933197] Stack:
[15351.934198]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15351.935238]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15351.936280]  00000df86c4d4975 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15351.937324] Call Trace:
[15351.938358]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15351.939406]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15351.940448]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15351.941495]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15351.942533] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15351.944799] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 95.053 msecs


[15375.795837] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15375.796930] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15375.802851] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15375.805152] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15375.806342] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15375.807487] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15375.808618] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15375.809753] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15375.810881] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15375.812007] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15375.813131] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15375.814262] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15375.815399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15375.816583] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15375.817716] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15375.818842] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15375.819963] Stack:
[15375.821085]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15375.822227]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15375.823368]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15375.824506] Call Trace:
[15375.825630]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15375.826798]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15375.827930]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15375.829057]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15375.830190]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15375.831320]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15375.832445]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15375.833558]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15375.834647]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15375.835727]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15375.836821]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15375.837883]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15375.838926]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15375.839948]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15375.840965] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15375.843169] sending NMI to other CPUs:
[15375.844211] NMI backtrace for cpu 2
[15375.845266] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15375.847416] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15375.848501] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15375.849601] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15375.850691] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15375.851789] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15375.852887] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15375.853982] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15375.855070] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15375.856156] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15375.857242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15375.858325] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15375.859414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15375.860503] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15375.861585] Stack:
[15375.862664]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15375.863747]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15375.864811]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15375.865862] Call Trace:
[15375.866891]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15375.867913]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15375.868904]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15375.869873]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15375.870823]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15375.871751]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15375.872665]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15375.873561]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15375.874438]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15375.875309]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15375.876176]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15375.877032]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15375.877890]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15375.878743]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15375.879599]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15375.880452] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15375.882317] NMI backtrace for cpu 3
[15375.883194] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15375.885009] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15375.885929] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15375.886858] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15375.887779] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15375.888702] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15375.889621] RBP: ffff88024372be38 R08: 000000008baf5f56 R09: 0000000000000000
[15375.890534] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15375.891446] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15375.892362] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15375.893286] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15375.894208] CR2: 00000000a0d5536f CR3: 0000000001c11000 CR4: 00000000001407e0
[15375.895138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15375.896066] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15375.896990] Stack:
[15375.897914]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15375.898865]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15375.899819]  00000dfe02d03a98 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15375.900772] Call Trace:
[15375.901721]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15375.902675]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15375.903607]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15375.904520]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15375.905430] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15375.907432] NMI backtrace for cpu 0
[15375.908366] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15375.910239] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15375.911180] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15375.912114] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15375.913039] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15375.913969] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15375.914895] RBP: ffffffff81c03e68 R08: 000000008baf5f56 R09: 0000000000000000
[15375.915851] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15375.916776] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15375.917694] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15375.918612] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15375.919528] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15375.920459] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15375.921382] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15375.922294] Stack:
[15375.923199]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15375.924126]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15375.925050]  00000dfe03416b9a ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15375.925994] Call Trace:
[15375.926912]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15375.927843]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15375.928768]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15375.929692]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15375.930613]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15375.931531]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15375.932450]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15375.933364]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15375.934282]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15375.935202]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15375.936136] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15390.907159] INFO: rcu_sched self-detected stall on CPU
[15390.908187] 	1: (1 GPs behind) idle=52b/140000000000001/0 softirq=984789/984790 
[15390.909165] 	 (t=6000 jiffies g=472111 c=472110 q=0)
[15390.910126] Task dump for CPU 1:
[15390.911080] trinity-c195    R  running task    13248 20128  19429 0x0000000c
[15390.912048]  ffff880069c02da0 0000000017646c73 ffff880245003d68 ffffffff810a711c
[15390.913012]  ffffffff810a7082 0000000000000001 0000000000000002 0000000000000001
[15390.913958]  ffffffff81c52300 0000000000000092 ffff880245003d88 ffffffff810ab1cd
[15390.914898] Call Trace:
[15390.915822]  <IRQ>  [<ffffffff810a711c>] sched_show_task+0x11c/0x190
[15390.916767]  [<ffffffff810a7082>] ? sched_show_task+0x82/0x190
[15390.917748]  [<ffffffff810ab1cd>] dump_cpu_task+0x3d/0x50
[15390.918709]  [<ffffffff810d9760>] rcu_dump_cpu_stacks+0x90/0xd0
[15390.919675]  [<ffffffff810e0213>] rcu_check_callbacks+0x503/0x770
[15390.920637]  [<ffffffff8112fadc>] ? acct_account_cputime+0x1c/0x20
[15390.921595]  [<ffffffff810abb07>] ? account_system_time+0x97/0x180
[15390.922549]  [<ffffffff810e5c0b>] update_process_times+0x4b/0x80
[15390.923497]  [<ffffffff810f63a3>] ? tick_sched_timer+0x23/0x1b0
[15390.924449]  [<ffffffff810f63cf>] tick_sched_timer+0x4f/0x1b0
[15390.925402]  [<ffffffff810e6900>] __run_hrtimer+0xa0/0x230
[15390.926350]  [<ffffffff810e6beb>] ? hrtimer_interrupt+0x8b/0x260
[15390.927310]  [<ffffffff810f6380>] ? tick_init_highres+0x20/0x20
[15390.928214]  [<ffffffff810e6c67>] hrtimer_interrupt+0x107/0x260
[15390.929111]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[15390.930006]  [<ffffffff817d0505>] smp_apic_timer_interrupt+0x45/0x60
[15390.930898]  [<ffffffff817ce8ef>] apic_timer_interrupt+0x6f/0x80
[15390.931796]  <EOI>  [<ffffffff810c5cf4>] ? lock_acquire+0xb4/0x120
[15390.932697]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15390.933599]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15390.934483]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15390.935343]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15390.936201]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15390.937050]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15390.937883]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15390.938701]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15390.939505]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15390.940303]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15390.941094]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15390.941893]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15390.942690]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15390.943477]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15390.944276] INFO: rcu_sched detected stalls on CPUs/tasks:
[15390.945074] 	1: (1 GPs behind) idle=52b/140000000000001/0 softirq=984789/984790 
[15390.945854] 	(detected by 0, t=6002 jiffies, g=472111, c=472110, q=0)
[15390.946637] Task dump for CPU 1:
[15390.947442] trinity-c195    R  running task    13248 20128  19429 0x0000000c
[15390.948244]  ffff8801c06dff60 ffffffff817c6eb2 000000000203f56b 0000000017646c73
[15390.949047]  ffffffff813743a4 0000000000000000 00007fffe01fcb40 0000000000000000
[15390.949842]  0000000000000000 0000000000000000 ffff8801c06dff40 ffffffff81077056
[15390.950641] Call Trace:
[15390.951431]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15390.952218]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15390.953006]  [<ffffffff81077056>] ? SyS_clone+0x16/0x20
[15390.953793]  [<ffffffff817cddd9>] ? stub_clone+0x69/0x90
[15390.954582]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15403.789654] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c154:22823]
[15403.790519] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15403.795345] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15403.797194] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15403.798137] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15403.799068] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15403.800047] RAX: 0000000000000008 RBX: ffffffff817ce620 RCX: 0000000000000038
[15403.800987] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15403.801923] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15403.802866] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88009455b8a8
[15403.803780] R13: 0000000000406040 R14: ffff880094558000 R15: ffff880235dedb40
[15403.804720] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15403.805633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15403.806572] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15403.807495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15403.808423] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15403.809361] Stack:
[15403.810339]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15403.811301]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15403.812253]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15403.813215] Call Trace:
[15403.814145]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15403.815102]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15403.816051]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15403.817000]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15403.817966]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15403.818923]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15403.819903]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15403.820853]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15403.821801]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15403.822753]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15403.823711]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15403.824645]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15403.825601]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15403.826536]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15403.827482]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15403.828423] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15403.830537] sending NMI to other CPUs:
[15403.831515] NMI backtrace for cpu 1
[15403.832519] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15403.834564] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15403.835608] RIP: 0010:[<ffffffff810a5d95>]  [<ffffffff810a5d95>] scheduler_tick+0x35/0xe0
[15403.836664] RSP: 0018:ffff880245003e08  EFLAGS: 00000086
[15403.837713] RAX: 0000000000000000 RBX: ffff8802451d2f00 RCX: 0000000000000009
[15403.838768] RDX: 000000000007342f RSI: ffff8802451cc5c0 RDI: ffff8802451ce358
[15403.839816] RBP: ffff880245003e28 R08: 0000000000000000 R09: 0000000000000000
[15403.840866] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15403.841908] R13: 00000000001d2f00 R14: ffff880069c02da0 R15: 00000e2fcb303732
[15403.842944] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15403.843986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15403.845025] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15403.846067] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15403.847105] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15403.848139] Stack:
[15403.849168]  ffff880069c02da0 0000000000000000 0000000000000001 ffff8802451cc880
[15403.850226]  ffff880245003e58 ffffffff810e5c24 ffffffff810f63a3 ffff8802451cce60
[15403.851285]  ffff8801c06dfb08 00000e048872d5bd ffff880245003e98 ffffffff810f63cf
[15403.852339] Call Trace:
[15403.853358]  <IRQ> 

[15403.854360]  [<ffffffff810e5c24>] update_process_times+0x64/0x80
[15403.855339]  [<ffffffff810f63a3>] ? tick_sched_timer+0x23/0x1b0
[15403.856296]  [<ffffffff810f63cf>] tick_sched_timer+0x4f/0x1b0
[15403.857230]  [<ffffffff810e6900>] __run_hrtimer+0xa0/0x230
[15403.858151]  [<ffffffff810e6beb>] ? hrtimer_interrupt+0x8b/0x260
[15403.859055]  [<ffffffff810f6380>] ? tick_init_highres+0x20/0x20
[15403.859937]  [<ffffffff810e6c67>] hrtimer_interrupt+0x107/0x260
[15403.860809]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[15403.861677]  [<ffffffff817d0505>] smp_apic_timer_interrupt+0x45/0x60
[15403.862539]  [<ffffffff817ce8ef>] apic_timer_interrupt+0x6f/0x80
[15403.863404]  <EOI> 

[15403.864270]  [<ffffffff810c5cf4>] ? lock_acquire+0xb4/0x120
[15403.865133]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15403.865999]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15403.866855]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15403.867709]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15403.868551]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15403.869397]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15403.870244]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15403.871090]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15403.871928]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15403.872757]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15403.873581]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15403.874400]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15403.875215]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15403.876034]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15403.876854] Code: 56 41 55 49 c7 c5 00 2f 1d 00 41 54 65 44 8b 24 25 2c a0 00 00 4d 63 e4 53 4c 89 eb 4a 03 1c e5 a0 f0 d1 81 4c 8b b3 50 09 00 00 <e8> 46 5a 00 00 48 89 df e8 fe 6b 72 00 8b b3 88 00 00 00 85 f6 
[15403.878669] NMI backtrace for cpu 0
[15403.879531] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15403.881306] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15403.882213] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15403.883130] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15403.884046] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
[15403.884974] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15403.885895] RBP: ffffffff81c03e68 R08: 000000008baf94ae R09: 0000000000000000
[15403.886819] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000004
[15403.887743] R13: 0000000000000020 R14: 0000000000000003 R15: ffffffff81c00000
[15403.888643] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15403.889530] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15403.890410] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15403.891303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15403.892187] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15403.893049] Stack:
[15403.893886]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000004
[15403.894739]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15403.895587]  00000e048864f135 ffffffff81cb1b38 ffffffff81cb19c0 ffffffff81d213f0
[15403.896437] Call Trace:
[15403.897273]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15403.898118]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15403.898959]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15403.899803]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15403.900634]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15403.901461]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15403.902279]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15403.903098]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15403.903919]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15403.904738]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15403.905542] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15403.907331] NMI backtrace for cpu 3
[15403.908216] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15403.910040] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15403.910967] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15403.911886] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15403.912807] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15403.913741] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15403.914671] RBP: ffff88024372be38 R08: 000000008baf94ae R09: 0000000000000000
[15403.915600] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15403.916530] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15403.917459] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15403.918390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15403.919323] CR2: 00007f3d704ad510 CR3: 0000000001c11000 CR4: 00000000001407e0
[15403.920290] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15403.921227] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15403.922170] Stack:
[15403.923088]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15403.924041]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15403.924999]  00000e048856e4d7 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15403.925963] Call Trace:
[15403.926915]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15403.927880]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15403.928851]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15403.929856]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15403.930814] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15403.932954] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 101.416 msecs
[15431.763416] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15431.764423] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15431.769803] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15431.771905] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15431.772970] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15431.774087] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15431.775164] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15431.776247] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15431.777335] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15431.778416] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15431.779490] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15431.780563] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15431.781650] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15431.782741] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15431.783871] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15431.784955] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15431.786032] Stack:
[15431.787101]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15431.788192]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15431.789284]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15431.790380] Call Trace:
[15431.791470]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15431.792574]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15431.793719]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15431.794824]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15431.795932]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15431.797039]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15431.798144]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15431.799257]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15431.800350]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15431.801415]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15431.802477]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15431.803569]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15431.804612]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15431.805638]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15431.806658] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15431.808871] sending NMI to other CPUs:
[15431.809913] NMI backtrace for cpu 2
[15431.810970] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15431.813123] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15431.814216] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15431.815316] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15431.816408] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15431.817508] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15431.818611] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15431.819708] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15431.820802] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15431.821891] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15431.822984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15431.824070] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15431.825163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15431.826259] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15431.827346] Stack:
[15431.828426]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15431.829512]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15431.830583]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15431.831638] Call Trace:
[15431.832672]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15431.833696]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15431.834691]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15431.835665]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15431.836615]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15431.837546]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15431.838465]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15431.839368]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15431.840247]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15431.841119]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15431.841984]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15431.842844]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15431.843703]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15431.844564]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15431.845423]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15431.846275] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15431.848144] NMI backtrace for cpu 3
[15431.849023] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15431.850835] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15431.851759] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15431.852688] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15431.853609] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15431.854534] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15431.855455] RBP: ffff88024372be38 R08: 000000008baf9453 R09: 0000000000000000
[15431.856371] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15431.857285] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15431.858198] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15431.859119] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15431.860043] CR2: 00007fb66fe8d000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15431.860974] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15431.861900] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15431.862823] Stack:
[15431.863743]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15431.864692]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15431.865643]  00000e0b0cac5a1b ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15431.866597] Call Trace:
[15431.867545]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15431.868502]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15431.869430]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15431.870340]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15431.871248] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15431.873246] NMI backtrace for cpu 0
[15431.874180] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15431.875997] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15431.876912] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15431.877839] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15431.878761] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15431.879690] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15431.880614] RBP: ffffffff81c03e68 R08: 000000008baf9453 R09: 0000000000000000
[15431.881543] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15431.882464] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15431.883404] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15431.884320] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15431.885237] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15431.886166] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15431.887087] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15431.887999] Stack:
[15431.888902]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15431.889827]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15431.890750]  00000e0b0d00864a ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15431.891667] Call Trace:
[15431.892585]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15431.893539]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15431.894459]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15431.895379]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15431.896298]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15431.897213]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15431.898129]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15431.899043]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15431.899956]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15431.900870]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15431.901781] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15455.749491] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15455.750478] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15455.755714] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15455.757759] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15455.758788] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15455.759874] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15455.760911] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15455.761959] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15455.763008] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15455.764058] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15455.765101] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15455.766140] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15455.767184] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15455.768231] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15455.769293] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15455.770388] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15455.771434] Stack:
[15455.772464]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15455.773521]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15455.774595]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15455.775650] Call Trace:
[15455.776695]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15455.777753]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15455.778815]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15455.779897]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15455.780917]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15455.781937]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15455.782953]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15455.783954]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15455.784939]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15455.785912]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15455.786881]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15455.787847]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15455.788813]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15455.789820]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15455.790787] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15455.792887] sending NMI to other CPUs:
[15455.793879] NMI backtrace for cpu 2
[15455.794911] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15455.796992] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15455.798051] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15455.799120] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15455.800181] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15455.801251] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15455.802312] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15455.803370] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15455.804434] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15455.805497] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15455.806568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15455.807644] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15455.808728] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15455.809809] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15455.810889] Stack:
[15455.811962]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15455.813062]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15455.814144]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15455.815201] Call Trace:
[15455.816245]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15455.817277]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15455.818277]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15455.819260]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15455.820220]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15455.821159]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15455.822081]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15455.822985]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15455.823872]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15455.824751]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15455.825624]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15455.826490]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15455.827357]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15455.828223]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15455.829087]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15455.829946] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15455.831821] NMI backtrace for cpu 0
[15455.832705] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15455.834530] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15455.835459] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15455.836393] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15455.837317] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15455.838245] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15455.839167] RBP: ffffffff81c03e68 R08: 000000008baf9406 R09: 0000000000000000
[15455.840088] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15455.841005] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15455.841922] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15455.842846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15455.843771] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15455.844702] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15455.845633] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15455.846557] Stack:
[15455.847479]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15455.848429]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15455.849383]  00000e10a3641194 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15455.850336] Call Trace:
[15455.851281]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15455.852238]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15455.853168]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15455.854074]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15455.854979]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15455.855879]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15455.856777]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15455.857652]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15455.858509]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15455.859360]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15455.860198] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15455.862051] NMI backtrace for cpu 3
[15455.862965] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15455.864827] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15455.865772] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15455.866725] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15455.867666] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15455.868617] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15455.869587] RBP: ffff88024372be38 R08: 000000008baf9406 R09: 0000000000000000
[15455.870547] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15455.871512] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15455.872459] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15455.873402] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15455.874337] CR2: 00007fcb01b8ddc8 CR3: 0000000001c11000 CR4: 00000000001407e0
[15455.875280] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15455.876223] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15455.877167] Stack:
[15455.878099]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15455.879058]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15455.880070]  00000e10a32f62cd ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15455.881036] Call Trace:
[15455.881988]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15455.882958]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15455.883922]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15455.884889]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15455.885855] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15479.735569] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15479.736560] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15479.741807] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15479.743855] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15479.744885] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15479.745974] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15479.747013] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15479.748060] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15479.749108] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15479.750160] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15479.751208] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15479.752252] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15479.753302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15479.754354] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15479.755417] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15479.756512] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15479.757559] Stack:
[15479.758599]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15479.759664]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15479.760720]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15479.761780] Call Trace:
[15479.762833]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15479.763899]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15479.764966]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15479.766079]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15479.767149]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15479.768222]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15479.769292]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15479.770362]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15479.771437]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15479.772489]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15479.773518]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15479.774548]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15479.775590]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15479.776595]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15479.777587] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15479.779714] sending NMI to other CPUs:
[15479.780720] NMI backtrace for cpu 2
[15479.781764] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15479.783889] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15479.784972] RIP: 0010:[<ffffffff810fb22a>]  [<ffffffff810fb22a>] generic_exec_single+0xea/0x1b0
[15479.786068] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15479.787156] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15479.788247] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15479.789336] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15479.790430] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15479.791519] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15479.792602] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15479.793683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15479.794764] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15479.795847] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15479.796924] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15479.797999] Stack:
[15479.799068]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15479.800165]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15479.801246]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15479.802301] Call Trace:
[15479.803339]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15479.804368]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15479.805369]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15479.806347]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15479.807302]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15479.808240]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15479.809161]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15479.810064]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15479.810945]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15479.811823]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15479.812694]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15479.813558]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15479.814420]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15479.815282]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15479.816142]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15479.816999] Code: c0 3a 1d 00 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[15479.818876] NMI backtrace for cpu 0
[15479.819760] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15479.821583] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15479.822511] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15479.823444] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15479.824367] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15479.825295] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15479.826216] RBP: ffffffff81c03e68 R08: 000000008baf93ba R09: 0000000000000000
[15479.827135] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15479.828051] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15479.828966] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15479.829890] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15479.830816] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15479.831748] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15479.832678] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15479.833606] Stack:
[15479.834532]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15479.835483]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15479.836437]  00000e1639f2763b ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15479.837392] Call Trace:
[15479.838340]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15479.839299]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15479.840232]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15479.841143]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15479.842054]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15479.842961]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15479.843859]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15479.844740]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15479.845601]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15479.846457]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15479.847298] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15479.849161] NMI backtrace for cpu 3
[15479.850081] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15479.851956] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15479.852907] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15479.853869] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15479.854814] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15479.855797] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15479.856752] RBP: ffff88024372be38 R08: 000000008baf93ba R09: 0000000000000000
[15479.857706] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15479.858655] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15479.859594] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15479.860536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15479.861477] CR2: 00007fb66fe8d000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15479.862424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15479.863374] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15479.864320] Stack:
[15479.865259]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15479.866246]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15479.867210]  00000e1639b23221 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15479.868181] Call Trace:
[15479.869141]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15479.870115]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15479.871084]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15479.872056]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15479.873024] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15503.721645] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15503.722660] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15503.728065] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15503.730161] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15503.731220] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15503.732323] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15503.733390] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15503.734464] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15503.735538] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15503.736613] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15503.737686] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15503.738753] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15503.739825] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15503.740900] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15503.742025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15503.743107] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15503.744174] Stack:
[15503.745237]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15503.746321]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15503.747402]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15503.748483] Call Trace:
[15503.749558]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15503.750647]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15503.751777]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15503.752869]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15503.753960]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15503.755052]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15503.756141]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15503.757236]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15503.758334]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15503.759408]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15503.760459]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15503.761510]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15503.762592]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15503.763620]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15503.764630] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15503.766839] sending NMI to other CPUs:
[15503.767869] NMI backtrace for cpu 2
[15503.768911] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15503.771029] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15503.772108] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15503.773197] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15503.774278] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15503.775363] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15503.776449] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15503.777541] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15503.778624] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15503.779703] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15503.780783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15503.781859] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15503.782940] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15503.784017] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15503.785088] Stack:
[15503.786155]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15503.787248]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15503.788321]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15503.789368] Call Trace:
[15503.790402]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15503.791424]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15503.792418]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15503.793393]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15503.794348]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15503.795279]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15503.796195]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15503.797090]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15503.797967]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15503.798842]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15503.799708]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15503.800568]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15503.801426]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15503.802284]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15503.803144]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15503.803995] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15503.805861] NMI backtrace for cpu 0
[15503.806741] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15503.808556] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15503.809478] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15503.810409] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15503.811329] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15503.812252] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15503.813170] RBP: ffffffff81c03e68 R08: 000000008baf936d R09: 0000000000000000
[15503.814082] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15503.814996] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15503.815908] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15503.816831] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15503.817751] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15503.818679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15503.819606] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15503.820528] Stack:
[15503.821448]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15503.822395]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15503.823347]  00000e1bd0854ef6 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15503.824298] Call Trace:
[15503.825238]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15503.826192]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15503.827119]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15503.828030]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15503.828933]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15503.829838]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15503.830737]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15503.831615]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15503.832476]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15503.833324]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15503.834162] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15503.836024] NMI backtrace for cpu 3
[15503.836937] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15503.838808] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15503.839754] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15503.840709] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15503.841668] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15503.842628] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15503.843584] RBP: ffff88024372be38 R08: 000000008baf936d R09: 0000000000000000
[15503.844532] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15503.845472] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15503.846410] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15503.847351] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15503.848287] CR2: 00007f3d70900000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15503.849227] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15503.850175] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15503.851116] Stack:
[15503.852075]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15503.853033]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15503.853996]  00000e1bd035579e ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15503.854964] Call Trace:
[15503.855919]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15503.856889]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15503.857856]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15503.858823]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15503.859792] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15527.707724] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15527.708738] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15527.714144] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15527.716239] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15527.717296] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15527.718404] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15527.719467] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15527.720542] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15527.721617] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15527.722698] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15527.723769] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15527.724838] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15527.725913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15527.726988] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15527.728114] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15527.729195] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15527.730264] Stack:
[15527.731329]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15527.732413]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15527.733496]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15527.734579] Call Trace:
[15527.735657]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15527.736745]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15527.737876]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15527.738967]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15527.740061]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15527.741153]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15527.742247]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15527.743341]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15527.744436]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15527.745510]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15527.746561]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15527.747613]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15527.748697]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15527.749728]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15527.750744] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15527.752936] sending NMI to other CPUs:
[15527.753966] NMI backtrace for cpu 2
[15527.755011] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15527.757137] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15527.758219] RIP: 0010:[<ffffffff810fb22a>]  [<ffffffff810fb22a>] generic_exec_single+0xea/0x1b0
[15527.759312] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15527.760398] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15527.761486] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15527.762575] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15527.763669] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15527.764759] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15527.765841] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15527.766922] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15527.768002] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15527.769085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15527.770164] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15527.771239] Stack:
[15527.772311]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15527.773405]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15527.774481]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15527.775537] Call Trace:
[15527.776573]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15527.777602]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15527.778601]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15527.779578]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15527.780533]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15527.781466]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15527.782385]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15527.783286]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15527.784169]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15527.785043]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15527.785910]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15527.786771]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15527.787633]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15527.788494]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15527.789353]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15527.790209] Code: c0 3a 1d 00 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 
[15527.792084] NMI backtrace for cpu 0
[15527.792967] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15527.794790] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15527.795714] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15527.796646] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15527.797567] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15527.798491] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15527.799410] RBP: ffffffff81c03e68 R08: 000000008baf9322 R09: 0000000000000000
[15527.800326] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15527.801238] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15527.802152] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15527.803078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15527.804002] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15527.804932] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15527.805862] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15527.806783] Stack:
[15527.807706]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15527.808654]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15527.809606]  00000e216708a957 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15527.810560] Call Trace:
[15527.811502]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15527.812458]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15527.813387]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15527.814298]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15527.815206]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15527.816111]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15527.817012]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15527.817888]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15527.818748]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15527.819602]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15527.820441] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15527.822303] NMI backtrace for cpu 3
[15527.823217] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15527.825093] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15527.826045] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15527.827004] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15527.827975] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15527.828929] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15527.829884] RBP: ffff88024372be38 R08: 000000008baf9322 R09: 0000000000000000
[15527.830835] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15527.831782] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15527.832725] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15527.833671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15527.834610] CR2: 00007fb66fe8d000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15527.835553] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15527.836504] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15527.837452] Stack:
[15527.838415]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15527.839379]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15527.840346]  00000e2166b83852 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15527.841318] Call Trace:
[15527.842279]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15527.843254]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15527.844223]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15527.845193]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15527.846163] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15551.693803] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
[15551.694820] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15551.700151] CPU: 1 PID: 20128 Comm: trinity-c195 Tainted: G             L 3.18.0+ #107
[15551.702255] task: ffff880069c02da0 ti: ffff8801c06dc000 task.ti: ffff8801c06dc000
[15551.703316] RIP: 0010:[<ffffffff810c5cf4>]  [<ffffffff810c5cf4>] lock_acquire+0xb4/0x120
[15551.704425] RSP: 0018:ffff8801c06dfbb0  EFLAGS: 00000246
[15551.705491] RAX: ffff880069c02da0 RBX: 0000000180140014 RCX: ffff8802451cff98
[15551.706569] RDX: 00000000000015a0 RSI: 0000000000000018 RDI: 0000000000000000
[15551.707645] RBP: ffff8801c06dfc10 R08: 0000000000000000 R09: 0000000000000000
[15551.708722] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c06dfba0
[15551.709794] R13: ffffffff810ab7d5 R14: ffff8801c06dfb20 R15: ffff88024483fc70
[15551.710862] FS:  00007f9dcd485740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15551.711937] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15551.713015] CR2: 0000000001e259f8 CR3: 00000002289f7000 CR4: 00000000001407e0
[15551.714153] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15551.715236] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15551.716311] Stack:
[15551.717374]  ffffffff811a4cc3 ffff880000000000 ffff8801c06dfc10 0000000000000246
[15551.718462]  000000019449eff0 ffff88005e137c38 00000000000000d0 ffff88005e137c20
[15551.719545]  ffff88005e137c38 0000000002422000 ffff8802332eb110 0000000000000000
[15551.720630] Call Trace:
[15551.721706]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15551.722796]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15551.723935]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15551.725027]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15551.726119]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15551.727214]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15551.728307]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15551.729402]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15551.730507]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15551.731572]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15551.732624]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15551.733679]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15551.734760]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15551.735791]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15551.736805] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 65 
[15551.738995] sending NMI to other CPUs:
[15551.740026] NMI backtrace for cpu 2
[15551.741070] CPU: 2 PID: 22823 Comm: trinity-c154 Tainted: G             L 3.18.0+ #107
[15551.743195] task: ffff880235dedb40 ti: ffff880094558000 task.ti: ffff880094558000
[15551.744276] RIP: 0010:[<ffffffff810fb22e>]  [<ffffffff810fb22e>] generic_exec_single+0xee/0x1b0
[15551.745368] RSP: 0000:ffff88009455b938  EFLAGS: 00000202
[15551.746450] RAX: 0000000000000008 RBX: ffff88009455b950 RCX: 0000000000000038
[15551.747536] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[15551.748624] RBP: ffff88009455b998 R08: ffff88024370c3f0 R09: 0000000000000000
[15551.749717] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15551.750805] R13: 0000000000000001 R14: ffff880225e61780 R15: 0000000000000002
[15551.751885] FS:  00007f9dcd485740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15551.752967] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15551.754047] CR2: 0000000001f9cfd8 CR3: 000000009ae2d000 CR4: 00000000001407e0
[15551.755130] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15551.756204] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15551.757280] Stack:
[15551.758349]  ffff88009455b948 0000000000000001 ffff88024370c3f0 0000000000000000
[15551.759443]  ffffffff81048cc0 ffff88009455ba48 0000000000000003 0000000077fab51f
[15551.760518]  0000000000000001 00000000ffffffff 0000000000000001 ffffffff81048cc0
[15551.761574] Call Trace:
[15551.762611]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15551.763634]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15551.764628]  [<ffffffff810fb390>] smp_call_function_single+0x70/0xd0
[15551.765605]  [<ffffffff81048cc0>] ? do_flush_tlb_all+0x60/0x60
[15551.766558]  [<ffffffff810fba89>] smp_call_function_many+0x2b9/0x320
[15551.767490]  [<ffffffff81049010>] flush_tlb_mm_range+0x90/0x1d0
[15551.768408]  [<ffffffff811a1a42>] tlb_flush_mmu_tlbonly+0x42/0x50
[15551.769309]  [<ffffffff811a2fa8>] unmap_single_vma+0x6b8/0x900
[15551.770190]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15551.771068]  [<ffffffff811a34d4>] unmap_mapping_range+0x134/0x190
[15551.771935]  [<ffffffff81191f0d>] shmem_fallocate+0x4fd/0x520
[15551.772795]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15551.773656]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15551.774518]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15551.775378]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15551.776235] Code: 48 89 de 48 03 14 c5 a0 f0 d1 81 48 89 df e8 da de 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 7d d8 65 48 33 3c 25 28 00 00 00 0f 85 98 00 
[15551.778111] NMI backtrace for cpu 0
[15551.778992] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15551.780810] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15551.781738] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15551.782669] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15551.783592] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15551.784519] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15551.785439] RBP: ffffffff81c03e68 R08: 000000008baf92d6 R09: 0000000000000000
[15551.786357] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15551.787273] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15551.788189] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15551.789114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15551.790036] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407f0
[15551.790968] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15551.791900] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15551.792824] Stack:
[15551.793747]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15551.794696]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15551.795650]  00000e26fd8b172b ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15551.796601] Call Trace:
[15551.797546]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15551.798502]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15551.799432]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15551.800343]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15551.801247]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15551.802151]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15551.803050]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15551.803928]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15551.804786]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15551.805637]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15551.806475] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15551.808334] NMI backtrace for cpu 3
[15551.809246] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15551.811116] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15551.812066] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15551.813027] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15551.813992] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15551.814942] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15551.815894] RBP: ffff88024372be38 R08: 000000008baf92d6 R09: 0000000000000000
[15551.816843] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15551.817784] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15551.818718] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15551.819658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15551.820593] CR2: 00007f3d70914008 CR3: 0000000001c11000 CR4: 00000000001407e0
[15551.821533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15551.822478] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15551.823418] Stack:
[15551.824374]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15551.825334]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15551.826295]  00000e26fd3b2c1a ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15551.827258] Call Trace:
[15551.828213]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15551.829182]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15551.830143]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15551.831107]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15551.832072] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15570.852710] INFO: rcu_sched self-detected stall on CPU
[15570.853735] 	1: (1 GPs behind) idle=52b/140000000000001/0 softirq=984789/984790 
[15570.854714] 	 (t=24005 jiffies g=472111 c=472110 q=0)
[15570.855675] Task dump for CPU 1:
[15570.856626] trinity-c195    R  running task    13248 20128  19429 0x0000000c
[15570.857593]  ffff880069c02da0 0000000017646c73 ffff880245003d68 ffffffff810a711c
[15570.858554]  ffffffff810a7082 0000000000000001 0000000000000002 0000000000000001
[15570.859513]  ffffffff81c52300 0000000000000092 ffff880245003d88 ffffffff810ab1cd
[15570.860447] Call Trace:
[15570.861368]  <IRQ>  [<ffffffff810a711c>] sched_show_task+0x11c/0x190
[15570.862309]  [<ffffffff810a7082>] ? sched_show_task+0x82/0x190
[15570.863287]  [<ffffffff810ab1cd>] dump_cpu_task+0x3d/0x50
[15570.864250]  [<ffffffff810d9760>] rcu_dump_cpu_stacks+0x90/0xd0
[15570.865213]  [<ffffffff810e0213>] rcu_check_callbacks+0x503/0x770
[15570.866178]  [<ffffffff8112fadc>] ? acct_account_cputime+0x1c/0x20
[15570.867139]  [<ffffffff810abb07>] ? account_system_time+0x97/0x180
[15570.868092]  [<ffffffff810e5c0b>] update_process_times+0x4b/0x80
[15570.869053]  [<ffffffff810f63a3>] ? tick_sched_timer+0x23/0x1b0
[15570.869997]  [<ffffffff810f63cf>] tick_sched_timer+0x4f/0x1b0
[15570.870951]  [<ffffffff810e6900>] __run_hrtimer+0xa0/0x230
[15570.871901]  [<ffffffff810e6beb>] ? hrtimer_interrupt+0x8b/0x260
[15570.872862]  [<ffffffff810f6380>] ? tick_init_highres+0x20/0x20
[15570.873767]  [<ffffffff810e6c67>] hrtimer_interrupt+0x107/0x260
[15570.874670]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[15570.875569]  [<ffffffff817d0505>] smp_apic_timer_interrupt+0x45/0x60
[15570.876467]  [<ffffffff817ce8ef>] apic_timer_interrupt+0x6f/0x80
[15570.877366]  <EOI>  [<ffffffff810c5cf4>] ? lock_acquire+0xb4/0x120
[15570.878275]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15570.879182]  [<ffffffff817ccadc>] _raw_spin_lock_nested+0x3c/0x80
[15570.880088]  [<ffffffff811a4cc3>] ? copy_page_range+0x493/0xa20
[15570.881000]  [<ffffffff811a4cc3>] copy_page_range+0x493/0xa20
[15570.881911]  [<ffffffff8107648f>] copy_process.part.26+0x146f/0x1a40
[15570.882824]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15570.883732]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15570.884647]  [<ffffffff8109ef5d>] ? finish_task_switch+0x7d/0x120
[15570.885544]  [<ffffffff8109ef1f>] ? finish_task_switch+0x3f/0x120
[15570.886410]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15570.887274]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15570.888136]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15570.888977]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15570.889798]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15570.890616] INFO: rcu_sched detected stalls on CPUs/tasks:
[15570.891487] 	1: (1 GPs behind) idle=52b/140000000000001/0 softirq=984789/984790 
[15570.892485] 	(detected by 2, t=24008 jiffies, g=472111, c=472110, q=0)
[15570.893412] Task dump for CPU 1:
[15570.894307] trinity-c195    R  running task    13248 20128  19429 0x0000000c
[15570.895226]  ffff8801c06dff60 ffffffff817c6eb2 000000000203f56b 0000000017646c73
[15570.896250]  ffffffff813743a4 0000000000000000 00007fffe01fcb40 0000000000000000
[15570.897134]  0000000000000000 0000000000000000 ffff8801c06dff40 ffffffff81077056
[15570.898021] Call Trace:
[15570.898891]  [<ffffffff817c6eb2>] ? __schedule+0x352/0x8c0
[15570.899789]  [<ffffffff813743a4>] ? lockdep_sys_exit_thunk+0x35/0x67
[15570.900688]  [<ffffffff81077056>] ? SyS_clone+0x16/0x20
[15570.901556]  [<ffffffff817cddd9>] ? stub_clone+0x69/0x90
[15570.902430]  [<ffffffff817cda52>] ? system_call_fastpath+0x12/0x17
[15589.522001] sched: RT throttling activated
[15611.669013] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 21s! [trinity-c170:30232]
[15611.669927] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15611.674793] CPU: 1 PID: 30232 Comm: trinity-c170 Tainted: G             L 3.18.0+ #107
[15611.676697] task: ffff880226e70000 ti: ffff8802276e4000 task.ti: ffff8802276e4000
[15611.677659] RIP: 0010:[<ffffffff8118f845>]  [<ffffffff8118f845>] shmem_write_end+0x65/0xf0
[15611.678654] RSP: 0018:ffff8802276e7c08  EFLAGS: 00000202
[15611.679726] RAX: 001ffe0000080005 RBX: ffff8802276e7c80 RCX: 1000ef5abfc6b000
[15611.680754] RDX: 1000ef5abfc6a000 RSI: ffff88009ac54a00 RDI: ffff88020ccd9500
[15611.681797] RBP: ffff8802276e7c28 R08: 0000000000001000 R09: ffffea00011734c0
[15611.682859] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8118ffe4
[15611.683899] R13: ffff8802276e7c18 R14: 0000000000000003 R15: 0000000000000003
[15611.684945] FS:  00007fdf412f4740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15611.686005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15611.687067] CR2: 00007fdf412fb055 CR3: 0000000227d30000 CR4: 00000000001407e0
[15611.688105] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15611.689152] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15611.690228] Stack:
[15611.691283]  1000ef5abfc6a000 0000000000001000 ffff8802276e7d60 0000000000000000
[15611.692367]  ffff8802276e7cc8 ffffffff811754da ffff8802276e7d18 0000000000001000
[15611.693438]  ffff880226e70000 0000000081204df1 0000000003341000 0000000000000000
[15611.694522] Call Trace:
[15611.695606]  [<ffffffff811754da>] generic_perform_write+0x11a/0x1f0
[15611.696694]  [<ffffffff81177bf2>] __generic_file_write_iter+0x162/0x350
[15611.697783]  [<ffffffff811e6d90>] ? new_sync_read+0xd0/0xd0
[15611.698872]  [<ffffffff81177e1f>] generic_file_write_iter+0x3f/0xb0
[15611.699974]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.701062]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15611.702161]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15611.703259]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.704386]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.705488]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15611.706610]  [<ffffffff811e895c>] vfs_writev+0x3c/0x50
[15611.707726]  [<ffffffff811e8acc>] SyS_writev+0x5c/0x100
[15611.708838]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15611.709950] Code: df e8 20 63 fe ff 48 89 df e8 a8 47 ff ff 5b 44 89 e0 41 5c 41 5d 41 5e 5d c3 0f 1f 40 00 41 81 fc ff 0f 00 00 76 0f f0 80 0b 08 <eb> c9 66 0f 1f 84 00 00 00 00 00 81 e2 ff 0f 00 00 46 8d 2c 22 
[15611.712349] sending NMI to other CPUs:
[15611.713501] NMI backtrace for cpu 3
[15611.714511] CPU: 3 PID: 29352 Comm: trinity-c56 Tainted: G             L 3.18.0+ #107
[15611.716572] task: ffff8801c067c470 ti: ffff88017c840000 task.ti: ffff88017c840000
[15611.717621] RIP: 0010:[<ffffffff81372bc5>]  [<ffffffff81372bc5>] copy_user_enhanced_fast_string+0x5/0x10
[15611.718691] RSP: 0018:ffff88017c843c60  EFLAGS: 00010286
[15611.719758] RAX: ffff8801711e0000 RBX: ffff88017c843d60 RCX: 0000000000000fc0
[15611.720830] RDX: 0000000000001000 RSI: ffff8801711e0040 RDI: 00007fdf3fdd67c2
[15611.721900] RBP: ffff88017c843cb8 R08: ffff8801711e0000 R09: ffff88022d82a6d8
[15611.722963] R10: ffff88017c843b88 R11: 0000000000000000 R12: 0000000000001000
[15611.724022] R13: 000000000006c782 R14: ffff880095736ad0 R15: 0000000000001000
[15611.725076] FS:  00007fdf412f4740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15611.726136] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15611.727191] CR2: 00007fdf403eaa16 CR3: 0000000223d4e000 CR4: 00000000001407e0
[15611.728253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15611.729308] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15611.730357] Stack:
[15611.731402]  ffffffff8119f74d ffff8801711e0000 00007fdf3fdd6782 ffff8801711e0000
[15611.732469]  ffffea0005c47800 ffffea0005c47800 000000000008d423 0000000000000000
[15611.733543]  ffff88009ac56820 0000000000001000 0000000000000000 ffff88017c843d48
[15611.734620] Call Trace:
[15611.735681]  [<ffffffff8119f74d>] ? copy_page_to_iter+0x19d/0x340
[15611.736742]  [<ffffffff81190b7b>] shmem_file_read_iter+0xcb/0x300
[15611.737783]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15611.738800]  [<ffffffff811e6cc0>] ? do_sync_readv_writev+0xa0/0xa0
[15611.739797]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15611.740770]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15611.741721]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15611.742657]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15611.743576]  [<ffffffff811e8909>] vfs_readv+0x39/0x50
[15611.744474]  [<ffffffff811e89cc>] SyS_readv+0x5c/0x100
[15611.745359]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15611.746238] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[15611.748165] NMI backtrace for cpu 2
[15611.749082] CPU: 2 PID: 28939 Comm: trinity-c179 Tainted: G             L 3.18.0+ #107
[15611.750987] task: ffff880222f696d0 ti: ffff88019cc6c000 task.ti: ffff88019cc6c000
[15611.751942] RIP: 0010:[<ffffffff81372bc5>]  [<ffffffff81372bc5>] copy_user_enhanced_fast_string+0x5/0x10
[15611.752910] RSP: 0000:ffff88019cc6fbe0  EFLAGS: 00010202
[15611.753867] RAX: 00007fdf3d6bdc01 RBX: 0000000000000000 RCX: 0000000000000880
[15611.754833] RDX: 0000000000001000 RSI: 00007fdf3d6be381 RDI: ffff88011f624780
[15611.755806] RBP: ffff88019cc6fc28 R08: 0000000000000000 R09: 0000000000000001
[15611.756775] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880069dae0a8
[15611.757738] R13: 0000000000001000 R14: 0000000000001000 R15: ffff88011f624000
[15611.758699] FS:  00007fdf412f4740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15611.759671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15611.760632] CR2: 00007fdf400c0727 CR3: 00000001c07a0000 CR4: 00000000001407e0
[15611.761606] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15611.762573] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15611.763535] Stack:
[15611.764491]  ffffffff8119f2e6 ffff88019cc6fbf8 000000000f8c4000 0000000000001000
[15611.765477]  000000000f8c4000 0000000000001000 ffff88019cc6fd60 0000000000000000
[15611.766460]  ffff88009ac57710 ffff88019cc6fcc8 ffffffff811754b7 ffff88019cc6fc88
[15611.767449] Call Trace:
[15611.768424]  [<ffffffff8119f2e6>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[15611.769424]  [<ffffffff811754b7>] generic_perform_write+0xf7/0x1f0
[15611.770420]  [<ffffffff81177bf2>] __generic_file_write_iter+0x162/0x350
[15611.771416]  [<ffffffff811e6d90>] ? new_sync_read+0xd0/0xd0
[15611.772417]  [<ffffffff81177e1f>] generic_file_write_iter+0x3f/0xb0
[15611.773419]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.774405]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15611.775369]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15611.776326]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.777292]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.778248]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15611.779188]  [<ffffffff811e895c>] vfs_writev+0x3c/0x50
[15611.780107]  [<ffffffff811e8acc>] SyS_writev+0x5c/0x100
[15611.781012]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15611.781902] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[15611.783859] NMI backtrace for cpu 0
[15611.784812] CPU: 0 PID: 29177 Comm: trinity-c146 Tainted: G             L 3.18.0+ #107
[15611.786780] task: ffff880095be0000 ti: ffff880223dd8000 task.ti: ffff880223dd8000
[15611.787780] RIP: 0010:[<ffffffff8136b93c>]  [<ffffffff8136b93c>] __radix_tree_create+0x6c/0x220
[15611.788788] RSP: 0000:ffff880223ddba88  EFLAGS: 00000046
[15611.789786] RAX: ffff8800984c7100 RBX: 0000000000000000 RCX: 0000000000000000
[15611.790790] RDX: 0000000000000000 RSI: 000000000008d689 RDI: ffff88009ac56a38
[15611.791801] RBP: ffff880223ddbad8 R08: 0000000000000000 R09: 0000000000000001
[15611.792806] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000fffffffa
[15611.793794] R13: 000000000008d689 R14: ffff88009ac56a38 R15: 0000000000000009
[15611.794770] FS:  00007fdf412f4740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15611.795754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15611.796746] CR2: 00007fdf40250096 CR3: 000000017a9d0000 CR4: 00000000001407f0
[15611.797760] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15611.798765] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15611.799775] Stack:
[15611.800774]  ffff880223ddbaf8 ffff880223ddbaf0 0000000000000002 ffff880223ddbaf8
[15611.801798]  ffff880223ddbaf8 ffffea0008891980 0000000000000000 000000000008d689
[15611.802817]  ffff88009ac56a38 0000000000000000 ffff880223ddbb28 ffffffff8136bb31
[15611.803841] Call Trace:
[15611.804858]  [<ffffffff8136bb31>] radix_tree_insert+0x41/0xf0
[15611.805881]  [<ffffffff8118f798>] shmem_add_to_page_cache+0xf8/0x140
[15611.806908]  [<ffffffff8118ff9c>] shmem_getpage_gfp+0x50c/0x7a0
[15611.807935]  [<ffffffff81190272>] shmem_write_begin+0x42/0x70
[15611.808950]  [<ffffffff81175494>] generic_perform_write+0xd4/0x1f0
[15611.809917]  [<ffffffff81177bf2>] __generic_file_write_iter+0x162/0x350
[15611.810880]  [<ffffffff811e6d90>] ? new_sync_read+0xd0/0xd0
[15611.811838]  [<ffffffff81177e1f>] generic_file_write_iter+0x3f/0xb0
[15611.812779]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.813705]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15611.814616]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15611.815515]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.816418]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15611.817310]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15611.818198]  [<ffffffff811e895c>] vfs_writev+0x3c/0x50
[15611.819090]  [<ffffffff811e8d22>] SyS_pwritev+0xc2/0xf0
[15611.819979]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15611.820859] Code: 12 fa 74 75 45 31 ff 31 c9 eb 28 0f 1f 40 00 44 89 e1 4d 89 ef 41 83 ec 06 49 d3 ef 41 83 e7 3f 83 eb 01 44 89 fa 48 8b 54 d0 28 <74> 52 48 89 c1 48 89 d0 48 85 c0 75 d7 4c 89 f7 48 89 4d c0 e8 
[15611.822791] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 109.285 msecs
[15639.652762] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [rcuos/3:32]
[15639.653833] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15639.659569] CPU: 1 PID: 32 Comm: rcuos/3 Tainted: G             L 3.18.0+ #107
[15639.661870] task: ffff8802437e4470 ti: ffff88024300c000 task.ti: ffff88024300c000
[15639.663045] RIP: 0010:[<ffffffff817ccdf8>]  [<ffffffff817ccdf8>] _raw_spin_unlock_irqrestore+0x38/0x60
[15639.664199] RSP: 0018:ffff88024300fc48  EFLAGS: 00000292
[15639.665344] RAX: 0000000000000001 RBX: ffffffff811cdcd0 RCX: 00000000000002a0
[15639.666499] RDX: ffff88024500d620 RSI: 0000000000000000 RDI: ffff88024483e200
[15639.667656] RBP: ffff88024300fc58 R08: 0000000000000000 R09: ffff8800984a0448
[15639.668811] R10: ffff880243b13840 R11: 0000000000000000 R12: ffff8800984a04f0
[15639.669955] R13: 00000000000000cc R14: ffffffff810135bf R15: ffff88024300fbb8
[15639.671114] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15639.672277] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15639.673431] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15639.674570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15639.675708] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15639.676821] Stack:
[15639.677905]  ffffea0002612800 ffffea0002612800 ffff88024300fd18 ffffffff817c0513
[15639.679014]  ffff88024300fc78 ffffffff810ab7d5 ffff88024300fcf8 ffff8800984a0000
[15639.680119]  0000000000000000 0000000000000292 0000000000000000 0000000100190016
[15639.681210] Call Trace:
[15639.682277]  [<ffffffff817c0513>] __slab_free+0x75/0x317
[15639.683348]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15639.684402]  [<ffffffff81255bcc>] ? proc_i_callback+0x1c/0x20
[15639.685449]  [<ffffffff811d0bee>] kmem_cache_free+0x1ae/0x240
[15639.686495]  [<ffffffff81255bb0>] ? proc_destroy_inode+0x20/0x20
[15639.687538]  [<ffffffff81255bcc>] proc_i_callback+0x1c/0x20
[15639.688590]  [<ffffffff810dd8df>] rcu_nocb_kthread+0x58f/0xd60
[15639.689645]  [<ffffffff810dd62a>] ? rcu_nocb_kthread+0x2da/0xd60
[15639.690670]  [<ffffffff810bcd30>] ? prepare_to_wait_event+0xf0/0xf0
[15639.691706]  [<ffffffff810dd350>] ? rcu_process_callbacks+0x9d0/0x9d0
[15639.692735]  [<ffffffff81098979>] kthread+0xf9/0x110
[15639.693763]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15639.694793]  [<ffffffff81098880>] ? kthread_create_on_node+0x250/0x250
[15639.695817]  [<ffffffff817cd9ac>] ret_from_fork+0x7c/0xb0
[15639.696852]  [<ffffffff81098880>] ? kthread_create_on_node+0x250/0x250
[15639.697866] Code: fc 48 8b 55 08 53 48 8d 7f 18 48 89 f3 be 01 00 00 00 e8 ac 92 8f ff 4c 89 e7 e8 d4 c5 8f ff f6 c7 02 74 17 e8 aa c9 97 ff 53 9d <5b> 65 ff 0c 25 e0 a9 00 00 41 5c 5d c3 0f 1f 00 53 9d e8 91 c8 
[15639.700102] sending NMI to other CPUs:
[15639.701151] NMI backtrace for cpu 3
[15639.702181] CPU: 3 PID: 5935 Comm: trinity-main Tainted: G             L 3.18.0+ #107
[15639.704275] task: ffff880229bbc470 ti: ffff8801b65f4000 task.ti: ffff8801b65f4000
[15639.705341] RIP: 0010:[<ffffffff811cdcf4>]  [<ffffffff811cdcf4>] set_track+0x94/0x140
[15639.706420] RSP: 0018:ffff8801b65f7bd8  EFLAGS: 00000012
[15639.707490] RAX: 000000000000000a RBX: ffff8802288fa228 RCX: ffff8802288fa230
[15639.708570] RDX: 0000000000000010 RSI: 000000000000000f RDI: 00007fffda3ab4c8
[15639.709650] RBP: ffff8801b65f7c08 R08: ffff8801b65f7bd8 R09: 0000000000000000
[15639.710730] R10: ffff88024480e1c0 R11: 0000000000000000 R12: ffffffff811f8726
[15639.711816] R13: ffff8802288f9180 R14: ffff88024483ea00 R15: ffff8801b65f7ca0
[15639.712902] FS:  00007fdd90bc4740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15639.714004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15639.715104] CR2: 0000000000bb4000 CR3: 000000019ce21000 CR4: 00000000001407e0
[15639.716211] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15639.717315] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[15639.718420] Stack:
[15639.719492]  000000100000000a ffff8802288fa230 ffffea0000000000 00000000ff68a7ed
[15639.720572]  ffffea0008a23e00 ffff88024480e1c0 ffff8801b65f7c68 ffffffff817c03cb
[15639.721639]  ffff88009a3a4fd8 ffff88009a3a4fc0 ffff88024480e1c0 ffff88024483ea00
[15639.722694] Call Trace:
[15639.723719]  [<ffffffff817c03cb>] free_debug_processing+0x157/0x22a
[15639.724736]  [<ffffffff817c04f3>] __slab_free+0x55/0x317
[15639.725727]  [<ffffffff811f6fda>] ? path_lookupat+0x7a/0x770
[15639.726696]  [<ffffffff811f8726>] ? final_putname+0x26/0x50
[15639.727641]  [<ffffffff811d0bee>] kmem_cache_free+0x1ae/0x240
[15639.728570]  [<ffffffff811f8726>] final_putname+0x26/0x50
[15639.729478]  [<ffffffff811f89c9>] putname+0x29/0x40
[15639.730366]  [<ffffffff811f97ce>] user_path_at_empty+0x6e/0xc0
[15639.731243]  [<ffffffff811a1ad7>] ? might_fault+0x47/0x50
[15639.732111]  [<ffffffff811ece47>] ? cp_new_stat+0x157/0x190
[15639.732969]  [<ffffffff811f9831>] user_path_at+0x11/0x20
[15639.733827]  [<ffffffff811ec983>] vfs_fstatat+0x63/0xc0
[15639.734682]  [<ffffffff811ecf64>] SYSC_newfstatat+0x24/0x60
[15639.735543]  [<ffffffff81012217>] ? syscall_trace_enter_phase2+0xa7/0x200
[15639.736404]  [<ffffffff811ed1ce>] SyS_newfstatat+0xe/0x10
[15639.737263]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15639.738114] Code: 00 00 e8 c0 58 e4 ff 8b 55 d0 85 d2 0f 85 95 00 00 00 31 d2 0f 1f 00 48 63 f2 83 c2 01 48 c7 44 f3 08 00 00 00 00 83 fa 0f 7e ec <4c> 89 23 65 8b 04 25 2c a0 00 00 89 83 88 00 00 00 65 48 8b 04 
[15639.739992] NMI backtrace for cpu 2
[15639.740889] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #107
[15639.742712] task: ffff88024348c470 ti: ffff88024371c000 task.ti: ffff88024371c000
[15639.743639] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15639.744575] RSP: 0018:ffff88024371fe08  EFLAGS: 00000046
[15639.745502] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[15639.746434] RDX: 0000000000000000 RSI: ffff88024371ffd8 RDI: 0000000000000002
[15639.747365] RBP: ffff88024371fe38 R08: 000000008baf91c6 R09: 0000000000000000
[15639.748300] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[15639.749235] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88024371c000
[15639.750168] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15639.751109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15639.752051] CR2: 0000000000000000 CR3: 0000000240f57000 CR4: 00000000001407e0
[15639.753000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15639.753946] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15639.754884] Stack:
[15639.755819]  000000024371fe38 87ce37a9ab100d43 ffffe8ffff202118 0000000000000002
[15639.756778]  ffffffff81cb19c0 0000000000000002 ffff88024371fe88 ffffffff8165d385
[15639.757741]  00000e3b7b884bf4 ffffffff81cb1a88 ffffffff81cb19c0 ffffffff81d213f0
[15639.758707] Call Trace:
[15639.759662]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15639.760606]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15639.761524]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15639.762440]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15639.763358] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15639.765344] NMI backtrace for cpu 0
[15639.766269] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15639.768133] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15639.769074] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15639.770030] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15639.770979] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15639.771933] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15639.772884] RBP: ffffffff81c03e68 R08: 000000008baf91c6 R09: 0000000000000000
[15639.773827] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15639.774767] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[15639.775699] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15639.776639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15639.777580] CR2: 0000003370219050 CR3: 0000000001c11000 CR4: 00000000001407f0
[15639.778527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15639.779463] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15639.780391] Stack:
[15639.781314]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000005
[15639.782258]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15639.783208]  00000e3b7b79aa5b ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15639.784151] Call Trace:
[15639.785088]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15639.786034]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15639.786978]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15639.787921]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15639.788869]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15639.789815]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15639.790758]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15639.791704]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15639.792649]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15639.793603]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15639.794549] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15667.636533] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c206:14314]
[15667.637609] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15667.643390] CPU: 1 PID: 14314 Comm: trinity-c206 Tainted: G             L 3.18.0+ #107
[15667.645698] task: ffff880227440000 ti: ffff880227c7c000 task.ti: ffff880227c7c000
[15667.646864] RIP: 0010:[<ffffffff81372bc5>]  [<ffffffff81372bc5>] copy_user_enhanced_fast_string+0x5/0x10
[15667.648013] RSP: 0018:ffff880227c7fc60  EFLAGS: 00010286
[15667.649167] RAX: ffff880152231000 RBX: ffffffff81175db2 RCX: 0000000000000fc0
[15667.650341] RDX: 0000000000001000 RSI: ffff880152231040 RDI: 00007fdd8cc56b7f
[15667.651499] RBP: ffff880227c7fcb8 R08: ffff880152231000 R09: ffff8800982fe9f0
[15667.652654] R10: ffff880227c7fb88 R11: 0000000000000000 R12: ffffea0005488c40
[15667.653825] R13: 000100000009cf84 R14: 0000000000000246 R15: ffff880227c7fbf8
[15667.654982] FS:  00007fdd90bc4740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15667.656129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15667.657274] CR2: 00007fdd8f9f58e0 CR3: 0000000224a01000 CR4: 00000000001407e0
[15667.658421] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15667.659556] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[15667.660673] Stack:
[15667.661780]  ffffffff8119f74d ffff880152231000 00007fdd8cc56b3f ffff880152231000
[15667.662915]  ffffea0005488c40 ffffea0005488c40 000100000009cf84 0000000000000000
[15667.664058]  ffff8802252be820 0000000000001000 0000000000000000 ffff880227c7fd48
[15667.665205] Call Trace:
[15667.666336]  [<ffffffff8119f74d>] ? copy_page_to_iter+0x19d/0x340
[15667.667512]  [<ffffffff81190b7b>] shmem_file_read_iter+0xcb/0x300
[15667.668671]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15667.669837]  [<ffffffff811e6cc0>] ? do_sync_readv_writev+0xa0/0xa0
[15667.671003]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15667.672149]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15667.673252]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15667.674329]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15667.675387]  [<ffffffff811e8909>] vfs_readv+0x39/0x50
[15667.676432]  [<ffffffff811e89cc>] SyS_readv+0x5c/0x100
[15667.677537]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15667.678574] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[15667.680846] sending NMI to other CPUs:
[15667.681910] NMI backtrace for cpu 2
[15667.682941] CPU: 2 PID: 15662 Comm: trinity-c188 Tainted: G             L 3.18.0+ #107
[15667.685036] task: ffff8801db9e0000 ti: ffff880226ca8000 task.ti: ffff880226ca8000
[15667.686094] RIP: 0010:[<ffffffff810c44d6>]  [<ffffffff810c44d6>] lock_acquired+0x46/0x370
[15667.687169] RSP: 0018:ffff880226cabdf8  EFLAGS: 00000046
[15667.688244] RAX: 0000000000000001 RBX: ffffffff81c0a080 RCX: ffff8802453cff98
[15667.689324] RDX: 0000000000000680 RSI: ffffffff8107a8d9 RDI: ffffffff81c0a098
[15667.690392] RBP: ffff880226cabe38 R08: 0000000000000000 R09: 0000000000000001
[15667.691464] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801db9e0000
[15667.692532] R13: ffffffff81c0a098 R14: 0000000000000246 R15: ffff8801db9e0000
[15667.693595] FS:  00007fdd90bc4740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15667.694665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15667.695738] CR2: 000000336f1b7740 CR3: 0000000223f31000 CR4: 00000000001407e0
[15667.696820] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15667.697901] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[15667.698977] Stack:
[15667.700049]  0000000125edaea0 ffffffff8107a8d9 ffff8801db9e0000 ffffffff81c0a080
[15667.701151]  ffffffff81c0a098 ffff8801db9e0000 ffff8801db9e0000 ffff8801db9e0000
[15667.702257]  ffff880226cabe68 ffffffff817ccf3d ffffffff8107a8d9 ffff880226cabef8
[15667.703361] Call Trace:
[15667.704456]  [<ffffffff8107a8d9>] ? do_wait+0xd9/0x280
[15667.705539]  [<ffffffff817ccf3d>] _raw_read_lock+0x6d/0x80
[15667.706599]  [<ffffffff8107a8d9>] ? do_wait+0xd9/0x280
[15667.707646]  [<ffffffff8107a8d9>] do_wait+0xd9/0x280
[15667.708669]  [<ffffffff8107aea0>] SyS_wait4+0x80/0x110
[15667.709667]  [<ffffffff81078980>] ? task_stopped_code+0x60/0x60
[15667.710642]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15667.711594] Code: 00 45 85 c9 0f 84 d8 00 00 00 65 4c 8b 24 25 00 aa 00 00 45 8b 84 24 6c 07 00 00 45 85 c0 0f 85 be 00 00 00 49 89 fd 9c 41 5e fa <8b> 35 3c ed aa 01 41 c7 84 24 6c 07 00 00 01 00 00 00 41 8b 9c 
[15667.713623] NMI backtrace for cpu 0
[15667.714570] CPU: 0 PID: 12614 Comm: trinity-c134 Tainted: G             L 3.18.0+ #107
[15667.716458] task: ffff8802254716d0 ti: ffff88009463c000 task.ti: ffff88009463c000
[15667.717406] RIP: 0010:[<ffffffff8136c297>]  [<ffffffff8136c297>] rb_first+0x17/0x30
[15667.718363] RSP: 0018:ffff88009463fd10  EFLAGS: 00000282
[15667.719311] RAX: ffff8801be9e1220 RBX: ffff8800955da020 RCX: ffff8800955da620
[15667.720271] RDX: ffff8801be9e2220 RSI: 0000000000000000 RDI: ffff88009ee6abc8
[15667.721229] RBP: ffff88009463fd10 R08: 0000000000000000 R09: ffff8801beaa8398
[15667.722185] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800955da020
[15667.723129] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800955da620
[15667.724066] FS:  00007fdd90bc4740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15667.725004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15667.725946] CR2: 0000000000e308f0 CR3: 000000007260b000 CR4: 00000000001407f0
[15667.726902] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15667.727844] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[15667.728781] Stack:
[15667.729706]  ffff88009463fd40 ffffffff811a98ea ffff8801beaa83b0 ffff8800955da020
[15667.730658]  ffff8800955da020 ffff88009ee6abc8 ffff88009463fd80 ffffffff811aa413
[15667.731604]  ffff88009463fd70 ffff8800955da000 ffff8801beaa83b0 0000000001200011
[15667.732545] Call Trace:
[15667.733480]  [<ffffffff811a98ea>] validate_mm_rb+0x1a/0x70
[15667.734421]  [<ffffffff811aa413>] __vma_link_rb+0xc3/0x100
[15667.735361]  [<ffffffff81076465>] copy_process.part.26+0x1445/0x1a40
[15667.736305]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15667.737250]  [<ffffffff81076c27>] do_fork+0xe7/0x490
[15667.738191]  [<ffffffff81012217>] ? syscall_trace_enter_phase2+0xa7/0x200
[15667.739138]  [<ffffffff81077056>] SyS_clone+0x16/0x20
[15667.740081]  [<ffffffff817cddd9>] stub_clone+0x69/0x90
[15667.741024]  [<ffffffff817cdc49>] ? tracesys_phase2+0xd4/0xd9
[15667.741969] Code: 31 c0 e8 18 1e 45 00 eb d2 90 90 90 90 90 90 90 90 90 90 90 48 8b 07 55 48 89 e5 48 85 c0 75 07 eb 10 66 90 48 89 d0 48 8b 50 10 <48> 85 d2 75 f4 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 
[15667.743980] NMI backtrace for cpu 3
[15667.744977] CPU: 3 PID: 15728 Comm: trinity-c168 Tainted: G             L 3.18.0+ #107
[15667.747026] task: ffff88009af74470 ti: ffff88022752c000 task.ti: ffff88022752c000
[15667.748038] RIP: 0010:[<ffffffff8117d366>]  [<ffffffff8117d366>] free_pcppages_bulk+0x3c6/0x530
[15667.749008] RSP: 0018:ffff88022752fa98  EFLAGS: 00000087
[15667.749964] RAX: ffffea0006cb6000 RBX: 0000000000000584 RCX: 0000000000000002
[15667.750928] RDX: 00000000ffffff80 RSI: 000000000000000a RDI: 00000000ffffff80
[15667.751884] RBP: ffff88022752fb28 R08: ffffea0006cb6100 R09: ffff88024e5d3ed8
[15667.752845] R10: 0000000000000002 R11: 0000000000000001 R12: 0000000000000580
[15667.753803] R13: 0000000000000002 R14: ffffea0006cb6180 R15: 0000000000000002
[15667.754760] FS:  00007fdd90bc4740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15667.755727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15667.756685] CR2: 0000000000000000 CR3: 0000000223c1b000 CR4: 00000000001407e0
[15667.757649] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15667.758606] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
[15667.759561] Stack:
[15667.760508]  ffff88022752fb18 ffff88024e5d3f40 ffff8802455d7328 0000000900000002
[15667.761476]  0000000000000002 0000000000000586 ffffea0006cb6180 ffff88024e5d3ed8
[15667.762445]  ffffea0006cb6100 000000090000000a ffff8802455d7358 ffff88024e5d3e80
[15667.763410] Call Trace:
[15667.764368]  [<ffffffff8117d7f3>] free_hot_cold_page+0x173/0x1a0
[15667.765331]  [<ffffffff8117d885>] free_hot_cold_page_list+0x65/0xd0
[15667.766290]  [<ffffffff811843ed>] release_pages+0x1bd/0x270
[15667.767252]  [<ffffffff81185423>] __pagevec_release+0x43/0x60
[15667.768213]  [<ffffffff81191430>] shmem_undo_range+0x460/0x710
[15667.769178]  [<ffffffff811916f8>] shmem_truncate_range+0x18/0x40
[15667.770143]  [<ffffffff81191986>] shmem_setattr+0x116/0x1a0
[15667.771107]  [<ffffffff81206a21>] notify_change+0x241/0x390
[15667.772067]  [<ffffffff811e4f25>] do_truncate+0x75/0xc0
[15667.773009]  [<ffffffff811e529a>] ? do_sys_ftruncate.constprop.14+0xda/0x160
[15667.773932]  [<ffffffff811e52cf>] do_sys_ftruncate.constprop.14+0x10f/0x160
[15667.774858]  [<ffffffff811e535e>] SyS_ftruncate+0xe/0x10
[15667.775773]  [<ffffffff817cdc49>] tracesys_phase2+0xd4/0xd9
[15667.776667] Code: 48 c1 e0 06 49 01 c0 41 39 f7 73 24 41 bc 01 00 00 00 41 d3 e4 4d 63 e4 49 31 dc 4c 89 e0 48 29 d8 48 c1 e0 06 4c 01 c0 8b 50 18 <83> fa 80 74 0d 44 89 f9 e9 4d fd ff ff 0f 1f 44 00 00 48 8d 51 
[15695.620295] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c243:22756]
[15695.621317] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15695.626986] CPU: 1 PID: 22756 Comm: trinity-c243 Tainted: G             L 3.18.0+ #107
[15695.629248] task: ffff8801dbac0000 ti: ffff880222ec8000 task.ti: ffff880222ec8000
[15695.630424] RIP: 0010:[<ffffffff81372bc5>]  [<ffffffff81372bc5>] copy_user_enhanced_fast_string+0x5/0x10
[15695.631649] RSP: 0000:ffff880222ecbbe0  EFLAGS: 00010202
[15695.632813] RAX: 00007f5352671e15 RBX: 0000000000000003 RCX: 00000000000003c0
[15695.633981] RDX: 0000000000001000 RSI: 00007f5352672a55 RDI: ffff880022849c40
[15695.635160] RBP: ffff880222ecbc28 R08: 0000000000000000 R09: 0000000000000001
[15695.636360] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff817ccd6b
[15695.637495] R13: ffff880222ecbb68 R14: ffff88007758c6d0 R15: ffff88007758c7f0
[15695.638629] FS:  00007f53535df740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15695.639773] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15695.640919] CR2: 00007f5352440748 CR3: 0000000227cf6000 CR4: 00000000001407e0
[15695.642073] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15695.643247] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15695.644422] Stack:
[15695.645589]  ffffffff8119f2e6 ffff880222ecbbf8 00000000119c1000 0000000000001000
[15695.646776]  00000000119c1000 0000000000001000 ffff880222ecbd60 0000000000000000
[15695.647982]  ffff88007758ca00 ffff880222ecbcc8 ffffffff811754b7 ffff880222ecbc88
[15695.649174] Call Trace:
[15695.650348]  [<ffffffff8119f2e6>] ? iov_iter_copy_from_user_atomic+0x156/0x180
[15695.651487]  [<ffffffff811754b7>] generic_perform_write+0xf7/0x1f0
[15695.652622]  [<ffffffff81177bf2>] __generic_file_write_iter+0x162/0x350
[15695.653748]  [<ffffffff811e6d90>] ? new_sync_read+0xd0/0xd0
[15695.654855]  [<ffffffff81177e1f>] generic_file_write_iter+0x3f/0xb0
[15695.655943]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15695.657028]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15695.658103]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15695.659170]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15695.660255]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15695.661334]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15695.662409]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15695.663490]  [<ffffffff811e895c>] vfs_writev+0x3c/0x50
[15695.664559]  [<ffffffff811e8acc>] SyS_writev+0x5c/0x100
[15695.665610]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15695.666663] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[15695.668947] sending NMI to other CPUs:
[15695.670050] NMI backtrace for cpu 0
[15695.671085] CPU: 0 PID: 24460 Comm: trinity-c223 Tainted: G             L 3.18.0+ #107
[15695.673189] task: ffff88022551db40 ti: ffff88009afa8000 task.ti: ffff88009afa8000
[15695.674252] RIP: 0010:[<ffffffff815f25f2>]  [<ffffffff815f25f2>] xhci_irq+0x42/0x1c70
[15695.675331] RSP: 0018:ffff880244e03dd8  EFLAGS: 00000086
[15695.676404] RAX: 0000000000000008 RBX: ffff8802400bd480 RCX: 0000000000000000
[15695.677487] RDX: ffff880244e0c3c0 RSI: ffff880240298060 RDI: ffff88022551e2b0
[15695.678572] RBP: ffff880244e03e78 R08: 0000000000000000 R09: 0000000000000001
[15695.679657] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000001c
[15695.680744] R13: ffff8800a171dab8 R14: ffff880240298048 R15: ffff880240298000
[15695.681831] FS:  00007f53535df740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15695.682930] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15695.684032] CR2: 00007f53535ada54 CR3: 00000000a1a8c000 CR4: 00000000001407f0
[15695.685141] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15695.686246] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15695.687345] Stack:
[15695.688438]  ffff880244e03de8 ffffffff810ab7d5 ffff880244e03e68 ffffffff810c4e0c
[15695.689541]  ffff880240d05450 0000000000000000 00000000fffe8920 0000000000000046
[15695.690619]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[15695.691688] Call Trace:
[15695.692723]  <IRQ> 

[15695.693742]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15695.694734]  [<ffffffff810c4e0c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15695.695708]  [<ffffffff815f4231>] xhci_msi_irq+0x11/0x20
[15695.696664]  [<ffffffff810cf8f5>] handle_irq_event_percpu+0x55/0x1f0
[15695.697605]  [<ffffffff810cfad1>] handle_irq_event+0x41/0x70
[15695.698524]  [<ffffffff810d2b5e>] ? handle_edge_irq+0x1e/0x140
[15695.699425]  [<ffffffff810d2bbf>] handle_edge_irq+0x7f/0x140
[15695.700311]  [<ffffffff810053a1>] handle_irq+0xb1/0x140
[15695.701189]  [<ffffffff8107a9f1>] ? do_wait+0x1f1/0x280
[15695.702059]  [<ffffffff817d0413>] do_IRQ+0x53/0x100
[15695.702916]  [<ffffffff8107a9f1>] ? do_wait+0x1f1/0x280
[15695.703776]  [<ffffffff817ce56f>] common_interrupt+0x6f/0x6f
[15695.704634]  <EOI> 

[15695.705488]  [<ffffffff810c6150>] ? lock_release+0xc0/0x240
[15695.706335]  [<ffffffff817cd103>] _raw_read_unlock+0x23/0x40
[15695.707179]  [<ffffffff8107a9f1>] do_wait+0x1f1/0x280
[15695.708016]  [<ffffffff8107aea0>] SyS_wait4+0x80/0x110
[15695.708850]  [<ffffffff81078980>] ? task_stopped_code+0x60/0x60
[15695.709689]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15695.710525] Code: ec 78 65 48 8b 04 25 28 00 00 00 48 89 45 c8 31 c0 4c 8b bf d0 03 00 00 4d 8d 77 48 4c 89 f7 e8 b5 a3 1d 00 49 8b 47 18 8b 40 04 <83> f8 ff 0f 84 09 01 00 00 a8 08 0f 84 35 02 00 00 a8 04 0f 85 
[15695.712357] NMI backtrace for cpu 3
[15695.713263] CPU: 3 PID: 21578 Comm: trinity-c97 Tainted: G             L 3.18.0+ #107
[15695.715097] task: ffff88009acc2da0 ti: ffff88019cdf8000 task.ti: ffff88019cdf8000
[15695.716028] RIP: 0010:[<ffffffff81185b7b>]  [<ffffffff81185b7b>] cancel_dirty_page+0xb/0xc0
[15695.716970] RSP: 0018:ffff88019cdfbc40  EFLAGS: 00000246
[15695.717914] RAX: 00000000fffffffb RBX: ffffea0007bfe600 RCX: 0000000000000415
[15695.718861] RDX: ffffea0007bfe600 RSI: 0000000000001000 RDI: ffffea0007bfe600
[15695.719804] RBP: ffff88019cdfbc48 R08: 0000000000000000 R09: ffff88010f861c40
[15695.720746] R10: ffff88019cdfbbd8 R11: 0000000000000000 R12: ffff880227e63040
[15695.721687] R13: ffff88019cdfbd40 R14: 0000000000000000 R15: 0000000000047bc6
[15695.722623] FS:  00007f53535df740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15695.723585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15695.724539] CR2: 000000336f1b7740 CR3: 00000002240c0000 CR4: 00000000001407e0
[15695.725502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15695.726465] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15695.727420] Stack:
[15695.728374]  ffff88019cdfbd40 ffff88019cdfbc68 ffffffff8118609e 0000000000000008
[15695.729334]  ffff88019cdfbcd0 ffff88019cdfbdf8 ffffffff811913f3 ffffea0006fad800
[15695.730268]  ffff880227e62e30 0000000000000000 0000000000000000 0000000000000000
[15695.731203] Call Trace:
[15695.732131]  [<ffffffff8118609e>] truncate_inode_page+0x4e/0x90
[15695.733069]  [<ffffffff811913f3>] shmem_undo_range+0x423/0x710
[15695.733989]  [<ffffffff811916f8>] shmem_truncate_range+0x18/0x40
[15695.734891]  [<ffffffff81191986>] shmem_setattr+0x116/0x1a0
[15695.735787]  [<ffffffff81206a21>] notify_change+0x241/0x390
[15695.736664]  [<ffffffff811e4f25>] do_truncate+0x75/0xc0
[15695.737535]  [<ffffffff811e529a>] ? do_sys_ftruncate.constprop.14+0xda/0x160
[15695.738413]  [<ffffffff811e52cf>] do_sys_ftruncate.constprop.14+0x10f/0x160
[15695.739291]  [<ffffffff8137432e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[15695.740176]  [<ffffffff811e535e>] SyS_ftruncate+0xe/0x10
[15695.741050]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15695.741916] Code: eb d5 be f7 02 00 00 48 c7 c7 a2 cc a6 81 48 89 55 d8 e8 e9 21 ef ff 48 8b 55 d8 e9 4f ff ff ff 0f 1f 44 00 00 55 48 89 e5 41 55 <41> 54 41 89 f4 53 48 83 ec 08 f0 0f ba 37 04 72 14 48 83 c4 08 
[15695.743812] NMI backtrace for cpu 2
[15695.744736] CPU: 2 PID: 24408 Comm: trinity-c238 Tainted: G             L 3.18.0+ #107
[15695.746590] task: ffff880240cd8000 ti: ffff880226d38000 task.ti: ffff880226d38000
[15695.747528] RIP: 0010:[<ffffffff81372bc5>]  [<ffffffff81372bc5>] copy_user_enhanced_fast_string+0x5/0x10
[15695.748479] RSP: 0018:ffff880226d3bc60  EFLAGS: 00010286
[15695.749430] RAX: ffff8800020a1000 RBX: ffff880226d3bd60 RCX: 00000000000009c0
[15695.750385] RDX: 0000000000001000 RSI: ffff8800020a1640 RDI: 00007f5351be001e
[15695.751344] RBP: ffff880226d3bcb8 R08: ffff8800020a1000 R09: ffff8800981a8388
[15695.752303] R10: ffff880226d3bb88 R11: 0000000000000000 R12: 0000000000001000
[15695.753261] R13: 000000000018a9de R14: ffff880094522380 R15: 0000000000001000
[15695.754220] FS:  00007f53535df740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15695.755190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15695.756162] CR2: 00007f53524a684a CR3: 0000000226d63000 CR4: 00000000001407e0
[15695.757142] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15695.758127] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15695.759108] Stack:
[15695.760127]  ffffffff8119f74d ffff8800020a1000 00007f5351bdf9de ffff8800020a1000
[15695.761224]  ffffea0000082840 ffffea00051adc80 0000000000001965 0000000000000000
[15695.762316]  ffff880227e64e60 0000000000001000 0000000000000000 ffff880226d3bd48
[15695.763408] Call Trace:
[15695.764482]  [<ffffffff8119f74d>] ? copy_page_to_iter+0x19d/0x340
[15695.765503]  [<ffffffff81190b7b>] shmem_file_read_iter+0xcb/0x300
[15695.766524]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15695.767542]  [<ffffffff811e6cc0>] ? do_sync_readv_writev+0xa0/0xa0
[15695.768565]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15695.769583]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15695.770606]  [<ffffffff81190ab0>] ? shmem_fault+0x1c0/0x1c0
[15695.771609]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15695.772593]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15695.773598]  [<ffffffff811e8909>] vfs_readv+0x39/0x50
[15695.774616]  [<ffffffff811e8c32>] SyS_preadv+0xc2/0xf0
[15695.775607]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15695.776553] Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
[15723.604074] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-main:773]
[15723.605115] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15723.610645] CPU: 1 PID: 773 Comm: trinity-main Tainted: G             L 3.18.0+ #107
[15723.612819] task: ffff880240c116d0 ti: ffff8800582d4000 task.ti: ffff8800582d4000
[15723.613925] RIP: 0010:[<ffffffff817c0f17>]  [<ffffffff817c0f17>] __slab_alloc+0x52f/0x58f
[15723.615063] RSP: 0018:ffff8800582d7a58  EFLAGS: 00000246
[15723.616174] RAX: 0000000000000001 RBX: ffff88014bc57900 RCX: 00000000000002a0
[15723.617287] RDX: ffff88024500d620 RSI: 0000000000000000 RDI: ffff88024483d600
[15723.618407] RBP: ffff8800582d7b48 R08: 0000000000000000 R09: 0000000000000000
[15723.619522] R10: 0000000000000092 R11: ffff88014bc54f30 R12: ffffffff810135bf
[15723.620632] R13: ffff8800582d79d8 R14: 0000000100190010 R15: ffffffff81202809
[15723.621744] FS:  00007f2495d4c740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15723.622868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15723.623990] CR2: 0000000000e39000 CR3: 0000000094e20000 CR4: 00000000001407e0
[15723.625133] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15723.626265] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15723.627394] Stack:
[15723.628515]  ffff8800582d7a68 ffffffff810ab7d5 ffff8800582d7ae8 ffffffff810c4e0c
[15723.629664]  ffff8800582d7a98 ffffffff810c32ff ffff880240c116d0 0000000000000000
[15723.630811]  ffff8802451d80a0 0000000200000092 ffff8800582d7ad8 ffffffff81202809
[15723.631984] Call Trace:
[15723.633117]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15723.634276]  [<ffffffff810c4e0c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15723.635346]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15723.636425]  [<ffffffff81202809>] ? __d_alloc+0x29/0x1d0
[15723.637510]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15723.638551]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15723.639590]  [<ffffffff81202809>] ? __d_alloc+0x29/0x1d0
[15723.640631]  [<ffffffff811d172b>] kmem_cache_alloc+0x1cb/0x1f0
[15723.641649]  [<ffffffff81202fcf>] ? __d_lookup+0xdf/0x1c0
[15723.642661]  [<ffffffff81202ef5>] ? __d_lookup+0x5/0x1c0
[15723.643670]  [<ffffffff81202809>] __d_alloc+0x29/0x1d0
[15723.644712]  [<ffffffff812029d1>] d_alloc+0x21/0x80
[15723.645731]  [<ffffffff811f217b>] lookup_dcache+0x8b/0xb0
[15723.646734]  [<ffffffff817c128a>] ? lookup_slow+0x38/0xad
[15723.647731]  [<ffffffff811f21cd>] __lookup_hash+0x2d/0x60
[15723.648709]  [<ffffffff817c1299>] lookup_slow+0x47/0xad
[15723.649687]  [<ffffffff811f76a8>] path_lookupat+0x748/0x770
[15723.650669]  [<ffffffff811d1666>] ? kmem_cache_alloc+0x106/0x1f0
[15723.651666]  [<ffffffff811f879f>] ? getname_flags+0x4f/0x1a0
[15723.652634]  [<ffffffff811f76fb>] filename_lookup+0x2b/0xc0
[15723.653603]  [<ffffffff811f97c3>] user_path_at_empty+0x63/0xc0
[15723.654619]  [<ffffffff811a1ad7>] ? might_fault+0x47/0x50
[15723.655582]  [<ffffffff811ece47>] ? cp_new_stat+0x157/0x190
[15723.656540]  [<ffffffff811f9831>] user_path_at+0x11/0x20
[15723.657495]  [<ffffffff811ec983>] vfs_fstatat+0x63/0xc0
[15723.658458]  [<ffffffff811ecf64>] SYSC_newfstatat+0x24/0x60
[15723.659412]  [<ffffffff8137432e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[15723.660354]  [<ffffffff811ed1ce>] SyS_newfstatat+0xe/0x10
[15723.661310]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15723.662268] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 78 ff ff ff 9d e8 9a 87 98 ff 4c 89 e0 eb 0f e8 90 88 98 ff ff b5 78 ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c e8 02 6b 
[15723.664427] sending NMI to other CPUs:
[15723.665416] NMI backtrace for cpu 2
[15723.666409] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #107
[15723.668424] task: ffff88024348c470 ti: ffff88024371c000 task.ti: ffff88024371c000
[15723.669432] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15723.670429] RSP: 0018:ffff88024371fe08  EFLAGS: 00000046
[15723.671412] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[15723.672382] RDX: 0000000000000000 RSI: ffff88024371ffd8 RDI: 0000000000000002
[15723.673330] RBP: ffff88024371fe38 R08: 000000008baf90c8 R09: 0000000000000000
[15723.674260] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[15723.675167] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88024371c000
[15723.676047] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15723.676921] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15723.677771] CR2: 0000000000da6000 CR3: 000000007252c000 CR4: 00000000001407e0
[15723.678613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15723.679446] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15723.680268] Stack:
[15723.681077]  000000024371fe38 87ce37a9ab100d43 ffffe8ffff202118 0000000000000002
[15723.681913]  ffffffff81cb19c0 0000000000000002 ffff88024371fe88 ffffffff8165d385
[15723.682749]  00000e4f0b188364 ffffffff81cb1a88 ffffffff81cb19c0 ffffffff81d213f0
[15723.683590] Call Trace:
[15723.684416]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15723.685247]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15723.686064]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15723.686880]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15723.687697] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15723.689514] NMI backtrace for cpu 0
[15723.690374] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15723.692130] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15723.693019] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15723.693920] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15723.694813] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
[15723.695721] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15723.696616] RBP: ffffffff81c03e68 R08: 000000008baf90c8 R09: 0000000000000000
[15723.697519] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000004
[15723.698420] R13: 0000000000000020 R14: 0000000000000003 R15: ffffffff81c00000
[15723.699315] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15723.700217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15723.701120] CR2: 0000003370219050 CR3: 0000000001c11000 CR4: 00000000001407f0
[15723.702038] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15723.702952] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15723.703863] Stack:
[15723.704771]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000004
[15723.705706]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15723.706649]  00000e4f0b0b0da0 ffffffff81cb1b38 ffffffff81cb19c0 ffffffff81d213f0
[15723.707593] Call Trace:
[15723.708528]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15723.709476]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15723.710415]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15723.711355]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15723.712298]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15723.713241]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15723.714184]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15723.715128]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15723.716070]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15723.717018]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15723.717959] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15723.720020] NMI backtrace for cpu 3
[15723.721025] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15723.723020] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15723.724043] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15723.725069] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15723.726079] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15723.727071] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15723.728051] RBP: ffff88024372be38 R08: 000000008baf90c8 R09: 0000000000000000
[15723.729029] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15723.730028] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880243728000
[15723.731028] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15723.732019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15723.732997] CR2: 0000003370219050 CR3: 0000000001c11000 CR4: 00000000001407e0
[15723.734000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15723.734971] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15723.735943] Stack:
[15723.736901]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000005
[15723.737889]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15723.738904]  00000e4f0b04a497 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15723.739903] Call Trace:
[15723.740880]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15723.741867]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15723.742849]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15723.743828]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15723.744820] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15751.587822] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c127:9822]
[15751.588924] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15751.594608] CPU: 1 PID: 9822 Comm: trinity-c127 Tainted: G             L 3.18.0+ #107
[15751.596824] task: ffff880229bb96d0 ti: ffff8801699f4000 task.ti: ffff8801699f4000
[15751.597973] RIP: 0010:[<ffffffff81117f09>]  [<ffffffff81117f09>] map_id_up+0x9/0x80
[15751.599126] RSP: 0018:ffff8801699f7e78  EFLAGS: 00000246
[15751.600280] RAX: ffff88002394c000 RBX: 0000000000000292 RCX: ffff88022357edb0
[15751.601445] RDX: ffffffff81c48680 RSI: 00000000000003e8 RDI: ffffffff81c41700
[15751.602611] RBP: ffff8801699f7e88 R08: 00007f2495d4c740 R09: 0000000000000001
[15751.603772] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000096
[15751.604933] R13: ffff8801699f7e18 R14: ffff88022fdd3e38 R15: ffff880229bb96d0
[15751.606071] FS:  00007f2495d4c740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15751.607202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15751.608347] CR2: 0000000000639210 CR3: 00000001dbbc4000 CR4: 00000000001407e0
[15751.609502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15751.610645] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15751.611774] Stack:
[15751.612884]  ffff8801699f7e88 ffffffff81117fae ffff8801699f7f68 ffffffff81086dda
[15751.614045]  00007f2495542000 0000000000000000 ffff880229bb9aa0 0000000000000000
[15751.615175]  ffff880100000000 000000000000265e ffff880061283800 00007fffa68babd0
[15751.616317] Call Trace:
[15751.617454]  [<ffffffff81117fae>] ? from_kuid_munged+0xe/0x20
[15751.618617]  [<ffffffff81086dda>] SYSC_kill+0x7a/0x240
[15751.619749]  [<ffffffff8107aeab>] ? SyS_wait4+0x8b/0x110
[15751.620889]  [<ffffffff81088cce>] SyS_kill+0xe/0x10
[15751.622034]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15751.623177] Code: 04 52 5d 03 74 87 08 89 f0 29 c8 c3 8b 47 0c 01 c8 83 e8 01 39 c6 77 a7 31 d2 eb e2 66 0f 1f 44 00 00 0f 1f 44 00 00 55 44 8b 0f <48> 89 e5 45 85 c9 b8 ff ff ff ff 74 3c 8b 4f 08 39 ce 73 4d 48 
[15751.625658] sending NMI to other CPUs:
[15751.626847] NMI backtrace for cpu 0
[15751.627968] CPU: 0 PID: 9692 Comm: trinity-c41 Tainted: G             L 3.18.0+ #107
[15751.630204] task: ffff88020ce1c470 ti: ffff88009acb0000 task.ti: ffff88009acb0000
[15751.631339] RIP: 0010:[<ffffffff810c93c0>]  [<ffffffff810c93c0>] do_raw_spin_unlock+0x0/0xa0
[15751.632467] RSP: 0018:ffff88009acb3b10  EFLAGS: 00000092
[15751.633576] RAX: ffff88020ce1c470 RBX: ffff88009d38f728 RCX: 0000000000002640
[15751.634685] RDX: ffff880244e1cf80 RSI: 0000000000000000 RDI: ffff88009d38f728
[15751.635789] RBP: ffff88009acb3b28 R08: 0000000000000000 R09: 0000000000000001
[15751.636888] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88009d38f710
[15751.637990] R13: 0000000000000000 R14: ffff88009d38f728 R15: 0000000000000000
[15751.639090] FS:  00007f2495d4c740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15751.640201] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15751.641312] CR2: 0000000000000004 CR3: 0000000097156000 CR4: 00000000001407f0
[15751.642424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15751.643531] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15751.644627] Stack:
[15751.645719]  ffffffff817cce4b ffff88009acb3b28 ffffea000820ddc0 ffff88009acb3b68
[15751.646844]  ffffffff8118f783 ffff88009acb3b58 0000000000000003 0000000000000000
[15751.647958]  0000000000000000 ffff88009d38f500 0000000000000000 ffff88009acb3c18
[15751.649070] Call Trace:
[15751.650165]  [<ffffffff817cce4b>] ? _raw_spin_unlock_irq+0x2b/0x40
[15751.651269]  [<ffffffff8118f783>] shmem_add_to_page_cache+0xe3/0x140
[15751.652368]  [<ffffffff8118ff9c>] shmem_getpage_gfp+0x50c/0x7a0
[15751.653456]  [<ffffffff81190272>] shmem_write_begin+0x42/0x70
[15751.654552]  [<ffffffff81175494>] generic_perform_write+0xd4/0x1f0
[15751.655646]  [<ffffffff81177bf2>] __generic_file_write_iter+0x162/0x350
[15751.656742]  [<ffffffff811e6d90>] ? new_sync_read+0xd0/0xd0
[15751.657819]  [<ffffffff81177e1f>] generic_file_write_iter+0x3f/0xb0
[15751.658872]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15751.659919]  [<ffffffff811e6ed8>] do_iter_readv_writev+0x78/0xc0
[15751.660948]  [<ffffffff811e8708>] do_readv_writev+0xd8/0x2a0
[15751.661950]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15751.662938]  [<ffffffff81177de0>] ? __generic_file_write_iter+0x350/0x350
[15751.663898]  [<ffffffff810c32ff>] ? lock_release_holdtime.part.24+0xf/0x190
[15751.664836]  [<ffffffff817cce50>] ? _raw_spin_unlock_irq+0x30/0x40
[15751.665755]  [<ffffffff811e895c>] vfs_writev+0x3c/0x50
[15751.666657]  [<ffffffff811e8acc>] SyS_writev+0x5c/0x100
[15751.667535]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15751.668406] Code: 00 89 d0 f0 66 0f b1 37 66 39 d0 75 e0 b1 01 5d 65 8b 04 25 2c a0 00 00 89 47 08 65 48 8b 04 25 00 aa 00 00 48 89 47 10 89 c8 c3 <0f> 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 81 7f 04 ad 
[15751.670313] NMI backtrace for cpu 3
[15751.671258] CPU: 3 PID: 8780 Comm: trinity-c136 Tainted: G             L 3.18.0+ #107
[15751.673201] task: ffff88009ed316d0 ti: ffff8802333fc000 task.ti: ffff8802333fc000
[15751.674212] RIP: 0010:[<ffffffff81185b90>]  [<ffffffff81185b90>] cancel_dirty_page+0x20/0xc0
[15751.675256] RSP: 0018:ffff8802333ffc30  EFLAGS: 00000296
[15751.676330] RAX: ffffffff81d24160 RBX: ffff88016985bd20 RCX: 0000000000005ed5
[15751.677366] RDX: ffffea0005d7c700 RSI: 0000000000001000 RDI: ffffea0005d7c700
[15751.678392] RBP: ffff8802333ffc48 R08: 0000000000000000 R09: 0000000000000046
[15751.679383] R10: ffff8802333ffbd8 R11: 0000000000000000 R12: 0000000000001000
[15751.680368] R13: ffff8802333ffd40 R14: 0000000000000000 R15: 0000800000129380
[15751.681341] FS:  00007f2495d4c740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15751.682321] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15751.683301] CR2: 00000000ffffff48 CR3: 0000000226fe9000 CR4: 00000000001407e0
[15751.684300] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15751.685278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15751.686254] Stack:
[15751.687221]  ffffea0005d7c700 ffff88016985bd20 ffff8802333ffd40 ffff8802333ffc68
[15751.688225]  ffffffff8118609e 0000000000000009 ffff8802333ffcd0 ffff8802333ffdf8
[15751.689222]  ffffffff811913f3 ffff880243b12f40 ffff88016985bb10 000000eb00000000
[15751.690199] Call Trace:
[15751.691159]  [<ffffffff8118609e>] truncate_inode_page+0x4e/0x90
[15751.692117]  [<ffffffff811913f3>] shmem_undo_range+0x423/0x710
[15751.693078]  [<ffffffff811916f8>] shmem_truncate_range+0x18/0x40
[15751.694033]  [<ffffffff81191986>] shmem_setattr+0x116/0x1a0
[15751.694964]  [<ffffffff81206a21>] notify_change+0x241/0x390
[15751.695880]  [<ffffffff811e4f25>] do_truncate+0x75/0xc0
[15751.696783]  [<ffffffff811e529a>] ? do_sys_ftruncate.constprop.14+0xda/0x160
[15751.697697]  [<ffffffff811e52cf>] do_sys_ftruncate.constprop.14+0x10f/0x160
[15751.698595]  [<ffffffff8137432e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[15751.699490]  [<ffffffff811e5370>] compat_SyS_ftruncate+0x10/0x20
[15751.700403]  [<ffffffff817d0249>] ia32_do_call+0x13/0x13
[15751.701301] Code: ef ff 48 8b 55 d8 e9 4f ff ff ff 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 41 89 f4 53 48 83 ec 08 f0 0f ba 37 04 72 14 48 83 c4 08 <5b> 41 5c 41 5d 5d c3 66 0f 1f 84 00 00 00 00 00 48 8b 5f 08 48 
[15751.703287] NMI backtrace for cpu 2
[15751.704239] CPU: 2 PID: 9809 Comm: trinity-c81 Tainted: G             L 3.18.0+ #107
[15751.706139] task: ffff8802277e0000 ti: ffff880222cb0000 task.ti: ffff880222cb0000
[15751.707119] RIP: 0010:[<ffffffff810c4d22>]  [<ffffffff810c4d22>] __lock_acquire.isra.31+0x142/0x9f0
[15751.708111] RSP: 0018:ffff880222cb3d68  EFLAGS: 00000002
[15751.709102] RAX: 0000000000000000 RBX: ffff8802277e0000 RCX: 0000000000000002
[15751.710083] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81c50da0
[15751.711071] RBP: ffff880222cb3dd8 R08: 0000000000000000 R09: 0000000000000000
[15751.712049] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82596770
[15751.713027] R13: 0000000000000000 R14: ffffffff81c50da0 R15: 0000000000000000
[15751.714017] FS:  00007f2495d4c740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15751.715002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15751.715993] CR2: 0000000000000000 CR3: 000000017cbc0000 CR4: 00000000001407e0
[15751.716989] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15751.717995] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15751.718991] Stack:
[15751.720012]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[15751.721025]  ffff880222cb3d98 ffffffff810ab7d5 ffff880222cb3e18 ffffffff810c4e0c
[15751.722043]  ffff880222cb3db8 0000000000000246 0000000000000000 0000000000000000
[15751.723057] Call Trace:
[15751.724058]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15751.725094]  [<ffffffff810c4e0c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15751.726114]  [<ffffffff810c5cdf>] lock_acquire+0x9f/0x120
[15751.727134]  [<ffffffff81086c95>] ? kill_pid_info+0x5/0xb0
[15751.728178]  [<ffffffff81086cd8>] kill_pid_info+0x48/0xb0
[15751.729197]  [<ffffffff81086c95>] ? kill_pid_info+0x5/0xb0
[15751.730225]  [<ffffffff81086e2c>] SYSC_kill+0xcc/0x240
[15751.731216]  [<ffffffff81086de8>] ? SYSC_kill+0x88/0x240
[15751.732193]  [<ffffffff8107aeab>] ? SyS_wait4+0x8b/0x110
[15751.733174]  [<ffffffff81088cce>] SyS_kill+0xe/0x10
[15751.734133]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15751.735076] Code: 00 00 45 31 ed e9 f3 01 00 00 0f 1f 80 00 00 00 00 44 89 e8 4d 8b 64 c6 08 4d 85 e4 0f 84 21 ff ff ff f0 41 ff 84 24 98 01 00 00 <8b> 3d f0 e4 aa 01 44 8b ab 68 07 00 00 85 ff 75 0a 41 83 fd 2f 
[15751.737141] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 110.288 msecs
[15779.571634] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [swapper/1:0]
[15779.572815] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15779.579104] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.18.0+ #107
[15779.581677] task: ffff8802434896d0 ti: ffff880243714000 task.ti: ffff880243714000
[15779.582931] RIP: 0010:[<ffffffff8165d3a9>]  [<ffffffff8165d3a9>] cpuidle_enter_state+0x79/0x190
[15779.584212] RSP: 0000:ffff880243717e48  EFLAGS: 00000246
[15779.585481] RAX: 00000e5c114d0f5f RBX: ffffffff82bb8048 RCX: 0000000000000019
[15779.586751] RDX: 20c49ba5e353f7cf RSI: 000000000002c480 RDI: 00410b3fa729c634
[15779.588025] RBP: ffff880243717e88 R08: 000000008baf9021 R09: 0000000000000000
[15779.589299] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff810c32ff
[15779.590568] R13: ffff880243717dc8 R14: ffffffff810ab7d5 R15: ffff880243717da8
[15779.591843] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15779.593080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15779.594318] CR2: 0000000000d80c80 CR3: 0000000001c11000 CR4: 00000000001407e0
[15779.595572] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15779.596822] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15779.598066] Stack:
[15779.599304]  00000e5c1132f748 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15779.600571]  ffffe8ffff002118 ffff880243714000 ffffffff81cb19c0 ffff880243714000
[15779.601840]  ffff880243717e98 ffffffff8165d577 ffff880243717f08 ffffffff810bd345
[15779.603062] Call Trace:
[15779.604277]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15779.605482]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15779.606660]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15779.607831] Code: c8 48 89 df ff 50 48 41 89 c5 e8 c3 f7 a8 ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 02 c4 ae ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c0 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[15779.610336] sending NMI to other CPUs:
[15779.611504] NMI backtrace for cpu 0
[15779.612633] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15779.614924] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15779.616088] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15779.617265] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15779.618434] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[15779.619614] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15779.620782] RBP: ffffffff81c03e68 R08: 000000008baf9021 R09: 0000000000000000
[15779.621945] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15779.623100] R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff81c00000
[15779.624258] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15779.625426] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15779.626584] CR2: 00007f249422c269 CR3: 0000000001c11000 CR4: 00000000001407f0
[15779.627747] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15779.628901] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15779.630043] Stack:
[15779.631174]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000001
[15779.632331]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15779.633491]  00000e5c139d54ef ffffffff81cb1a30 ffffffff81cb19c0 ffffffff81d213f0
[15779.634649] Call Trace:
[15779.635799]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15779.636965]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15779.638128]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15779.639291]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15779.640454]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15779.641617]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15779.642783]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15779.643943]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15779.645078]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15779.646196]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15779.647291] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15779.649635] NMI backtrace for cpu 3
[15779.650755] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15779.652899] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15779.653930] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15779.654957] RSP: 0018:ffff88024372be08  EFLAGS: 00000046
[15779.655960] RAX: 0000000000000010 RBX: 0000000000000004 RCX: 0000000000000001
[15779.656955] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15779.657940] RBP: ffff88024372be38 R08: 000000008baf9021 R09: 0000000000000000
[15779.658918] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[15779.659893] R13: 0000000000000010 R14: 0000000000000002 R15: ffff880243728000
[15779.660862] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15779.661833] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15779.662808] CR2: 00007f24941d6269 CR3: 0000000001c11000 CR4: 00000000001407e0
[15779.663797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15779.664768] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15779.665737] Stack:
[15779.666688]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000003
[15779.667667]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15779.668656]  00000e5c1316d5c0 ffffffff81cb1ae0 ffffffff81cb19c0 ffffffff81d213f0
[15779.669642] Call Trace:
[15779.670611]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15779.671604]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15779.672584]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15779.673558]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15779.674526] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15779.676645] NMI backtrace for cpu 2
[15779.677640] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #107
[15779.679625] task: ffff88024348c470 ti: ffff88024371c000 task.ti: ffff88024371c000
[15779.680640] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15779.681674] RSP: 0018:ffff88024371fe08  EFLAGS: 00000046
[15779.682678] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[15779.683669] RDX: 0000000000000000 RSI: ffff88024371ffd8 RDI: 0000000000000002
[15779.684654] RBP: ffff88024371fe38 R08: 000000008baf9021 R09: 0000000000000000
[15779.685629] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[15779.686605] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024371c000
[15779.687581] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15779.688566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15779.689551] CR2: 00000000006ee1e0 CR3: 0000000001c11000 CR4: 00000000001407e0
[15779.690546] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15779.691544] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15779.692532] Stack:
[15779.693514]  000000024371fe38 87ce37a9ab100d43 ffffe8ffff202118 0000000000000005
[15779.694530]  ffffffff81cb19c0 0000000000000002 ffff88024371fe88 ffffffff8165d385
[15779.695552]  00000e5c13171780 ffffffff81cb1b90 ffffffff81cb19c0 ffffffff81d213f0
[15779.696576] Call Trace:
[15779.697590]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15779.698615]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15779.699626]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15779.700624]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15779.701619] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15807.555361] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c35:18287]
[15807.556447] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15807.562334] CPU: 1 PID: 18287 Comm: trinity-c35 Tainted: G             L 3.18.0+ #107
[15807.564718] task: ffff8802252edb40 ti: ffff8802253f0000 task.ti: ffff8802253f0000
[15807.565907] RIP: 0010:[<ffffffff811a30c9>]  [<ffffffff811a30c9>] unmap_single_vma+0x7d9/0x900
[15807.567106] RSP: 0018:ffff8802253f38e8  EFLAGS: 00000286
[15807.568294] RAX: 0000000000000001 RBX: 0000000000000246 RCX: 00000000007d6dc0
[15807.569470] RDX: ffff8800972c1010 RSI: ffff8802253f3ac0 RDI: ffff880223c22000
[15807.570629] RBP: ffff8802253f39d8 R08: 0000000000000000 R09: 0000000000000001
[15807.571790] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802252edb40
[15807.572940] R13: 0000000000000003 R14: 0000000000000246 R15: ffff8802253f38a8
[15807.574084] FS:  00007f1edb7cb740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15807.575239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15807.576412] CR2: 0000000000639058 CR3: 00000001dbb98000 CR4: 00000000001407e0
[15807.577594] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15807.578759] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15807.579916] Stack:
[15807.581064]  00007f1ed9440fff 00007f1ed9440fff ffff88020cfc83d8 ffff8801b64d47f0
[15807.582230]  00007f1ed9441000 00007f1ed9441000 00007f1ed9440fff 00007f1ed9441000
[15807.583396]  ffff8802253f3968 ffff8802253f39a0 ffff8802252edb40 00003ffffffff000
[15807.584565] Call Trace:
[15807.585732]  [<ffffffff811a32ec>] zap_page_range_single+0xfc/0x160
[15807.586897]  [<ffffffff811a3415>] ? unmap_mapping_range+0x75/0x190
[15807.588054]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15807.589203]  [<ffffffff811a3517>] unmap_mapping_range+0x177/0x190
[15807.590353]  [<ffffffff8118607d>] truncate_inode_page+0x2d/0x90
[15807.591490]  [<ffffffff811913f3>] shmem_undo_range+0x423/0x710
[15807.592633]  [<ffffffff811916f8>] shmem_truncate_range+0x18/0x40
[15807.593779]  [<ffffffff81191c47>] shmem_fallocate+0x237/0x520
[15807.594916]  [<ffffffff810bc857>] ? prepare_to_wait+0x27/0x90
[15807.596039]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15807.597135]  [<ffffffff811b79d8>] SyS_madvise+0x398/0x870
[15807.598225]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15807.599315] Code: f7 45 98 00 08 00 00 48 0f 45 c2 49 89 04 24 e9 8b fc ff ff 66 0f 1f 44 00 00 4d 85 f6 0f 84 4e fc ff ff 48 8b 75 a8 48 8b 56 08 <48> 85 d2 74 0a 49 3b 56 08 0f 85 e6 fb ff ff 48 8b 75 a8 48 83 
[15807.601631] sending NMI to other CPUs:
[15807.602717] NMI backtrace for cpu 0
[15807.603771] CPU: 0 PID: 16807 Comm: trinity-c87 Tainted: G             L 3.18.0+ #107
[15807.605890] task: ffff88005e3e16d0 ti: ffff880225c54000 task.ti: ffff880225c54000
[15807.606966] RIP: 0010:[<ffffffff811496a0>]  [<ffffffff811496a0>] trace_hardirqs_off+0x0/0x100
[15807.608063] RSP: 0018:ffff880244e03cc0  EFLAGS: 00000092
[15807.609150] RAX: 0000000000000000 RBX: 0000000000000092 RCX: 0000000000007560
[15807.610243] RDX: ffff880244e3f960 RSI: 0000000000000000 RDI: ffff88023fa7da98
[15807.611329] RBP: ffff880244e03cd8 R08: 0000000000000000 R09: 0000000000000001
[15807.612412] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88023fa7da98
[15807.613498] R13: 0000000000000092 R14: ffff88023fa7da98 R15: ffff880240298000
[15807.614589] FS:  00007f1edb7cb740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15807.615682] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15807.616767] CR2: 00007f1ed9c41000 CR3: 0000000225685000 CR4: 00000000001407f0
[15807.617855] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15807.618938] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15807.620007] Stack:
[15807.621068]  ffffffff817cce0f ffff88023fa7d668 ffff88023fa7da98 ffff880244e03d38
[15807.622157]  ffffffff815fbecd ffff88023fa7da98 ffff88023fa7dcb8 000000203fa7da98
[15807.623246]  ffff88023fa7dbb8 ffff88023fa7da98 ffff88023fa7d668 ffff880240d06aa8
[15807.624334] Call Trace:
[15807.625388]  <IRQ> 

[15807.626421]  [<ffffffff817cce0f>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
[15807.627453]  [<ffffffff815fbecd>] usb_serial_generic_write_start+0x11d/0x200
[15807.628469]  [<ffffffff815fc193>] usb_serial_generic_write_bulk_callback+0x93/0x1b0
[15807.629462]  [<ffffffff815b0542>] __usb_hcd_giveback_urb+0x72/0x120
[15807.630430]  [<ffffffff815b0733>] usb_hcd_giveback_urb+0x43/0x120
[15807.631379]  [<ffffffff815f3203>] xhci_irq+0xc53/0x1c70
[15807.632303]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15807.633212]  [<ffffffff810c4e0c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[15807.634107]  [<ffffffff815f4231>] xhci_msi_irq+0x11/0x20
[15807.634981]  [<ffffffff810cf8f5>] handle_irq_event_percpu+0x55/0x1f0
[15807.635848]  [<ffffffff810cfad1>] handle_irq_event+0x41/0x70
[15807.636708]  [<ffffffff810d2b5e>] ? handle_edge_irq+0x1e/0x140
[15807.637557]  [<ffffffff810d2bbf>] handle_edge_irq+0x7f/0x140
[15807.638404]  [<ffffffff810053a1>] handle_irq+0xb1/0x140
[15807.639247]  [<ffffffff817d0413>] do_IRQ+0x53/0x100
[15807.640085]  [<ffffffff817ce56f>] common_interrupt+0x6f/0x6f
[15807.640927]  <EOI> 

[15807.641761]  [<ffffffff81079bc4>] ? wait_consider_task+0x84/0xcc0
[15807.642588]  [<ffffffff8107a8d9>] ? do_wait+0xd9/0x280
[15807.643412]  [<ffffffff8107a920>] do_wait+0x120/0x280
[15807.644234]  [<ffffffff8107aea0>] SyS_wait4+0x80/0x110
[15807.645064]  [<ffffffff81078980>] ? task_stopped_code+0x60/0x60
[15807.645885]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15807.646697] Code: e8 66 f6 ff ff 4c 8b 4d c8 4a 8b 04 cd a0 f0 d1 81 41 c7 04 06 01 00 00 00 f0 41 ff 0f e9 46 ff ff ff 66 0f 1f 84 00 00 00 00 00 <f6> 05 51 a0 bd 00 02 75 07 c3 66 0f 1f 44 00 00 9c 58 f6 c4 02 
[15807.648500] NMI backtrace for cpu 2
[15807.649383] CPU: 2 PID: 15128 Comm: trinity-c180 Tainted: G             L 3.18.0+ #107
[15807.651182] task: ffff880225dd2da0 ti: ffff88009aed8000 task.ti: ffff88009aed8000
[15807.652102] RIP: 0010:[<ffffffff810c610b>]  [<ffffffff810c610b>] lock_release+0x7b/0x240
[15807.653030] RSP: 0018:ffff88009aedbe10  EFLAGS: 00000046
[15807.653960] RAX: 0000000000000000 RBX: ffff880225dd2da0 RCX: ffff8802266f74d8
[15807.654896] RDX: ffffffff8107a9f1 RSI: 0000000000000000 RDI: 0000000000000001
[15807.655839] RBP: ffff88009aedbe48 R08: 0000000000000000 R09: 0000000000000001
[15807.656782] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c0a098
[15807.657724] R13: ffffffff8107a9f1 R14: 0000000000000296 R15: 0000000000000001
[15807.658669] FS:  00007f1edb7cb740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15807.659626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15807.660583] CR2: 0000000000000001 CR3: 00000000613c7000 CR4: 00000000001407e0
[15807.661526] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15807.662446] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15807.663355] Stack:
[15807.664262]  0000000000000046 ffffffff81c0a098 ffffffff81c0a080 ffff880225dd3108
[15807.665197]  ffff880225dd2da0 ffff880225dd2da0 ffff880225dd2d90 ffff88009aedbe68
[15807.666125]  ffffffff817cd103 ffff880225dd2da0 ffff88009aedbef8 ffff88009aedbee8
[15807.667012] Call Trace:
[15807.667883]  [<ffffffff817cd103>] _raw_read_unlock+0x23/0x40
[15807.668761]  [<ffffffff8107a9f1>] do_wait+0x1f1/0x280
[15807.669630]  [<ffffffff8107aea0>] SyS_wait4+0x80/0x110
[15807.670494]  [<ffffffff81078980>] ? task_stopped_code+0x60/0x60
[15807.671365]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15807.672238] Code: 05 0b cc c3 00 8b 3d 75 6d be 00 65 ff 0c 25 e0 a9 00 00 65 48 8b 1c 25 00 aa 00 00 85 ff 74 3a 8b 35 12 d1 aa 01 85 f6 75 0b 9c <58> f6 c4 02 0f 85 6e 01 00 00 8b 93 68 07 00 00 85 d2 0f 8e 45 
[15807.674141] NMI backtrace for cpu 3
[15807.675053] CPU: 3 PID: 18981 Comm: trinity-c225 Tainted: G             L 3.18.0+ #107
[15807.676970] task: ffff88011c4e0000 ti: ffff880225e94000 task.ti: ffff880225e94000
[15807.677939] RIP: 0010:[<ffffffff810c4dfa>]  [<ffffffff810c4dfa>] __lock_acquire.isra.31+0x21a/0x9f0
[15807.678917] RSP: 0018:ffff880225e97a48  EFLAGS: 00000002
[15807.679875] RAX: 0000000000000008 RBX: ffff88011c4e0000 RCX: 0000000000000000
[15807.680839] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
[15807.681802] RBP: ffff880225e97ab8 R08: 0000000000000001 R09: 0000000000000000
[15807.682757] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000135
[15807.683717] R13: 0000000000000002 R14: ffff88024e5d4398 R15: ffff88011c4e07e0
[15807.684675] FS:  00007f1edb7cb740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15807.685642] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15807.686606] CR2: 00007f1edb72f07c CR3: 0000000229ac5000 CR4: 00000000001407e0
[15807.687579] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15807.688548] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15807.689514] Stack:
[15807.690473]  ffff880225e97ac8 ffffea00087f7440 000000021fdd0000 0000000000000000
[15807.691463]  0000000000000000 000ffe0000000000 ffff880225e97ad8 0000000000000000
[15807.692449]  ffffea0006f59d80 0000000000000046 0000000000000000 0000000000000000
[15807.693433] Call Trace:
[15807.694415]  [<ffffffff810c5cdf>] lock_acquire+0x9f/0x120
[15807.695418]  [<ffffffff81184331>] ? release_pages+0x101/0x270
[15807.696412]  [<ffffffff817ccbe9>] _raw_spin_lock_irqsave+0x49/0x90
[15807.697408]  [<ffffffff81184331>] ? release_pages+0x101/0x270
[15807.698408]  [<ffffffff810ab7d5>] ? local_clock+0x25/0x30
[15807.699404]  [<ffffffff81184331>] release_pages+0x101/0x270
[15807.700406]  [<ffffffff81185423>] __pagevec_release+0x43/0x60
[15807.701396]  [<ffffffff81191430>] shmem_undo_range+0x460/0x710
[15807.702391]  [<ffffffff81191d96>] shmem_fallocate+0x386/0x520
[15807.703386]  [<ffffffff811ea115>] ? __sb_start_write+0x105/0x1c0
[15807.704382]  [<ffffffff811e549c>] ? do_fallocate+0x11c/0x1d0
[15807.705389]  [<ffffffff811e549c>] ? do_fallocate+0x11c/0x1d0
[15807.706377]  [<ffffffff811e54b2>] do_fallocate+0x132/0x1d0
[15807.707346]  [<ffffffff811e5598>] SyS_fallocate+0x48/0x80
[15807.708287]  [<ffffffff817cda52>] system_call_fastpath+0x12/0x17
[15807.709228] Code: e0 7f 44 09 d0 41 88 47 31 41 0f b6 47 32 83 e0 f0 45 85 c0 0f 95 c2 09 c8 c1 e2 03 09 d0 41 88 47 32 0f b7 55 18 41 0f b7 47 32 <c1> e2 04 83 e0 0f 09 d0 66 41 89 47 32 e8 a4 69 fe ff 4c 8b 4d 
[15835.539166] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [swapper/1:0]
[15835.540319] Modules linked in: 8021q garp bridge stp snd_seq_dummy hidp fuse tun rfcomm bnep af_key llc2 can_raw nfnetlink sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep shpchp snd_seq e1000e snd_seq_device ptp pps_core snd_pcm snd_timer snd soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[15835.546410] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.18.0+ #107
[15835.548896] task: ffff8802434896d0 ti: ffff880243714000 task.ti: ffff880243714000
[15835.550154] RIP: 0010:[<ffffffff8165d3a9>]  [<ffffffff8165d3a9>] cpuidle_enter_state+0x79/0x190
[15835.551425] RSP: 0018:ffff880243717e48  EFLAGS: 00000246
[15835.552686] RAX: 00000e691b28f962 RBX: ffffffff82bb8048 RCX: 0000000000000019
[15835.553975] RDX: 20c49ba5e353f7cf RSI: 00000000000276af RDI: 0041352987dbd37c
[15835.555275] RBP: ffff880243717e88 R08: 000000008baf8f7d R09: 0000000000000000
[15835.556557] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff810c32ff
[15835.557841] R13: ffff880243717dc8 R14: ffffffff810ab7d5 R15: ffff880243717da8
[15835.559116] FS:  0000000000000000(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[15835.560378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15835.561620] CR2: 00007f8b7d063000 CR3: 0000000001c11000 CR4: 00000000001407e0
[15835.562868] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15835.564124] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15835.565374] Stack:
[15835.566619]  00000e691a90eefa ffffffff81cb1ae0 ffffffff81cb19c0 ffffffff81d213f0
[15835.567895]  ffffe8ffff002118 ffff880243714000 ffffffff81cb19c0 ffff880243714000
[15835.569155]  ffff880243717e98 ffffffff8165d577 ffff880243717f08 ffffffff810bd345
[15835.570338] Call Trace:
[15835.571508]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15835.572690]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15835.573850]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15835.574978] Code: c8 48 89 df ff 50 48 41 89 c5 e8 c3 f7 a8 ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 02 c4 ae ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c0 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[15835.577402] sending NMI to other CPUs:
[15835.578547] NMI backtrace for cpu 0
[15835.579666] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.18.0+ #107
[15835.581963] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[15835.583133] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15835.584310] RSP: 0018:ffffffff81c03e38  EFLAGS: 00000046
[15835.585475] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[15835.586643] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[15835.587805] RBP: ffffffff81c03e68 R08: 000000008baf8f7d R09: 0000000000000000
[15835.588972] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[15835.590132] R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff81c00000
[15835.591285] FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[15835.592443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15835.593595] CR2: 00000000f0000137 CR3: 0000000001c11000 CR4: 00000000001407f0
[15835.594753] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15835.595903] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15835.597050] Stack:
[15835.598189]  0000000081c03e68 76e04e88cc48b66f ffffe8fffee02118 0000000000000001
[15835.599357]  ffffffff81cb19c0 0000000000000000 ffffffff81c03eb8 ffffffff8165d385
[15835.600530]  00000e691d725867 ffffffff81cb1a30 ffffffff81cb19c0 ffffffff81d213f0
[15835.601707] Call Trace:
[15835.602870]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15835.604053]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15835.605230]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15835.606407]  [<ffffffff817b9639>] rest_init+0xc9/0xd0
[15835.607581]  [<ffffffff817b9575>] ? rest_init+0x5/0xd0
[15835.608761]  [<ffffffff81f21de6>] ? ftrace_init+0xa8/0x13b
[15835.609942]  [<ffffffff81f03041>] start_kernel+0x492/0x4b3
[15835.611123]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[15835.612296]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[15835.613451]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[15835.614573] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15835.616991] NMI backtrace for cpu 3
[15835.618146] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.18.0+ #107
[15835.620322] task: ffff88024348ada0 ti: ffff880243728000 task.ti: ffff880243728000
[15835.621352] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15835.622392] RSP: 0000:ffff88024372be08  EFLAGS: 00000046
[15835.623397] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[15835.624391] RDX: 0000000000000000 RSI: ffff88024372bfd8 RDI: 0000000000000003
[15835.625376] RBP: ffff88024372be38 R08: 000000008baf8f7d R09: 0000000000000000
[15835.626352] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[15835.627324] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880243728000
[15835.628290] FS:  0000000000000000(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[15835.629259] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15835.630229] CR2: 0000000001186ff8 CR3: 0000000094ed2000 CR4: 00000000001407e0
[15835.631206] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15835.632173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15835.633133] Stack:
[15835.634080]  000000034372be38 492161474c69335b ffffe8ffff402118 0000000000000002
[15835.635053]  ffffffff81cb19c0 0000000000000003 ffff88024372be88 ffffffff8165d385
[15835.636035]  00000e691d2afb93 ffffffff81cb1a88 ffffffff81cb19c0 ffffffff81d213f0
[15835.637018] Call Trace:
[15835.637986]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15835.638969]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15835.639942]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15835.640908]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15835.641872] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[15835.643982] NMI backtrace for cpu 2
[15835.644955] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.18.0+ #107
[15835.646877] task: ffff88024348c470 ti: ffff88024371c000 task.ti: ffff88024371c000
[15835.647860] RIP: 0010:[<ffffffff813d4cab>]  [<ffffffff813d4cab>] intel_idle+0xdb/0x180
[15835.648868] RSP: 0018:ffff88024371fe08  EFLAGS: 00000046
[15835.649868] RAX: 0000000000000010 RBX: 0000000000000004 RCX: 0000000000000001
[15835.650828] RDX: 0000000000000000 RSI: ffff88024371ffd8 RDI: ffffffff81c11000
[15835.651782] RBP: ffff88024371fe38 R08: 000000008baf8f7d R09: 0000000000000000
[15835.652734] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[15835.653682] R13: 0000000000000010 R14: 0000000000000002 R15: ffff88024371c000
[15835.654633] FS:  0000000000000000(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[15835.655588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15835.656543] CR2: 000000336f1b7740 CR3: 0000000001c11000 CR4: 00000000001407e0
[15835.657514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15835.658480] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[15835.659460] Stack:
[15835.660403]  000000024371fe38 87ce37a9ab100d43 ffffe8ffff202118 0000000000000003
[15835.661376]  ffffffff81cb19c0 0000000000000002 ffff88024371fe88 ffffffff8165d385
[15835.662354]  00000e691d059748 ffffffff81cb1ae0 ffffffff81cb19c0 ffffffff81d213f0
[15835.663333] Call Trace:
[15835.664296]  [<ffffffff8165d385>] cpuidle_enter_state+0x55/0x190
[15835.665268]  [<ffffffff8165d577>] cpuidle_enter+0x17/0x20
[15835.666239]  [<ffffffff810bd345>] cpu_startup_entry+0x355/0x410
[15835.667202]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230
[15835.668163] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
