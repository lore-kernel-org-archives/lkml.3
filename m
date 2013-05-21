Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3EUX6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3EUX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:58:19 -0400
Date: Tue, 21 May 2013 19:58:13 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: fweisbec@gmail.com
Subject: WARNING: at kernel/rcutree.c:388 rcu_eqs_enter
Message-ID: <20130521235813.GA18737@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521173100.GA2076@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:31:00PM -0400, Dave Jones wrote:

I'm also seeing this quite often..

[  576.156848] WARNING: at kernel/rcutree.c:388 rcu_eqs_enter+0x9b/0xb0()
[  576.165962] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
[  576.235012] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc2+ #2
[  576.264999]  ffffffff819e8d1d ffffffff81c01e90 ffffffff816599f1 ffffffff81c01ec8
[  576.265002]  ffffffff8104a171 ffff8802449cdb60 0000000000000000 0000000000000000
[  576.265005]  ffffffff81c01fd8 ffffffff81c01fd8 ffffffff81c01ed8 ffffffff8104a24a
[  576.265006] Call Trace:
[  576.265011]  [<ffffffff816599f1>] dump_stack+0x19/0x1b
[  576.265015]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
[  576.265018]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[  576.265022]  [<ffffffff81100b7b>] rcu_eqs_enter+0x9b/0xb0
[  576.265025]  [<ffffffff81100ba9>] rcu_idle_enter+0x19/0x40
[  576.265029]  [<ffffffff810a66e2>] cpu_startup_entry+0x92/0x420
[  576.265034]  [<ffffffff81645287>] rest_init+0x137/0x140
[  576.265037]  [<ffffffff81645155>] ? rest_init+0x5/0x140
[  576.265041]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
[  576.265044]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
[  576.265048]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
[  576.265050]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
[  576.265052] ---[ end trace d18cda23dfca05cc ]---

	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);

[  576.265054] WARNING: at kernel/rcutree.c:363 rcu_eqs_enter_common+0x44d/0x470()
[  576.265096] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
[  576.265099] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.0-rc2+ #2
[  576.265103]  ffffffff819e8d1d ffffffff81c01e50 ffffffff816599f1 ffffffff81c01e88
[  576.265106]  ffffffff8104a171 ffff8802449cdb60 0000000000000000 ffff8802449cdb60
[  576.265109]  ff00000000000000 0000000000000000 ffffffff81c01e98 ffffffff8104a24a
[  576.265110] Call Trace:
[  576.265113]  [<ffffffff816599f1>] dump_stack+0x19/0x1b
[  576.265115]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
[  576.265118]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[  576.265121]  [<ffffffff81100abd>] rcu_eqs_enter_common+0x44d/0x470
[  576.265124]  [<ffffffff81100b4a>] rcu_eqs_enter+0x6a/0xb0
[  576.265127]  [<ffffffff81100ba9>] rcu_idle_enter+0x19/0x40
[  576.265130]  [<ffffffff810a66e2>] cpu_startup_entry+0x92/0x420
[  576.265133]  [<ffffffff81645287>] rest_init+0x137/0x140
[  576.265136]  [<ffffffff81645155>] ? rest_init+0x5/0x140
[  576.265139]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
[  576.265141]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
[  576.265145]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
[  576.265147]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
[  576.265149] ---[ end trace d18cda23dfca05cd ]---

	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);

