Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3FXAVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 20:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3FXAVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 20:21:48 -0400
Date: Sun, 23 Jun 2013 20:21:30 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624002130.GA12811@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
 <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623160452.GA11740@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 06:04:52PM +0200, Oleg Nesterov wrote:

 > > [11018.927809] [sched_delayed] sched: RT throttling activated
 > > [11054.897670] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:14482]
 > > [11054.898503] Modules linked in: bridge stp snd_seq_dummy tun fuse hidp bnep rfcomm can_raw ipt_ULOG can_bcm nfnetlink af_rxrpc llc2 rose caif_socket caif can netrom appletalk af_802154 scsi_transport_iscsi nfc pppoe pppox ppp_generic slhc ipx p8023 psnap p8022 llc ax25 irda crc_ccitt af_key bluetooth rfkill x25 rds atm phonet coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi microcode snd_hda_intel snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc ptp snd_timer pps_core snd soundcore xfs libcrc32c
 > > [11054.905490] irq event stamp: 3857095
 > > [11054.905926] hardirqs last  enabled at (3857094): [<ffffffff816ed9a0>] restore_args+0x0/0x30
 > > [11054.906945] hardirqs last disabled at (3857095): [<ffffffff816f64aa>] apic_timer_interrupt+0x6a/0x80
 > > [11054.908054] softirqs last  enabled at (3856322): [<ffffffff810542e4>] __do_softirq+0x194/0x440
 > > [11054.909102] softirqs last disabled at (3856325): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
 > > [11054.910088] CPU: 2 PID: 14482 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #31
 > > [11054.912900] task: ffff8801ae44ca40 ti: ffff88021fe60000 task.ti: ffff88021fe60000
 > > [11054.913800] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
 > 
 > OK, __do_softirq() again. But this doesn't necessarily mean it
 > is the offender.
 > 
 > Just in case, did you change /proc/sys/kernel/watchdog_thresh ?
 > This times the numbers look different.

I hadn't.  Also before I left this morning, I left the test running on rc7 + your patch
(without that one WARN_ON that was too easily triggered in task_nsproxy).
Extra traces from that below. Still no sign of the printk.

 > Could you please do the following:
 > 
 > 	1. # cd /sys/kernel/debug/tracing
 > 	   # echo 0 >> options/function-trace
 > 	   # echo preemptirqsoff >> current_tracer

rebuilding kernel with that now. I should have results by the morning.

bonus traces below.

	Dave

[24966.306205] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:354]
[24966.307018] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[24966.314143] irq event stamp: 2212169
[24966.314580] hardirqs last  enabled at (2212168): [<ffffffff816eda20>] restore_args+0x0/0x30
[24966.315599] hardirqs last disabled at (2212169): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[24966.316709] softirqs last  enabled at (2211394): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[24966.317758] softirqs last disabled at (2211397): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[24966.318745] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[24966.321517] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[24966.322418] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[24966.323404] RSP: 0018:ffff880244c03f08  EFLAGS: 00000202
[24966.324050] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[24966.324914] RDX: 0000000000000450 RSI: ffff88020d7a07b8 RDI: ffff88020d7a0000
[24966.325777] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[24966.326641] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[24966.327505] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[24966.329319] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[24966.331246] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24966.332900] CR2: 00007f9b1ec28070 CR3: 00000001b0481000 CR4: 00000000001407e0
[24966.334732] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[24966.336555] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24966.338364] Stack:
[24966.339576]  0000000a00406040 000000010025a8e5 ffff880165dfffd8 ffff880165dfffd8
[24966.341487]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[24966.343399]  ffff88020d7a0000 0000000000000000 ffff88023d3023a0 ffff880224986e00
[24966.345315] Call Trace:
[24966.346608]  <IRQ> 

[24966.348033]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[24966.349460]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[24966.351202]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[24966.352904]  <EOI> 

[24966.354328]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[24966.355870]  [<ffffffff811dad2f>] ? sync_inodes_sb+0x19f/0x2a0
[24966.357559]  [<ffffffff811dad28>] ? sync_inodes_sb+0x198/0x2a0
[24966.359235]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[24966.360959]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[24966.362594]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[24966.364296]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[24966.365970]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[24966.367623]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[24966.369199]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[24966.370770] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[24990.292787] BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child2:354]
[24990.294617] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[24990.306017] irq event stamp: 4061851
[24990.307570] hardirqs last  enabled at (4061850): [<ffffffff816eda20>] restore_args+0x0/0x30
[24990.309725] hardirqs last disabled at (4061851): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[24990.311968] softirqs last  enabled at (4061076): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[24990.314152] softirqs last disabled at (4061079): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[24990.316268] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[24990.321369] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[24990.323458] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[24990.325634] RSP: 0018:ffff880244c03f08  EFLAGS: 00000202
[24990.327484] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[24990.329534] RDX: 0000000000000450 RSI: ffff88020d7a07b8 RDI: ffff88020d7a0000
[24990.331589] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[24990.333618] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[24990.335621] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[24990.337605] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[24990.339697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24990.341500] CR2: 0000000000000000 CR3: 00000001b0481000 CR4: 00000000001407e0
[24990.343461] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[24990.345412] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24990.347350] Stack:
[24990.348696]  0000000a00406040 000000010025b245 ffff880165dfffd8 ffff880165dfffd8
[24990.350712]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[24990.352707]  ffff88020d7a0000 0000000000000000 ffff8802361ac630 0000000000000000
[24990.354701] Call Trace:
[24990.356043]  <IRQ> 

