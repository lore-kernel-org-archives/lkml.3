Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLESsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:48:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLESsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:48:52 -0500
Date: Fri, 5 Dec 2014 13:48:08 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141205184808.GA2753@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:38:55AM -0800, Linus Torvalds wrote:
 > On Fri, Dec 5, 2014 at 9:15 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > A bisect later, and I landed on a kernel that ran for a day, before
 > > spewing NMI messages, recovering, and then..
 > >
 > > http://codemonkey.org.uk/junk/log.txt
 > 
 > I have to admit I'm seeing absolutely nothing sensible in there.
 > 
 > Call it bad, and see if bisection ends up slowly -oh so slowly -
 > pointing to some direction. Because I don't think it's the hardware,
 > considering that apparently 3.16 is solid. And the spews themselves
 > are so incomprehensible that I'm not seeing any pattern what-so-ever.

Will do.
In the meantime, I rebooted into the same kernel, and ran trinity
solely doing the lsetxattr syscalls. The load was a bit lower, so I
cranked up the number of child processes to 512, and then this
happened..

[ 1611.746960] ------------[ cut here ]------------
[ 1611.747053] WARNING: CPU: 0 PID: 14810 at kernel/watchdog.c:265 watchdog_overflow_callback+0xd5/0x120()
[ 1611.747083] Watchdog detected hard LOCKUP on cpu 0
[ 1611.747097] Modules linked in:
[ 1611.747112]  rfcomm hidp bnep scsi_transport_iscsi can_bcm nfnetlink can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm e1000e crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec microcode serio_raw pcspkr snd_hwdep snd_seq snd_seq_device nfsd usb_debug snd_pcm ptp shpchp pps_core snd_timer snd soundcore auth_rpcgss oid_registry nfs_acl lockd sunrpc
[ 1611.747389] CPU: 0 PID: 14810 Comm: trinity-c304 Not tainted 3.16.0+ #114
[ 1611.747449]  0000000000000000 000000007964733e ffff880244006be0 ffffffff8178fccb
[ 1611.747481]  ffff880244006c28 ffff880244006c18 ffffffff81073ecd 0000000000000000
[ 1611.747512]  0000000000000000 ffff880244006d58 ffff880244006ef8 0000000000000000
[ 1611.747544] Call Trace:
[ 1611.747555]  <NMI>  [<ffffffff8178fccb>] dump_stack+0x4e/0x7a
[ 1611.747582]  [<ffffffff81073ecd>] warn_slowpath_common+0x7d/0xa0
[ 1611.747604]  [<ffffffff81073f4c>] warn_slowpath_fmt+0x5c/0x80
[ 1611.747625]  [<ffffffff811255c0>] ? restart_watchdog_hrtimer+0x50/0x50
[ 1611.747648]  [<ffffffff81125695>] watchdog_overflow_callback+0xd5/0x120
[ 1611.747673]  [<ffffffff8116446c>] __perf_event_overflow+0xac/0x2a0
[ 1611.747696]  [<ffffffff81018ffe>] ? x86_perf_event_set_period+0xde/0x150
[ 1611.747720]  [<ffffffff81165034>] perf_event_overflow+0x14/0x20
[ 1611.747742]  [<ffffffff8101ed56>] intel_pmu_handle_irq+0x206/0x410
[ 1611.747764]  [<ffffffff81017e5b>] perf_event_nmi_handler+0x2b/0x50
[ 1611.747787]  [<ffffffff81007403>] nmi_handle+0xa3/0x1b0
[ 1611.747807]  [<ffffffff81007365>] ? nmi_handle+0x5/0x1b0
[ 1611.747827]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
[ 1611.748699]  [<ffffffff81007742>] default_do_nmi+0x72/0x1c0
[ 1611.749570]  [<ffffffff81007948>] do_nmi+0xb8/0xf0
[ 1611.750438]  [<ffffffff8179dd2a>] end_repeat_nmi+0x1e/0x2e
[ 1611.751312]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
[ 1611.752177]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
[ 1611.753025]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
[ 1611.753861]  <<EOE>>  [<ffffffff810fee07>] is_module_text_address+0x17/0x50
[ 1611.754734]  [<ffffffff81092ab8>] __kernel_text_address+0x58/0x80
[ 1611.755575]  [<ffffffff81006b5f>] print_context_stack+0x8f/0x100
[ 1611.756410]  [<ffffffff81005540>] dump_trace+0x140/0x370
[ 1611.757242]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
[ 1611.758072]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
[ 1611.758895]  [<ffffffff810137cb>] save_stack_trace+0x2b/0x50
[ 1611.759720]  [<ffffffff811c29a0>] set_track+0x70/0x140
[ 1611.760541]  [<ffffffff8178d993>] alloc_debug_processing+0x92/0x118
[ 1611.761366]  [<ffffffff8178e5d6>] __slab_alloc+0x45f/0x56f
[ 1611.762195]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
[ 1611.763024]  [<ffffffff8178dd57>] ? __slab_free+0x114/0x309
[ 1611.763853]  [<ffffffff8137187e>] ? debug_check_no_obj_freed+0x17e/0x270
[ 1611.764712]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
[ 1611.765539]  [<ffffffff811c6b26>] kmem_cache_alloc+0x1f6/0x270
[ 1611.766364]  [<ffffffff810a7035>] ? local_clock+0x25/0x30
[ 1611.767183]  [<ffffffff811e797f>] getname_flags+0x4f/0x1a0
[ 1611.768004]  [<ffffffff811ed7e5>] user_path_at_empty+0x45/0xc0
[ 1611.768827]  [<ffffffff810a13cb>] ? preempt_count_sub+0x6b/0xf0
[ 1611.769649]  [<ffffffff810be35e>] ? put_lock_stats.isra.23+0xe/0x30
[ 1611.770470]  [<ffffffff810be67d>] ? lock_release_holdtime.part.24+0x9d/0x160
[ 1611.771297]  [<ffffffff811fdedd>] ? mntput_no_expire+0x6d/0x160
[ 1611.772129]  [<ffffffff811ed871>] user_path_at+0x11/0x20
[ 1611.772959]  [<ffffffff812040cb>] SyS_lsetxattr+0x4b/0xf0
[ 1611.773783]  [<ffffffff8179bc92>] system_call_fastpath+0x16/0x1b
[ 1611.774631] ---[ end trace 5beef170ba6002cc ]---
[ 1611.775514] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 28.493 msecs
[ 1611.776368] perf interrupt took too long (223592 > 2500), lowering kernel.perf_event_max_sample_rate to 50000


I don't really know if that's indicative of anything useful, but it
at least might have been how we triggered the NMI in the previous run.

	Dave

