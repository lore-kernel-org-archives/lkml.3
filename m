Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3H1Dqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 23:46:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab3H1Dqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 23:46:38 -0400
Date: Tue, 27 Aug 2013 23:46:27 -0400
From: Dave Jones <davej@redhat.com>
To: rostedt@goodmis.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828034627.GA30596@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, rostedt@goodmis.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 0 PID: 8961 at kernel/trace/ftrace.c:1640 __ftrace_hash_rec_update.part.37+0x20a/0x240()
Modules linked in: bridge stp fuse hidp bnep rfcomm nfnetlink ipt_ULOG scsi_transport_iscsi can_bcm nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec pcspkr snd_hwdep usb_debug snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e ptp soundcore pps_core
CPU: 0 PID: 8961 Comm: trinity-child4 Not tainted 3.11.0-rc7+ #30 
 ffffffff81a21901 ffff880210039c60 ffffffff816f9e2f 0000000000000000
 ffff880210039c98 ffffffff81052dcd 0000000000000000 0000000000000001
 ffff8801cc5d2000 0000000000000000 ffff88022f357248 ffff880210039ca8
Call Trace:
 [<ffffffff816f9e2f>] dump_stack+0x54/0x74
 [<ffffffff81052dcd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81052eaa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81115d1a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
 [<ffffffff81117e18>] ftrace_shutdown+0xb8/0x160
 [<ffffffff811182a0>] unregister_ftrace_function+0x30/0x50
 [<ffffffff81135e57>] perf_ftrace_event_register+0x87/0x130
 [<ffffffff81135cdc>] perf_trace_destroy+0x2c/0x50
 [<ffffffff8113df29>] tp_perf_event_destroy+0x9/0x10
 [<ffffffff81140507>] free_event+0xa7/0x300
 [<ffffffff811407c4>] perf_event_release_kernel+0x64/0x90
 [<ffffffff811413c3>] put_event+0x133/0x1c0
 [<ffffffff811412c0>] ? put_event+0x30/0x1c0
 [<ffffffff81141460>] perf_release+0x10/0x20
 [<ffffffff811b969a>] __fput+0xfa/0x2e0
 [<ffffffff811b98ce>] ____fput+0xe/0x10
 [<ffffffff8107a2fc>] task_work_run+0xac/0xe0
 [<ffffffff8105469c>] do_exit+0x2cc/0xcd0
 [<ffffffff8170cfc0>] ? ftrace_call+0x5/0x2f
 [<ffffffff8105643c>] do_group_exit+0x4c/0xc0
 [<ffffffff810564c4>] SyS_exit_group+0x14/0x20
 [<ffffffff8170d594>] tracesys+0xdd/0xe2
---[ end trace e1bf4ddc241d086b ]---


1640                         if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
1641                                 return;