[24990.357512]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[24990.358985]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[24990.360771]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[24990.362522]  <EOI> 

[24990.363990]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[24990.365587]  [<ffffffff811dad4a>] ? sync_inodes_sb+0x1ba/0x2a0
[24990.367308]  [<ffffffff811dad28>] ? sync_inodes_sb+0x198/0x2a0
[24990.369020]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[24990.370768]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[24990.372427]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[24990.374160]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[24990.375860]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[24990.377521]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[24990.379105]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[24990.380680] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[25014.249357] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-main:13421]
[25014.249360] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-main:13522]
[25014.249382] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25014.249382] irq event stamp: 6118396
[25014.249387] hardirqs last  enabled at (6118395): [<ffffffff816eda20>] restore_args+0x0/0x30
[25014.249389] hardirqs last disabled at (6118396): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25014.249391] softirqs last  enabled at (6118394): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25014.249393] softirqs last disabled at (6118389): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25014.249396] CPU: 0 PID: 13522 Comm: trinity-main Not tainted 3.10.0-rc7+ #32 
[25014.249397] task: ffff880229e70000 ti: ffff880229c5a000 task.ti: ffff880229c5a000
[25014.249401] RIP: 0010:[<ffffffff81312163>]  [<ffffffff81312163>] do_raw_spin_lock+0xd3/0x130
[25014.249401] RSP: 0018:ffff880229c5bc80  EFLAGS: 00000202
[25014.249402] RAX: ffff880229c5bfd8 RBX: ffffffffffffff10 RCX: 000000000000b910
[25014.249402] RDX: 0000000000002726 RSI: 0000000000000001 RDI: 0000000000000001
[25014.249403] RBP: ffff880229c5bc98 R08: 0000000000000000 R09: 0000000000000000
[25014.249403] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
[25014.249404] R13: 0000000000000015 R14: 000000000000b910 R15: ffff880229c5bfd8
[25014.249405] FS:  00007fe7a0216740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
[25014.249405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25014.249406] CR2: 00007fcc44ab8070 CR3: 000000022f655000 CR4: 00000000001407f0
[25014.249406] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[25014.249407] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25014.249407] Stack:
[25014.249409]  ffffffff81c04640 ffffffff81c04658 ffffffff8181d140 ffff880229c5bcc0
[25014.249410]  ffffffff816ec980 ffffffff811c908b ffff88018ae6b208 ffff88018ae6b3d0
[25014.249412]  ffff880229c5bce8 ffffffff811c908b ffff88018ae6b208 ffff88018ae6b290
[25014.249412] Call Trace:
[25014.249414]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25014.249416]  [<ffffffff811c908b>] ? evict+0x6b/0x1a0
[25014.249417]  [<ffffffff811c908b>] evict+0x6b/0x1a0
[25014.249419]  [<ffffffff811c9a55>] iput+0xf5/0x190
[25014.249421]  [<ffffffff811c50e8>] dput+0x208/0x2f0
[25014.249424]  [<ffffffff81220e96>] proc_flush_task+0xc6/0x1b0
[25014.249425]  [<ffffffff8104eace>] release_task+0xbe/0x690
[25014.249427]  [<ffffffff8104ea29>] ? release_task+0x19/0x690
[25014.249428]  [<ffffffff810508a8>] wait_consider_task+0xb18/0xee0
[25014.249430]  [<ffffffff810503c0>] ? wait_consider_task+0x630/0xee0
[25014.249431]  [<ffffffff81050d70>] do_wait+0x100/0x370
[25014.249433]  [<ffffffff81051414>] SyS_wait4+0x64/0xe0
[25014.249435]  [<ffffffff8104e5e0>] ? task_stopped_code+0x60/0x60
[25014.249436]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25014.249451] Code: 00 00 89 43 08 65 48 8b 04 25 00 ba 00 00 48 89 43 10 5b 41 5c 41 5d 5d c3 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0b 66 39 d0 74 cf <bf> 01 00 00 00 49 83 c4 01 e8 df 79 ff ff 4d 39 ec 0f 84 6e ff 
[25014.309323] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child3:764]
[25014.309344] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25014.309345] irq event stamp: 39760
[25014.309348] hardirqs last  enabled at (39759): [<ffffffff816eda20>] restore_args+0x0/0x30
[25014.309350] hardirqs last disabled at (39760): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25014.309352] softirqs last  enabled at (39758): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25014.309353] softirqs last disabled at (39753): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25014.309356] CPU: 3 PID: 764 Comm: trinity-child3 Not tainted 3.10.0-rc7+ #32 
[25014.309357] task: ffff8801a583a520 ti: ffff88022d0d6000 task.ti: ffff88022d0d6000
[25014.309361] RIP: 0010:[<ffffffff81309c2f>]  [<ffffffff81309c2f>] delay_tsc+0x2f/0xe0
[25014.309361] RSP: 0018:ffff88022d0d7d50  EFLAGS: 00000202
[25014.309362] RAX: 00000000d879b906 RBX: ffffffff816eda20 RCX: 000000000000b910
[25014.309362] RDX: 0000000000003444 RSI: 0000000000000001 RDI: 0000000000000001
[25014.309363] RBP: ffff88022d0d7d78 R08: 0000000000000000 R09: 0000000000000000
[25014.309363] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88022d0d7cc8
[25014.309364] R13: 0000000000000046 R14: ffff88022d0d6000 R15: ffff8801a583a520
[25014.309365] FS:  00007f6a251c7740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[25014.309365] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25014.309366] CR2: 0000000000000001 CR3: 00000001d16b4000 CR4: 00000000001407e0
[25014.309366] DR0: 0000000000ae4000 DR1: 0000000000000000 DR2: 0000000000000000
[25014.309367] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25014.309367] Stack:
[25014.309369]  ffffffff81c04640 000000002abffe8a 0000000088c66b68 0000000000000000
[25014.309370]  ffffffff00000000 ffff88022d0d7d88 ffffffff81309b5f ffff88022d0d7db0
[25014.309371]  ffffffff81312171 ffffffff81c04640 ffffffff81c04658 ffff88023d3023a0
[25014.309372] Call Trace:
[25014.309374]  [<ffffffff81309b5f>] __delay+0xf/0x20
[25014.309376]  [<ffffffff81312171>] do_raw_spin_lock+0xe1/0x130
[25014.309378]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25014.309380]  [<ffffffff811dad04>] ? sync_inodes_sb+0x174/0x2a0
[25014.309382]  [<ffffffff811dad04>] sync_inodes_sb+0x174/0x2a0
[25014.309384]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25014.309387]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25014.309390]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25014.309391]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25014.309393]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25014.309394]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25014.309396]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25014.309410] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 51 78 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
[25014.422967] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25014.434185] irq event stamp: 5462930
[25014.435696] hardirqs last  enabled at (5462929): [<ffffffff816eda20>] restore_args+0x0/0x30
[25014.437815] hardirqs last disabled at (5462930): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25014.440029] softirqs last  enabled at (5462928): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25014.442184] softirqs last disabled at (5462923): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25014.444272] CPU: 1 PID: 13421 Comm: trinity-main Not tainted 3.10.0-rc7+ #32 
[25014.449318] task: ffff880240e2ca40 ti: ffff88022fa9e000 task.ti: ffff88022fa9e000
[25014.451386] RIP: 0010:[<ffffffff81309c2f>]  [<ffffffff81309c2f>] delay_tsc+0x2f/0xe0
[25014.453506] RSP: 0018:ffff88022fa9fb88  EFLAGS: 00000202
[25014.455340] RAX: 00000000d044e152 RBX: 0000000000000000 RCX: 000000000000b910
[25014.457405] RDX: 0000000000003444 RSI: 0000000000000001 RDI: 0000000000000001
[25014.459454] RBP: ffff88022fa9fbb0 R08: 0000000000000000 R09: 0000000000000000
[25014.461510] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[25014.463531] R13: 0000000000000001 R14: ffffffff8130afce R15: ffff88022fa9fbc0
[25014.465529] FS:  00007f6a251c7740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
[25014.467637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25014.469461] CR2: 0000003850a74cf0 CR3: 000000023b828000 CR4: 00000000001407e0
[25014.471431] DR0: 0000000002015000 DR1: 0000000000000000 DR2: 0000000000000000
[25014.473371] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25014.475280] Stack:
[25014.476570]  ffffffff81c04640 000000002a9da73e 0000000088c66b68 ffffffff8181d140
[25014.478549]  ffff88014d45c000 ffff88022fa9fbc0 ffffffff81309b5f ffff88022fa9fbe8
[25014.480522]  ffffffff81312171 ffffffff81c04640 ffffffff81c04658 ffffffff8181d140
[25014.482498] Call Trace:
[25014.483853]  [<ffffffff81309b5f>] __delay+0xf/0x20
[25014.485465]  [<ffffffff81312171>] do_raw_spin_lock+0xe1/0x130
[25014.487195]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25014.488856]  [<ffffffff811c908b>] ? evict+0x6b/0x1a0
[25014.490448]  [<ffffffff811c908b>] evict+0x6b/0x1a0
[25014.492003]  [<ffffffff811c9a55>] iput+0xf5/0x190
[25014.493541]  [<ffffffff811c5c88>] shrink_dentry_list+0x4a8/0x600
[25014.495243]  [<ffffffff811c57e5>] ? shrink_dentry_list+0x5/0x600
[25014.496934]  [<ffffffff811c60e6>] shrink_dcache_parent+0x266/0x300
[25014.498655]  [<ffffffff81220e86>] proc_flush_task+0xb6/0x1b0
[25014.500308]  [<ffffffff8104eace>] release_task+0xbe/0x690
[25014.501924]  [<ffffffff8104ea29>] ? release_task+0x19/0x690
[25014.503557]  [<ffffffff810508a8>] wait_consider_task+0xb18/0xee0
[25014.505230]  [<ffffffff810503c0>] ? wait_consider_task+0x630/0xee0
[25014.506937]  [<ffffffff81050d70>] do_wait+0x100/0x370
[25014.508501]  [<ffffffff81051414>] SyS_wait4+0x64/0xe0
[25014.510064]  [<ffffffff8104e5e0>] ? task_stopped_code+0x60/0x60
[25014.511720]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25014.513261] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 51 78 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
[25018.277105] BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child2:354]
[25018.278898] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25018.290239] irq event stamp: 6233275
[25018.291784] hardirqs last  enabled at (6233274): [<ffffffff816eda20>] restore_args+0x0/0x30
[25018.293927] hardirqs last disabled at (6233275): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25018.296166] softirqs last  enabled at (6232502): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25018.298341] softirqs last disabled at (6232505): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25018.300465] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[25018.305556] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[25018.307628] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[25018.309774] RSP: 0018:ffff880244c03f08  EFLAGS: 00000202
[25018.311559] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[25018.313539] RDX: 00000000000031b0 RSI: ffff88020d7a07f0 RDI: ffff88020d7a0000
[25018.315494] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[25018.317427] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[25018.319343] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[25018.321247] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[25018.323282] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25018.325044] CR2: 00007f7117e6eaf0 CR3: 00000001b0481000 CR4: 00000000001407e0
[25018.326966] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[25018.328874] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25018.330758] Stack:
[25018.332025]  0000000a00406040 000000010025bd35 ffff880165dfffd8 ffff880165dfffd8
[25018.333971]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[25018.335906]  ffff88020d7a0000 0000000000000000 0000000000000000 0000000000000002
[25018.337851] Call Trace:
[25018.339170]  <IRQ> 