[  576.265362] WARNING: at kernel/rcutree.c:480 rcu_irq_exit+0x1da/0x1f0()
[  576.265403] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
[  576.265406] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.0-rc2+ #2
[  576.265410]  ffffffff819e8d1d ffff880244803ef8 ffffffff816599f1 ffff880244803f30
[  576.265414]  ffffffff8104a171 ffff8802449cdb60 ff00000000000000 ff00000000000001
[  576.265417]  0000000000000092 ffffffff81c01fd8 ffff880244803f40 ffffffff8104a24a
[  576.265417] Call Trace:
[  576.265421]  <IRQ>  [<ffffffff816599f1>] dump_stack+0x19/0x1b
[  576.265424]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
[  576.265427]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[  576.265429]  [<ffffffff8110292a>] rcu_irq_exit+0x1da/0x1f0
[  576.265433]  [<ffffffff81054679>] irq_exit+0x89/0xc0
[  576.265438]  [<ffffffff8166bf4b>] smp_apic_timer_interrupt+0x6b/0x9b
[  576.265442]  [<ffffffff8166b0af>] apic_timer_interrupt+0x6f/0x80
[  576.265448]  <EOI>  [<ffffffff816625a0>] ? retint_restore_args+0xe/0xe
[  576.265455]  [<ffffffff814e3dfb>] ? cpuidle_idle_call+0x3cb/0x3f0
[  576.265459]  [<ffffffff814e3dff>] ? cpuidle_idle_call+0x3cf/0x3f0
[  576.265463]  [<ffffffff814e3dfb>] ? cpuidle_idle_call+0x3cb/0x3f0
[  576.265470]  [<ffffffff8100bcde>] arch_cpu_idle+0xe/0x30
[  576.265474]  [<ffffffff810a66e7>] cpu_startup_entry+0x97/0x420
[  576.265479]  [<ffffffff81645287>] rest_init+0x137/0x140
[  576.265483]  [<ffffffff81645155>] ? rest_init+0x5/0x140
[  576.265487]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
[  576.265490]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
[  576.265494]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
[  576.265496]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
[  576.265498] ---[ end trace d18cda23dfca05ce ]---

	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);


[  576.265501] WARNING: at kernel/rcutree.c:528 rcu_eqs_exit+0x91/0xa0()
[  576.265542] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
[  576.265545] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.0-rc2+ #2
[  576.265551]  ffffffff819e8d1d ffffffff81c01e90 ffffffff816599f1 ffffffff81c01ec8
[  576.265559]  ffffffff8104a171 ffff8802449cdb60 ff00000000000000 0000000000000000
[  576.265574]  ffffffff81c01fd8 ffffffff81c01fd8 ffffffff81c01ed8 ffffffff8104a24a
[  576.265575] Call Trace:
[  576.265578]  [<ffffffff816599f1>] dump_stack+0x19/0x1b
[  576.265580]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
[  576.265583]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[  576.265586]  [<ffffffff810fd681>] rcu_eqs_exit+0x91/0xa0
[  576.265588]  [<ffffffff810fd6a9>] rcu_idle_exit+0x19/0x40
[  576.265591]  [<ffffffff810a66f7>] cpu_startup_entry+0xa7/0x420
[  576.265595]  [<ffffffff81645287>] rest_init+0x137/0x140
[  576.265597]  [<ffffffff81645155>] ? rest_init+0x5/0x140
[  576.265600]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
[  576.265602]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
[  576.265605]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
[  576.265608]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
[  576.265609] ---[ end trace d18cda23dfca05cf ]---

	WARN_ON_ONCE(oldval < 0);

[  576.265612] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x357/0x380()
[  576.265663] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
[  576.265665] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.0-rc2+ #2 
[  576.265669]  ffffffff819e8d1d ffffffff81c01e50 ffffffff816599f1 ffffffff81c01e88
[  576.265672]  ffffffff8104a171 ffff8802449cdb60 ff00000000000000 ffff8802449cdb60
[  576.265675]  ffffffff81c01fd8 0000000000000000 ffffffff81c01e98 ffffffff8104a24a
[  576.265676] Call Trace:
[  576.265678]  [<ffffffff816599f1>] dump_stack+0x19/0x1b
[  576.265680]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
[  576.265683]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[  576.265686]  [<ffffffff810fd5c7>] rcu_eqs_exit_common+0x357/0x380
[  576.265689]  [<ffffffff810fd64a>] rcu_eqs_exit+0x5a/0xa0
[  576.265691]  [<ffffffff810fd6a9>] rcu_idle_exit+0x19/0x40
[  576.265694]  [<ffffffff810a66f7>] cpu_startup_entry+0xa7/0x420
[  576.265698]  [<ffffffff81645287>] rest_init+0x137/0x140
[  576.265700]  [<ffffffff81645155>] ? rest_init+0x5/0x140
[  576.265704]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
[  576.265708]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
[  576.265712]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
[  576.265716]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
[  576.265717] ---[ end trace d18cda23dfca05d0 ]---

	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));


I'm trying to collect all the WARN's in rcutree. 5/29 isn't a bad start :)

	Dave

