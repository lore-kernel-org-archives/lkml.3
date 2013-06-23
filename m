Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3FWPG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 11:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3FWPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 11:06:21 -0400
Date: Sun, 23 Jun 2013 11:06:03 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130623150603.GA32313@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130619175356.GA23673@redhat.com>
 <20130619181302.GE5146@linux.vnet.ibm.com>
 <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
 <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623143634.GA2000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 04:36:34PM +0200, Oleg Nesterov wrote:
 
 > >  > Dave, I am sorry but all I can do is to ask you to do more testing.
 > >  > Could you please reproduce the lockup again on the clean Linus's
 > >  > current ? (and _without_ reverting 8aac6270, of course).
 > >
 > > I'll give it a shot.  Just rebuilt clean tree, and restarted the tests.
 > 
 > Thanks a lot.

ok, hit it on rc7 without the revert

[11018.927809] [sched_delayed] sched: RT throttling activated
[11054.897670] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child2:14482]
[11054.898503] Modules linked in: bridge stp snd_seq_dummy tun fuse hidp bnep rfcomm can_raw ipt_ULOG can_bcm nfnetlink af_rxrpc llc2 rose caif_socket caif can netrom appletalk af_802154 scsi_transport_iscsi nfc pppoe pppox ppp_generic slhc ipx p8023 psnap p8022 llc ax25 irda crc_ccitt af_key bluetooth rfkill x25 rds atm phonet coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi microcode snd_hda_intel snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc ptp snd_timer pps_core snd soundcore xfs libcrc32c
[11054.905490] irq event stamp: 3857095
[11054.905926] hardirqs last  enabled at (3857094): [<ffffffff816ed9a0>] restore_args+0x0/0x30
[11054.906945] hardirqs last disabled at (3857095): [<ffffffff816f64aa>] apic_timer_interrupt+0x6a/0x80
[11054.908054] softirqs last  enabled at (3856322): [<ffffffff810542e4>] __do_softirq+0x194/0x440
[11054.909102] softirqs last disabled at (3856325): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[11054.910088] CPU: 2 PID: 14482 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #31 
[11054.912900] task: ffff8801ae44ca40 ti: ffff88021fe60000 task.ti: ffff88021fe60000
[11054.913800] RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
[11054.914786] RSP: 0018:ffff880244c03f08  EFLAGS: 00000206
[11054.915428] RAX: ffff8801ae44ca40 RBX: ffffffff816ed9a0 RCX: 0000000000000000
[11054.916286] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801ae44ca40
[11054.917143] RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
[11054.918002] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
[11054.919799] R13: ffffffff816f64af R14: ffff880244c03f70 R15: 0000000000000000
[11054.921601] FS:  00007f36e952f740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[11054.923529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11054.925182] CR2: 0000003850a74cf0 CR3: 00000002081b9000 CR4: 00000000001407e0
[11054.927009] DR0: 0000000001550000 DR1: 0000000000000000 DR2: 0000000000000000
[11054.928830] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[11054.930643] Stack:
[11054.931862]  0000000a00406040 0000000100106b66 ffff88021fe61fd8 ffff88021fe61fd8
[11054.933777]  ffff88021fe61fd8 ffff8801ae44ce38 ffff88021fe61fd8 ffffffff00000002
[11054.935694]  ffff8801ae44ca40 0000000000000000 ffffea0008f49280 ffff8802434cc240
[11054.937617] Call Trace:
[11054.938916]  <IRQ> 

[11054.940347]  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
[11054.941790]  [<ffffffff816f734b>] smp_apic_timer_interrupt+0x6b/0x9b
[11054.943550]  [<ffffffff816f64af>] apic_timer_interrupt+0x6f/0x80
[11054.945270]  <EOI> 

[11054.946705]  [<ffffffff816ed9a0>] ? retint_restore_args+0xe/0xe
[11054.948267]  [<ffffffff816ecd67>] ? _raw_spin_unlock_irqrestore+0x67/0x80
[11054.950090]  [<ffffffff816e28ec>] __slab_free+0x5f/0x39f
[11054.951737]  [<ffffffff816ecd75>] ? _raw_spin_unlock_irqrestore+0x75/0x80
[11054.953556]  [<ffffffff8131506e>] ? debug_check_no_obj_freed+0x14e/0x250
[11054.955362]  [<ffffffff81199335>] ? kmem_cache_free+0x95/0x300
[11054.957065]  [<ffffffff8119958c>] kmem_cache_free+0x2ec/0x300
[11054.958759]  [<ffffffff81047104>] ? __put_task_struct+0x64/0x140
[11054.960485]  [<ffffffff81047104>] __put_task_struct+0x64/0x140
[11054.962184]  [<ffffffff81086d4f>] finish_task_switch+0x11f/0x130
[11054.963899]  [<ffffffff81086c77>] ? finish_task_switch+0x47/0x130
[11054.965632]  [<ffffffff816eae24>] __schedule+0x444/0xa40
[11054.967271]  [<ffffffff816eba83>] preempt_schedule_irq+0x53/0x90
[11054.968994]  [<ffffffff816edab6>] retint_kernel+0x26/0x30
[11054.970656]  [<ffffffff81145877>] ? user_enter+0x87/0xd0
[11054.972305]  [<ffffffff8100f6a8>] syscall_trace_leave+0x78/0x140
[11054.974029]  [<ffffffff816f5b2f>] int_check_syscall_exit_work+0x34/0x3d
[11054.975819] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 a7 35 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 