[25018.340624]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25018.342091]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[25018.343872]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[25018.345608]  <EOI> 

[25018.347056]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[25018.348615]  [<ffffffff810b9da6>] ? lock_acquire+0xa6/0x1f0
[25018.350295]  [<ffffffff811dad52>] ? sync_inodes_sb+0x1c2/0x2a0
[25018.352004]  [<ffffffff816ec960>] _raw_spin_lock+0x40/0x80
[25018.353665]  [<ffffffff811dad52>] ? sync_inodes_sb+0x1c2/0x2a0
[25018.355363]  [<ffffffff811dad52>] sync_inodes_sb+0x1c2/0x2a0
[25018.357024]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25018.358756]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25018.360399]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25018.362093]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25018.363769]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25018.365416]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25018.366992]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25018.368570] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[25042.263653] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:354]
[25042.265498] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25042.277003] irq event stamp: 8090805
[25042.278588] hardirqs last  enabled at (8090804): [<ffffffff816eda20>] restore_args+0x0/0x30
[25042.280769] hardirqs last disabled at (8090805): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25042.283040] softirqs last  enabled at (8090032): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25042.285263] softirqs last disabled at (8090035): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25042.287422] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[25042.292564] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[25042.293647] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child1:785]
[25042.293670] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25042.293670] irq event stamp: 28128
[25042.293675] hardirqs last  enabled at (28127): [<ffffffff816eda20>] restore_args+0x0/0x30
[25042.293677] hardirqs last disabled at (28128): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25042.293679] softirqs last  enabled at (28126): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25042.293681] softirqs last disabled at (28121): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25042.293683] CPU: 3 PID: 785 Comm: trinity-child1 Not tainted 3.10.0-rc7+ #32 
[25042.293685] task: ffff88017f254a40 ti: ffff880189b9a000 task.ti: ffff880189b9a000
[25042.293689] RIP: 0010:[<ffffffff81313b0c>]  [<ffffffff81313b0c>] debug_smp_processor_id+0x1c/0xf0
[25042.293689] RSP: 0018:ffff880189b9baf0  EFLAGS: 00000297
[25042.293690] RAX: 0000000000000002 RBX: ffff880189b9ba78 RCX: 000000000000b910
[25042.293690] RDX: 0000000000004140 RSI: 0000000000000001 RDI: 0000000000000001
[25042.293691] RBP: ffff880189b9baf8 R08: 0000000000000000 R09: 0000000000000000
[25042.293691] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880189b9a000
[25042.293692] R13: ffff88017f254a40 R14: 0000000000000000 R15: 0000000000000000
[25042.293693] FS:  00007fe7a0216740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[25042.293693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25042.293694] CR2: 0000003850ae6500 CR3: 00000002416fb000 CR4: 00000000001407e0
[25042.293694] DR0: 0000000000ae4000 DR1: 0000000000000000 DR2: 0000000000000000
[25042.293695] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25042.293695] Stack:
[25042.293697]  ffffffff81c04640 ffff880189b9bb30 ffffffff81309c24 ffffffff81c04640
[25042.293698]  000000002a9962a7 0000000088c66b68 0000000000000311 0000000000000000
[25042.293700]  ffff880189b9bb40 ffffffff81309b5f ffff880189b9bb68 ffffffff81312171
[25042.293700] Call Trace:
[25042.293703]  [<ffffffff81309c24>] delay_tsc+0x24/0xe0
[25042.293705]  [<ffffffff81309b5f>] __delay+0xf/0x20
[25042.293707]  [<ffffffff81312171>] do_raw_spin_lock+0xe1/0x130
[25042.293710]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25042.293712]  [<ffffffff811c7dc9>] ? inode_sb_list_add+0x19/0x50
[25042.293713]  [<ffffffff811c7dc9>] inode_sb_list_add+0x19/0x50
[25042.293715]  [<ffffffff811ca409>] new_inode+0x29/0x30
[25042.293717]  [<ffffffff8121f58f>] proc_pid_make_inode+0x1f/0x250
[25042.293719]  [<ffffffff8121f7db>] proc_pid_instantiate+0x1b/0xd0
[25042.293721]  [<ffffffff812210bc>] proc_pid_lookup+0x13c/0x200
[25042.293722]  [<ffffffff8122100e>] ? proc_pid_lookup+0x8e/0x200
[25042.293724]  [<ffffffff8121b52f>] proc_root_lookup+0x2f/0x40
[25042.293726]  [<ffffffff811b77dd>] lookup_real+0x1d/0x50
[25042.293727]  [<ffffffff811b7dd3>] __lookup_hash+0x33/0x40
[25042.293730]  [<ffffffff816e36b5>] lookup_slow+0x44/0xa9
[25042.293731]  [<ffffffff811ba453>] link_path_walk+0x733/0x900
[25042.293733]  [<ffffffff811bd704>] path_openat+0x94/0x530
[25042.293736]  [<ffffffff8100a384>] ? native_sched_clock+0x24/0x80
[25042.293739]  [<ffffffff81091db5>] ? sched_clock_cpu+0xb5/0x100
[25042.293741]  [<ffffffff81091db5>] ? sched_clock_cpu+0xb5/0x100
[25042.293742]  [<ffffffff811be228>] do_filp_open+0x38/0x80
[25042.293744]  [<ffffffff816eccf1>] ? _raw_spin_unlock+0x31/0x60
[25042.293745]  [<ffffffff811ccd7f>] ? __alloc_fd+0xaf/0x200
[25042.293747]  [<ffffffff811ac669>] do_sys_open+0xe9/0x1c0
[25042.293749]  [<ffffffff811ac75e>] SyS_open+0x1e/0x20
[25042.293750]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25042.293765] Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 66 90 55 48 89 e5 53 65 48 8b 04 25 f0 b9 00 00 8b 80 44 e0 ff ff 65 8b 1c 25 1c b0 00 00 <85> c0 74 05 89 d8 5b 5d c3 9c 58 f6 c4 02 74 f4 89 d8 8b 15 c4 
[25042.408673] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[25042.410647] RSP: 0018:ffff880244c03f08  EFLAGS: 00000206
[25042.412286] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[25042.414133] RDX: 0000000000000450 RSI: ffff88020d7a07b8 RDI: ffff88020d7a0000
[25042.415957] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[25042.417765] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[25042.419569] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[25042.421352] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[25042.423233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25042.424814] CR2: 00007f711c934088 CR3: 00000001b0481000 CR4: 00000000001407e0
[25042.426540] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[25042.428252] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25042.429950] Stack:
[25042.431040]  0000000a00406040 000000010025c695 ffff880165dfffd8 ffff880165dfffd8
[25042.432823]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[25042.434610]  ffff88020d7a0000 0000000000000000 ffff8802361ac630 ffff880195249b80
[25042.436381] Call Trace:
[25042.437508]  <IRQ> 

