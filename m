Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbaD2PRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967AbaD2PRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:17:30 -0400
Date: Tue, 29 Apr 2014 11:16:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: peterz@infradead.org, davidlohr@hp.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [3.15-rc3] rtmutex-debug assertion.
Message-ID: <20140429151655.GA14277@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
	davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this while fuzzing the futex() syscall.


WARNING: CPU: 2 PID: 6202 at kernel/locking/rtmutex-debug.c:151 debug_rt_mutex_proxy_unlock+0x4e/0x60()
DEBUG_LOCKS_WARN_ON(!rt_mutex_owner(lock))
Modules linked in:
 tun fuse ipt_ULOG nfnetlink bnep can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc can_raw can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm xfs libcrc32c btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_timer snd microcode serio_raw pcspkr usb_debug 6lowpan_iphc rfkill shpchp ptp pps_core soundcore
CPU: 2 PID: 6202 Comm: trinity-c63 Not tainted 3.15.0-rc3+ #201
 0000000000000009 00000000de725d52 ffff880099befbd8 ffffffff92746dad
 ffff880099befc20 ffff880099befc10 ffffffff9206d46d ffff88020951c010
 ffff88009d718000 ffff88009d718000 ffffc90011408680 ffffc90011408688
Call Trace:
 [<ffffffff92746dad>] dump_stack+0x4e/0x7a
 [<ffffffff9206d46d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff9206d4ec>] warn_slowpath_fmt+0x5c/0x80
 [<ffffffff920c533e>] debug_rt_mutex_proxy_unlock+0x4e/0x60
 [<ffffffff920c4d77>] rt_mutex_proxy_unlock+0x17/0x40
 [<ffffffff920ead7a>] free_pi_state+0x6a/0xb0
 [<ffffffff920eade0>] unqueue_me_pi+0x20/0x40
 [<ffffffff920ebfc2>] futex_lock_pi.isra.18+0x262/0x3f0
 [<ffffffff92096910>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff920edb2c>] do_futex+0x2ec/0xb60
 [<ffffffff92349897>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffff920bf3ee>] ? put_lock_stats.isra.23+0xe/0x30
 [<ffffffff920bf756>] ? lock_release_holdtime.part.24+0xe6/0x160
 [<ffffffff920a3cdd>] ? get_parent_ip+0xd/0x50
 [<ffffffff9275698b>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffff92751f51>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff920ee420>] SyS_futex+0x80/0x180
 [<ffffffff9275b0e4>] tracesys+0xdd/0xe2

