Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3FJXsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3FJXsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:48:12 -0400
Date: Mon, 10 Jun 2013 19:48:06 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/trace/ftrace.c:1605
 __ftrace_hash_rec_update.part.37+0x20a/0x240()
Message-ID: <20130610234806.GA7069@redhat.com>
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

3.10-rc5 + the two patches referenced in the RCU thread from earlier.

	Dave

[ 2313.381283] WARNING: at kernel/trace/ftrace.c:1605 __ftrace_hash_rec_update.part.37+0x20a/0x240()
[ 2313.386619] Modules linked in: fuse bnep rfcomm hidp can_bcm nfnetlink scsi_transport_iscsi can_raw nfc ipt_ULOG pppoe pppox ppp_generic slhc rose can af_rxrpc netrom phonet bluetooth rds af_802154 caif_socket caif ipx atm rfkill p8023 af_key p8022 ax25 llc2 irda decnet crc_ccitt appletalk psnap x25 llc nfsv3 nfs_acl nfs lockd sunrpc fscache coretemp hwmon kvm_intel snd_hda_codec_realtek kvm crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e usb_debug ptp snd_page_alloc pps_core snd_timer snd soundcore xfs libcrc32c
[ 2313.411063] CPU: 1 PID: 19448 Comm: trinity-child2 Not tainted 3.10.0-rc5+ #7
[ 2313.424699]  ffffffff81a1739e ffff880234f23ab0 ffffffff816e395b ffff880234f23ae8
[ 2313.427336]  ffffffff8104a1b1 0000000000000000 0000000000000001 ffff8801b6c64000
[ 2313.429532]  0000000000000000 ffff8801b6c745a0 ffff880234f23af8 ffffffff8104a28a
[ 2313.431805] Call Trace:
[ 2313.433308]  [<ffffffff816e395b>] dump_stack+0x19/0x1b
[ 2313.435306]  [<ffffffff8104a1b1>] warn_slowpath_common+0x61/0x80
[ 2313.437254]  [<ffffffff8104a28a>] warn_slowpath_null+0x1a/0x20
[ 2313.439175]  [<ffffffff8110de3a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
[ 2313.441392]  [<ffffffff8110fe48>] ftrace_shutdown+0xb8/0x170
[ 2313.443301]  [<ffffffff811102e0>] unregister_ftrace_function+0x30/0x50
[ 2313.445449]  [<ffffffff8112d9c7>] perf_ftrace_event_register+0x87/0x130
[ 2313.447466]  [<ffffffff8112d82c>] perf_trace_destroy+0x2c/0x50
[ 2313.449389]  [<ffffffff81135469>] tp_perf_event_destroy+0x9/0x10
[ 2313.451336]  [<ffffffff81136bec>] free_event+0x6c/0x190
[ 2313.453186]  [<ffffffff81136d74>] perf_event_release_kernel+0x64/0x90
[ 2313.455299]  [<ffffffff81138010>] put_event+0x120/0x1b0
[ 2313.457152]  [<ffffffff81137f20>] ? put_event+0x30/0x1b0
[ 2313.459020]  [<ffffffff811380b0>] perf_release+0x10/0x20
[ 2313.460886]  [<ffffffff811ae4a5>] __fput+0xf5/0x2d0
[ 2313.462705]  [<ffffffff811ae73e>] ____fput+0xe/0x10
[ 2313.464697]  [<ffffffff810745ec>] task_work_run+0xac/0xe0
[ 2313.466571]  [<ffffffff8104f3b3>] do_exit+0x2b3/0xcd0
[ 2313.468400]  [<ffffffff81063709>] ? get_signal_to_deliver+0x299/0x940
[ 2313.470402]  [<ffffffff810511bc>] do_group_exit+0x4c/0xc0
[ 2313.472279]  [<ffffffff81063751>] get_signal_to_deliver+0x2e1/0x940
[ 2313.474264]  [<ffffffff81002418>] do_signal+0x48/0x5a0
[ 2313.476266]  [<ffffffff8108cdad>] ? get_parent_ip+0xd/0x50
[ 2313.478153]  [<ffffffff810029e8>] do_notify_resume+0x78/0x90
[ 2313.480059]  [<ffffffff816f510a>] int_signal+0x12/0x17
[ 2313.514533] ---[ end trace 0677af9739c508fb ]---