[25042.438752]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25042.439989]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[25042.441543]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[25042.443048]  <EOI> 

[25042.444272]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[25042.445626]  [<ffffffff811dad2f>] ? sync_inodes_sb+0x19f/0x2a0
[25042.447124]  [<ffffffff811dad28>] ? sync_inodes_sb+0x198/0x2a0
[25042.448614]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25042.450140]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25042.451578]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25042.453070]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25042.454549]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25042.455993]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25042.457357]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25042.458714] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[25070.218002] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:701]
[25070.218004] BUG: soft lockup - CPU#1 stuck for 24s! [trinity-child1:725]
[25070.218028] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25070.218028] irq event stamp: 43906
[25070.218033] hardirqs last  enabled at (43905): [<ffffffff816eda20>] restore_args+0x0/0x30
[25070.218036] hardirqs last disabled at (43906): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25070.218039] softirqs last  enabled at (43904): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25070.218041] softirqs last disabled at (43899): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25070.218043] CPU: 1 PID: 725 Comm: trinity-child1 Not tainted 3.10.0-rc7+ #32 
[25070.218045] task: ffff8801b0768000 ti: ffff88022d1ca000 task.ti: ffff88022d1ca000
[25070.218047] RIP: 0010:[<ffffffff816eb89f>]  [<ffffffff816eb89f>] preempt_schedule+0xf/0x60
[25070.218048] RSP: 0018:ffff88022d1cbd48  EFLAGS: 00000202
[25070.218049] RAX: ffff88022d1cbfd8 RBX: ffff88022d1cbcc8 RCX: 000000000000b910
[25070.218049] RDX: 0000000000000015 RSI: 0000000000000001 RDI: 0000000000000001
[25070.218050] RBP: ffff88022d1cbd78 R08: 0000000000000000 R09: 0000000000000000
[25070.218050] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88022d1ca000
[25070.218051] R13: ffff8801b0768000 R14: 0000000000000000 R15: 0000000000000000
[25070.218051] FS:  00007f641bcda740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
[25070.218052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25070.218053] CR2: 00007ffd6497f000 CR3: 000000022f848000 CR4: 00000000001407e0
[25070.218053] DR0: 0000000002015000 DR1: 0000000000000000 DR2: 0000000000000000
[25070.218054] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25070.218054] Stack:
[25070.218056]  ffffffff81309cd5 ffffffff81c04640 000000002dd7c28f 0000000088c66b68
[25070.218057]  0000000000000000 ffffffff00000000 ffff88022d1cbd88 ffffffff81309b5f
[25070.218059]  ffff88022d1cbdb0 ffffffff81312171 ffffffff81c04640 ffffffff81c04658
[25070.218059] Call Trace:
[25070.218062]  [<ffffffff81309cd5>] ? delay_tsc+0xd5/0xe0
[25070.218064]  [<ffffffff81309b5f>] __delay+0xf/0x20
[25070.218067]  [<ffffffff81312171>] do_raw_spin_lock+0xe1/0x130
[25070.218068]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25070.218071]  [<ffffffff811dad04>] ? sync_inodes_sb+0x174/0x2a0
[25070.218072]  [<ffffffff811dad04>] sync_inodes_sb+0x174/0x2a0
[25070.218074]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25070.218077]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25070.218078]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25070.218079]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25070.218082]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25070.218083]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25070.218085]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25070.218099] Code: 1f 44 00 00 48 8d 47 18 48 39 47 18 75 e4 e9 71 ff ff ff 66 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 f0 b9 00 00 8b b0 44 e0 ff ff <85> f6 74 01 c3 9c 58 f6 c4 02 74 f8 55 48 89 e5 41 55 41 54 53 
[25070.247984] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:354]
[25070.248006] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25070.248009] irq event stamp: 10251323
[25070.248015] hardirqs last  enabled at (10251322): [<ffffffff816eda20>] restore_args+0x0/0x30
[25070.248017] hardirqs last disabled at (10251323): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25070.248020] softirqs last  enabled at (10250550): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25070.248021] softirqs last disabled at (10250553): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25070.248025] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[25070.248027] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[25070.248029] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[25070.248030] RSP: 0018:ffff880244c03f08  EFLAGS: 00000206
[25070.248030] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[25070.248031] RDX: 00000000000031b0 RSI: ffff88020d7a07f0 RDI: ffff88020d7a0000
[25070.248031] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[25070.248032] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[25070.248032] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[25070.248033] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[25070.248034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25070.248034] CR2: 00007f71154f01e8 CR3: 00000001b0481000 CR4: 00000000001407e0
[25070.248035] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[25070.248035] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25070.248035] Stack:
[25070.248037]  0000000a00406040 000000010025d182 ffff880165dfffd8 ffff880165dfffd8
[25070.248038]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[25070.248040]  ffff88020d7a0000 0000000000000000 ffff8802361ac630 ffff88018edd1b80
[25070.248040] Call Trace:
[25070.248041]  <IRQ> 
[25070.248043]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25070.248046]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[25070.248048]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[25070.248048]  <EOI> 
[25070.248050]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[25070.248052]  [<ffffffff811dad63>] ? sync_inodes_sb+0x1d3/0x2a0
[25070.248054]  [<ffffffff811dad52>] ? sync_inodes_sb+0x1c2/0x2a0
[25070.248056]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25070.248058]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25070.248059]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25070.248060]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25070.248062]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25070.248064]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25070.248065]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25070.248080] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[25070.392616] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25070.403930] irq event stamp: 113174
[25070.405459] hardirqs last  enabled at (113173): [<ffffffff816eda20>] restore_args+0x0/0x30
[25070.407576] hardirqs last disabled at (113174): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25070.409799] softirqs last  enabled at (113172): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25070.411953] softirqs last disabled at (113167): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25070.414053] CPU: 0 PID: 701 Comm: trinity-child0 Not tainted 3.10.0-rc7+ #32 
[25070.419119] task: ffff880235f24a40 ti: ffff880218608000 task.ti: ffff880218608000
[25070.421195] RIP: 0010:[<ffffffff816f14ac>]  [<ffffffff816f14ac>] add_preempt_count+0x3c/0xf0
[25070.423422] RSP: 0018:ffff880218609d38  EFLAGS: 00000213
[25070.425265] RAX: ffff880218609fd8 RBX: ffff880218608000 RCX: 000000000000b910
[25070.427315] RDX: 000000000000201f RSI: 0000000000000001 RDI: 0000000000000001
[25070.429340] RBP: ffff880218609d40 R08: 0000000000000000 R09: 0000000000000000
[25070.431355] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[25070.433347] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[25070.435305] FS:  00007f6072db9740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
[25070.437378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25070.439137] CR2: 0000000000000008 CR3: 00000001a5868000 CR4: 00000000001407f0
[25070.441055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[25070.442959] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25070.444853] Stack:
[25070.446144]  ffffffff81c04640 ffff880218609d78 ffffffff81309c1f ffffffff81c04640
[25070.448124]  0000000031a04c45 0000000088c66b68 ffff88023c0323c0 ffff88023c0325d0
[25070.450099]  ffff880218609d88 ffffffff81309b5f ffff880218609db0 ffffffff81312171
[25070.452063] Call Trace:
[25070.453384]  [<ffffffff81309c1f>] delay_tsc+0x1f/0xe0
[25070.455000]  [<ffffffff81309b5f>] __delay+0xf/0x20
[25070.456574]  [<ffffffff81312171>] do_raw_spin_lock+0xe1/0x130
[25070.458252]  [<ffffffff816ec980>] _raw_spin_lock+0x60/0x80
[25070.459904]  [<ffffffff811dadb8>] ? sync_inodes_sb+0x228/0x2a0
[25070.461586]  [<ffffffff811dadb8>] sync_inodes_sb+0x228/0x2a0
[25070.463255]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25070.464981]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25070.466616]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25070.468308]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25070.469979]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25070.471607]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25070.473179]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25070.474728] Code: 25 f0 b9 00 00 48 89 e5 53 89 fb 45 85 c0 75 57 8b b8 44 e0 ff ff 85 ff 0f 88 85 00 00 00 01 98 44 e0 ff ff 80 b8 44 e0 ff ff f4 <76> 40 e8 5d a8 c1 ff 85 c0 74 37 83 3d 42 2c 4a 01 00 75 2e 48 
[25094.234554] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:354]
[25094.236292] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25094.247304] irq event stamp: 12162607
[25094.248770] hardirqs last  enabled at (12162606): [<ffffffff816eda20>] restore_args+0x0/0x30
[25094.250836] hardirqs last disabled at (12162607): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25094.252983] softirqs last  enabled at (12161816): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25094.255077] softirqs last disabled at (12161819): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25094.257124] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[25094.262081] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[25094.264133] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[25094.266253] RSP: 0018:ffff880244c03f08  EFLAGS: 00000202
[25094.268011] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[25094.269985] RDX: 00000000000031b0 RSI: ffff88020d7a07f0 RDI: ffff88020d7a0000
[25094.271969] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[25094.273936] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[25094.275879] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[25094.277805] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[25094.279828] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25094.281562] CR2: 0000000000000000 CR3: 00000001b0481000 CR4: 00000000001407e0
[25094.283440] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[25094.285329] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25094.287188] Stack:
[25094.288433]  0000000a00406040 000000010025dae5 ffff880165dfffd8 ffff880165dfffd8
[25094.290369]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[25094.292299]  ffff88020d7a0000 0000000000000000 ffff8802361ac630 ffff880231d46e00
[25094.294223] Call Trace:
[25094.295504]  <IRQ> 

