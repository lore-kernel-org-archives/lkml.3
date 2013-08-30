Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3H3D5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:57:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3H3D5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:57:33 -0400
Date: Thu, 29 Aug 2013 23:57:16 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf_swevent_add warn_on.
Message-ID: <20130830035716.GA3713@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 2 PID: 7498 at kernel/events/core.c:5485 perf_swevent_add+0x18d/0x1a0()
Modules linked in: snd_seq_dummy 8021q garp stp fuse tun rfcomm hidp nfnetlink ipt_ULOG nfc caif_socket caif af_802154 phonet af_rxrpc bnep bluetooth can_bcm rfkill can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt scsi_transport_iscsi rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e usb_debug ptp soundcore pps_core pcspkr
CPU: 2 PID: 7498 Comm: trinity-child1 Not tainted 3.11.0-rc7+ #32 
 ffffffff81a228d4 ffff88022ea55a70 ffffffff816fa71e 0000000000000000
 ffff88022ea55aa8 ffffffff81052ebd ffff88022d147000 ffff88024d9cf3e0
 0000000000000003 0000000000000001 0000000009527bd7 ffff88022ea55ab8
Call Trace:
 [<ffffffff816fa71e>] dump_stack+0x54/0x74
 [<ffffffff81052ebd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81052f9a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8113ea2d>] perf_swevent_add+0x18d/0x1a0
 [<ffffffff8113f4e7>] event_sched_in.isra.75+0x87/0x1c0
 [<ffffffff8114035a>] group_sched_in+0x6a/0x1c0
 [<ffffffff81140f21>] ctx_sched_in+0x101/0x290
 [<ffffffff81141110>] perf_event_sched_in+0x60/0x90
 [<ffffffff81144c0b>] perf_event_context_sched_in+0x7b/0xc0
 [<ffffffff81145777>] __perf_event_task_sched_in+0x477/0x490
 [<ffffffff81098c74>] ? arch_vtime_task_switch+0x94/0xa0
 [<ffffffff8108cb70>] finish_task_switch+0xf0/0x130
 [<ffffffff817015fd>] __schedule+0x34d/0x970
 [<ffffffff81701c49>] schedule+0x29/0x70
 [<ffffffff810831b4>] do_cpu_nanosleep+0x154/0x250
 [<ffffffff8108316b>] ? do_cpu_nanosleep+0x10b/0x250
 [<ffffffff810833c9>] posix_cpu_nsleep+0x69/0x120
 [<ffffffff81083493>] process_cpu_nsleep+0x13/0x20
 [<ffffffff8107feaa>] SyS_clock_nanosleep+0x9a/0x110
 [<ffffffff8170ded4>] tracesys+0xdd/0xe2
---[ end trace 809ae0fc0cbb6fcc ]---


5484         head = find_swevent_head(swhash, event);
5485         if (WARN_ON_ONCE(!head))
5486                 return -EINVAL;
5487 

