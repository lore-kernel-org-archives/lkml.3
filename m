Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161584AbaJ3Xkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161211AbaJ3Xkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:40:41 -0400
Date: Thu, 30 Oct 2014 19:40:29 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: a.p.zijlstra@chello.nl
Subject: 3.18-rc2 perf add_event_to_ctx warning
Message-ID: <20141030234029.GA28961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 3 PID: 5167 at kernel/events/core.c:1133 add_event_to_ctx+0x1ce/0x1f0()
Modules linked in: 8021q garp bridge stp snd_seq_dummy fuse tun hidp sctp libcrc32c rfcomm scsi_transport_iscsi can_raw can_bcm nfnetlink nfc caif_socket caif af
_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill co
retemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode btrfs xor usb_debug snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda
_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec pcspkr serio_raw shpchp raid6_pq snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore e1000e ptp pps_c
ore
CPU: 3 PID: 5167 Comm: trinity-c4 Not tainted 3.18.0-rc2+ #79
 0000000000000009 0000000071bbcfa0 ffff880235ef3c48 ffffffffbd86ef44
 0000000000000000 0000000000000000 ffff880235ef3c88 ffffffffbd07f1f1
 ffff880235ef3c78 ffff880233e6eee8 ffff880089e4c0f8 0000000001a2978c
Call Trace:
 [<ffffffffbd86ef44>] dump_stack+0x4f/0x7c
 [<ffffffffbd07f1f1>] warn_slowpath_common+0x81/0xa0
 [<ffffffffbd07f30a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffbd19a68e>] add_event_to_ctx+0x1ce/0x1f0
 [<ffffffffbd1a03a3>] __perf_install_in_context+0xe3/0x1b0
 [<ffffffffbd19a0a3>] remote_function+0x53/0x70
 [<ffffffffbd19a050>] ? schedule_orphans_remove.part.49+0x60/0x60
 [<ffffffffbd1247b6>] generic_exec_single+0x156/0x1d0
 [<ffffffffbd19a050>] ? schedule_orphans_remove.part.49+0x60/0x60
 [<ffffffffbd124896>] smp_call_function_single+0x66/0x110
 [<ffffffffbd0f460e>] ? wait_rcu_gp+0x8e/0xb0
 [<ffffffffbd198f93>] task_function_call+0x53/0x80
 [<ffffffffbd1a02c0>] ? perf_cpu_hrtimer_handler+0x260/0x260
 [<ffffffffbd19a733>] perf_install_in_context+0x83/0xf0
 [<ffffffffbd1a4d80>] SYSC_perf_event_open+0xb70/0xc70
 [<ffffffffbd3ebf27>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffffbd1a52c9>] SyS_perf_event_open+0x9/0x10
 [<ffffffffbd87a009>] tracesys_phase2+0xd4/0xd9
---[ end trace 88ffecbb23768dcb ]---


1133         WARN_ON_ONCE(event->attach_state & PERF_ATTACH_CONTEXT);