[25094.296897]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25094.298296]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[25094.299998]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[25094.301657]  <EOI> 

[25094.303033]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[25094.304534]  [<ffffffff813121dd>] ? do_raw_spin_trylock+0x1d/0x50
[25094.306217]  [<ffffffff816ec968>] _raw_spin_lock+0x48/0x80
[25094.307822]  [<ffffffff811dad52>] ? sync_inodes_sb+0x1c2/0x2a0
[25094.309471]  [<ffffffff811dad52>] sync_inodes_sb+0x1c2/0x2a0
[25094.311088]  [<ffffffff816ea06f>] ? wait_for_completion+0xdf/0x110
[25094.312772]  [<ffffffff8108cf3d>] ? get_parent_ip+0xd/0x50
[25094.314363]  [<ffffffff811e0950>] ? generic_write_sync+0x70/0x70
[25094.316035]  [<ffffffff811e0969>] sync_inodes_one_sb+0x19/0x20
[25094.317660]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25094.319256]  [<ffffffff811e0bd5>] sys_sync+0x35/0x90
[25094.320770]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25094.322280] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
[25118.221102] BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child2:354]
[25118.222941] Modules linked in: 8021q garp snd_seq_dummy bnep fuse bridge stp rfcomm tun hidp nfnetlink scsi_transport_iscsi ipt_ULOG can_raw phonet af_rxrpc af_key nfc irda can_bcm bluetooth rose llc2 pppoe pppox ppp_generic slhc rfkill x25 atm rds netrom caif_socket ax25 caif crc_ccitt can af_802154 ipx p8023 p8022 appletalk psnap llc coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
[25118.234444] irq event stamp: 14004875
[25118.236035] hardirqs last  enabled at (14004874): [<ffffffff816eda20>] restore_args+0x0/0x30
[25118.238227] hardirqs last disabled at (14004875): [<ffffffff816f652a>] apic_timer_interrupt+0x6a/0x80
[25118.240511] softirqs last  enabled at (14004102): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[25118.242739] softirqs last disabled at (14004105): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25118.244897] CPU: 2 PID: 354 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #32 
[25118.250066] task: ffff88020d7a0000 ti: ffff880165dfe000 task.ti: ffff880165dfe000
[25118.252172] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[25118.254352] RSP: 0018:ffff880244c03f08  EFLAGS: 00000202
[25118.256186] RAX: ffff88020d7a0000 RBX: ffffffff816eda20 RCX: 0000000000000002
[25118.258219] RDX: 0000000000003330 RSI: ffff88020d7a07b8 RDI: ffff88020d7a0000
[25118.260223] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[25118.262217] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[25118.264180] R13: ffffffff816f652f R14: ffff880244c03f70 R15: 0000000000000000
[25118.266121] FS:  00007f6a251c7740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[25118.268180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25118.269970] CR2: 0000000000000008 CR3: 00000001b0481000 CR4: 00000000001407e0
[25118.271920] DR0: 0000000001c0f000 DR1: 0000000000000000 DR2: 0000000000000000
[25118.273877] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[25118.275814] Stack:
[25118.277129]  0000000a00406040 000000010025e445 ffff880165dfffd8 ffff880165dfffd8
[25118.279108]  ffff880165dfffd8 ffff88020d7a03f8 ffff880165dfffd8 ffffffff00000002
[25118.281090]  ffff88020d7a0000 0000000000000000 0000000000000003 0000000000000000
[25118.283056] Call Trace:
[25118.284399]  <IRQ> 

