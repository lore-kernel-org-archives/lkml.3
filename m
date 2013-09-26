Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3IZBl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3IZBl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:41:26 -0400
Date: Wed, 25 Sep 2013 21:41:12 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ftrace eperm BUG.
Message-ID: <20130926014112.GA1991@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 0 PID: 30602 at kernel/trace/ftrace.c:1701 ftrace_bug+0x206/0x270()
Modules linked in: fuse(+) bnep rfcomm hidp ipt_ULOG scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can_raw can_bcm can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq xfs crct10dif_pclmul crc32c_intel libcrc32c snd_seq_device ghash_clmulni_intel snd_pcm snd_page_alloc e1000e snd_timer usb_debug microcode pcspkr serio_raw snd ptp pps_core shpchp soundcore
CPU: 0 PID: 30602 Comm: modprobe Not tainted 3.12.0-rc2+ #85 
 ffffffff81a2ab24 ffff880238b2dc30 ffffffff81729bb7 0000000000000000
 ffff880238b2dc68 ffffffff8105523d 0000000000000000 ffffffffa0514000
 ffff88022e3a2f78 0000000000000000 ffff88022e187000 ffff880238b2dc78
Call Trace:
 [<ffffffff81729bb7>] dump_stack+0x4e/0x82
 [<ffffffff8105523d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffffa0514000>] ? 0xffffffffa0513fff
 [<ffffffff8105531a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811206e6>] ftrace_bug+0x206/0x270
 [<ffffffffa0514000>] ? 0xffffffffa0513fff
 [<ffffffff81120a5c>] ftrace_process_locs+0x30c/0x640
 [<ffffffff81120dce>] ftrace_module_notify_enter+0x3e/0x50
 [<ffffffff817382a6>] notifier_call_chain+0x66/0x150
 [<ffffffff8108b107>] __blocking_notifier_call_chain+0x67/0xc0
 [<ffffffff8108b176>] blocking_notifier_call_chain+0x16/0x20
 [<ffffffff810dad4d>] load_module+0x1f7d/0x26a0
 [<ffffffff810d5f00>] ? store_uevent+0x40/0x40
 [<ffffffff810db606>] SyS_finit_module+0x86/0xb0
 [<ffffffff8173cce4>] tracesys+0xdd/0xe2
---[ end trace 47a8e162ec529291 ]---
ftrace faulted on writing [<ffffffffa0514000>] fuse_dev_pipe_buf_steal+0x0/0x10 [fuse]

<total lock-up>
