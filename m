Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbaDXPVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbaDXPVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:21:16 -0400
Date: Thu, 24 Apr 2014 11:21:04 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: return of perf task_ctx_sched_out bug.
Message-ID: <20140424152104.GA13144@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen this in a while.

WARNING: CPU: 0 PID: 25574 at kernel/events/core.c:2384 task_ctx_sched_out+0x6b/0x80()
Modules linked in: 8021q garp dccp_ipv4 dccp bridge stp snd_seq_dummy sctp fuse hidp bnep tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi ipt_ULOG can_bcm can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller xfs snd_hda_codec snd_hwdep e1000e libcrc32c crct10dif_pclmul snd_seq snd_seq_device crc32c_intel snd_pcm btusb bluetooth ghash_clmulni_intel snd_timer snd ptp pcspkr pps_core serio_raw microcode shpchp 6lowpan_iphc usb_debug rfkill soundcore
CPU: 0 PID: 25574 Comm: trinity-c76 Not tainted 3.15.0-rc2+ #197
 0000000000000009 000000006f572b93 ffff8802389b3df0 ffffffff8b74671d
 0000000000000000 ffff8802389b3e28 ffffffff8b06d45d ffff8802441d7ad8
 ffff880111e6adf0 0000000000000286 ffff88023fb8b5c0 ffff880111e6adf0
Call Trace:
 [<ffffffff8b74671d>] dump_stack+0x4e/0x7a
 [<ffffffff8b06d45d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8b06d58a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8b14f6eb>] task_ctx_sched_out+0x6b/0x80
 [<ffffffff8b152988>] perf_event_comm+0x108/0x260
 [<ffffffff8b152880>] ? perf_event_fork+0x20/0x20
 [<ffffffff8b0bf746>] ? lock_release_holdtime.part.24+0xe6/0x160
 [<ffffffff8b0a3ccd>] ? get_parent_ip+0xd/0x50
 [<ffffffff8b1ce63f>] set_task_comm+0x4f/0xc0
 [<ffffffff8b086829>] SyS_prctl+0x1d9/0x480
 [<ffffffff8b75aa64>] tracesys+0xdd/0xe2


Last time you looked into this, you had me run some debug patches,
which caused a bunch of spew:
http://permalink.gmane.org/gmane.linux.kernel/1648614

I've not been running with that patch since then, but if it's going to
be useful I can try and resurrect it.

	Dave