[25118.285876]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[25118.287351]  [<ffffffff816f73cb>] smp_apic_timer_interrupt+0x6b/0x9b
[25118.289144]  [<ffffffff816f652f>] apic_timer_interrupt+0x6f/0x80
[25118.290897]  <EOI> 

[25118.292358]  [<ffffffff816eda20>] ? retint_restore_args+0xe/0xe
[25118.293932]  [<ffffffff816ecdc7>] ? _raw_spin_unlock_irqrestore+0x67/0x80
[25118.295768]  [<ffffffff810869f4>] __wake_up+0x44/0x50
[25118.297420]  [<ffffffffa009923f>] xlog_cil_push+0x38f/0x3d0 [xfs]
[25118.299193]  [<ffffffffa00999a8>] xlog_cil_force_lsn+0x1a8/0x1d0 [xfs]
[25118.300991]  [<ffffffff816eaeae>] ? __schedule+0x46e/0xa40
[25118.302666]  [<ffffffff811e0ad0>] ? do_fsync+0x80/0x80
[25118.304314]  [<ffffffffa0097b21>] _xfs_log_force+0x61/0x290 [xfs]
[25118.306053]  [<ffffffff816f15d1>] ? sub_preempt_count+0x71/0x100
[25118.307778]  [<ffffffff811e0ad0>] ? do_fsync+0x80/0x80
[25118.309419]  [<ffffffffa0097d76>] xfs_log_force+0x26/0x170 [xfs]
[25118.311161]  [<ffffffffa002b4dd>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[25118.312887]  [<ffffffff811e0af0>] sync_fs_one_sb+0x20/0x30
[25118.314546]  [<ffffffff811b1272>] iterate_supers+0xb2/0x110
[25118.316213]  [<ffffffff811e0bf5>] sys_sync+0x55/0x90
[25118.317804]  [<ffffffff816f5ad4>] tracesys+0xdd/0xe2
[25118.319388] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 07 36 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 

