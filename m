Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBOBtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 20:49:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaBOBtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 20:49:41 -0500
Date: Fri, 14 Feb 2014 20:49:04 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: task_ctx_sched_out WARN_ON triggered.
Message-ID: <20140215014904.GA14215@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>
References: <20140109154707.GB3714@redhat.com>
 <20140110104837.GL31570@twins.programming.kicks-ass.net>
 <20140121150953.GA2408@redhat.com>
 <20140129140744.GF9636@twins.programming.kicks-ass.net>
 <20140129153204.GB3229@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129153204.GB3229@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 04:32:04PM +0100, Peter Zijlstra wrote:
 > On Wed, Jan 29, 2014 at 03:07:44PM +0100, Peter Zijlstra wrote:
 > > Let me see if I can make a 'nice' function to dump state though, it
 > > might come in handy more often.
 > 
 > Compile tested only...

This took a while, but I finally got a trace out with this debugging stuff enabled.

	Dave

ctx->type = 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 12579 at kernel/events/core.c:2539 task_ctx_sched_out+0x503/0x8a0()
Modules linked in: nf_conntrack_netlink nf_conntrack pn_pep llc2 af_key rfcomm bnep snd_seq_dummy tun fuse hidp nfnetlink scsi_transport_iscsi can_raw can_bcm ipt_ULOG nfc caif_socket caif af_802154 phonet af_rxrpc can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 snd_hda_codec_hdmi xfs snd_hda_codec_realtek coretemp hwmon snd_hda_codec_generic x86_pkg_temp_thermal snd_hda_intel kvm_intel snd_hda_codec kvm btusb snd_hwdep bluetooth snd_seq snd_seq_device crct10dif_pclmul snd_pcm crc32c_intel e1000e ghash_clmulni_intel 6lowpan_iphc libcrc32c microcode rfkill snd_timer serio_raw pcspkr usb_debug shpchp snd ptp soundcore pps_core
CPU: 0 PID: 12579 Comm: trinity-c5 Not tainted 3.14.0-rc2+ #117
 0000000000000009 0000000044d442b6 ffff88009e1b7de0 ffffffff9972b1d1
 0000000000000000 ffff88009e1b7e18 ffffffff9906d0cd ffff88024d017700
 ffff8801185e5898 0000000000000282 ffff88023a892e60 ffff8801185e5898
Call Trace:
 [<ffffffff9972b1d1>] dump_stack+0x4e/0x7a
 [<ffffffff9906d0cd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff9906d1fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff991458f3>] task_ctx_sched_out+0x503/0x8a0
 [<ffffffff99148ea8>] perf_event_comm+0x108/0x260
 [<ffffffff99148da0>] ? perf_event_fork+0x20/0x20
 [<ffffffff991c4c95>] ? set_task_comm+0x25/0xc0
 [<ffffffff990a4f0d>] ? get_parent_ip+0xd/0x50
 [<ffffffff991c4cbf>] set_task_comm+0x4f/0xc0
 [<ffffffff99086ecb>] SyS_prctl+0x22b/0x3d0
 [<ffffffff9973ea2a>] tracesys+0xd4/0xd9
---[ end trace 6cce6761d7b505a6 ]---
Event (ffff880160cc6618) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 12611/trinity-c19
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x4,
	.inherit = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 1,
	.exclude_guest = 1,
  };
Event (ffff8800308e6f60) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 4,
	.config = 0x188688,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
  };
Event (ffff8800308e2520) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.config = 0x9,
	.read_format = 0x3,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff88018cc14a40) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 12579/trinity-c5
  group: 
  attr: {
	.type = 1,
	.sample_period = -2930868092,
	.sample_type = 0x2a2cc,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
	.wakeup_events = 62,
	.branch_sample_type = 0x7f,
  };
Event (ffff88018cc16618) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10057/trinity-c0
  group: 
  attr: {
	.type = 4,
	.config = 0x188688,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
  };
Event (ffff88018cc10000) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10057/trinity-c0
  group: 
  attr: {
	.config = 0x9,
	.read_format = 0x3,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff880160f00948) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 12579/trinity-c5
  group: 
  attr: {
	.type = 4,
	.config = 0x188688,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
  };
Event (ffff88001768ae68) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 12579/trinity-c5
  group: 
  attr: {
	.config = 0x9,
	.read_format = 0x3,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff8801845bd388) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.read_format = 0x4,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8801845b9bd8) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x2,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.watermark = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8801845bdcd0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x3,
	.read_format = 0x4,
	.inherit = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.task = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8801845ba520) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.type = 2,
	.config = 0x1f2,
	.read_format = 0x7,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
  };
Event (ffff8801845bca40) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.type = 3,
	.config = 0x10004,
	.read_format = 0x6,
	.disabled = 1,
	.inherit = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.comm = 1,
	.freq = 1,
	.exclude_guest = 1,
  };
Event (ffff88017805e618) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 11027/trinity-c0
  group: 
  attr: {
	.sample_period = -7740493,
	.sample_type = 0x8256,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.config2 = 0xf7b96f3ad77bde00,
	.branch_sample_type = 0x252525252525,
	.sample_regs_user = 0x767f77fba6,
	.sample_stack_user = 15445001,
  };
Event (ffff88014bec5cd0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10224/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.sample_period = -177,
	.sample_type = 0xc297,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.mmap = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_user = 1,
	.wakeup_watermark = 65534,
	.config2 = 0x800000000000d045,
	.branch_sample_type = 0x80007bc6773837ac,
	.sample_regs_user = 0x8800000002000000,
	.sample_stack_user = 15969317,
  };
Event (ffff88014bec37b0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10224/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x5,
	.read_format = 0x1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.task = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
  };
Event (ffff880013f31290) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10224/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x7,
	.read_format = 0x7,
	.inherit = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 3,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880013f32e68) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10224/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.sample_period = -256,
	.sample_type = 0x343be,
	.read_format = 0x5,
	.inherit = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.wakeup_watermark = 654166,
	.branch_sample_type = 0x40000000f99ffb2b,
  };
Event (ffff88015de4d388) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10155/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x3,
	.read_format = 0x5,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.freq = 1,
	.task = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88015de4dcd0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10155/trinity-c0
  group: 
  attr: {
	.type = 1,
	.sample_period = -9079256697865559261,
	.sample_type = 0x2027b,
	.read_format = 0x1,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.task = 1,
	.watermark = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.wakeup_watermark = 49254,
	.config2 = 0xffffffffffffffff,
  };
Event (ffff88015de4c0f8) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10155/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.read_format = 0x3,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.comm = 1,
	.freq = 1,
	.task = 1,
	.exclude_host = 1,
  };
Event (ffff880151288000) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10155/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.sample_period = -1,
	.sample_type = 0xc0ac,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_idle = 1,
	.precise_ip = 2,
	.exclude_callchain_kernel = 1,
	.wakeup_events = 255,
	.config1 = 0xba5010,
  };
Event (ffff88015128dcd0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10155/trinity-c0
  group: 
  attr: {
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.task = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880017688948) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 10057/trinity-c0
  group: 
  attr: {
	.type = 1,
	.sample_period = -2930868092,
	.sample_type = 0x2a2cc,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
	.wakeup_events = 62,
	.branch_sample_type = 0x7f,
  };
Event (ffff880187472e68) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 31680/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x4,
	.inherit = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 1,
	.exclude_guest = 1,
  };
Event (ffff880187472520) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 31680/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x7,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.comm = 1,
	.inherit_stat = 1,
	.precise_ip = 3,
	.mmap_data = 1,
  };
Event (ffff880187475388) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 31680/trinity-c0
  group: 
  attr: {
	.type = 1,
	.config = 0x9,
	.read_format = 0x1,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.freq = 1,
	.inherit_stat = 1,
	.task = 1,
	.precise_ip = 2,
  };
Event (ffff880187475cd0) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 31680/trinity-c0
  group: 
  attr: {
	.type = 5,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.freq = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.bp_type = 2,
	.bp_addr = 0x2026000,
	.bp_len = 2,
  };
Event (ffff880187471290) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 31680/trinity-c0
  group: 
  attr: {
	.type = 2,
	.config = 0x2ab,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88001da78948) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 3,
	.config = 0x10004,
	.read_format = 0x6,
	.disabled = 1,
	.inherit = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.comm = 1,
	.freq = 1,
	.exclude_guest = 1,
  };
Event (ffff88001da7d388) created by task: (null)
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.sample_period = -7740493,
	.sample_type = 0x8256,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.config2 = 0xf7b96f3ad77bde00,
	.branch_sample_type = 0x252525252525,
	.sample_regs_user = 0x767f77fba6,
	.sample_stack_user = 15445001,
  };
Event (ffff880203e840f8) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x4,
	.inherit = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 1,
	.exclude_guest = 1,
  };
Event (ffff8800295fdcd0) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.read_format = 0x9,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.sample_id_all = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8800295fef60) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x2,
	.read_format = 0x2,
	.disabled = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.enable_on_exec = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8800295fe618) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x7,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.comm = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.precise_ip = 3,
	.mmap_data = 1,
  };
Event (ffff8800295f9290) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x5,
	.sample_period = -7197,
	.sample_type = 0x3818b,
	.read_format = 0x2,
	.pinned = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.wakeup_events = 12470896,
	.config2 = 0x9b9b9b9b9b,
  };
Event (ffff8800295fd388) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x9,
	.read_format = 0x1,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.precise_ip = 2,
  };
Event (ffff88014be41bd8) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0x2ab,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88014be40948) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 5,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.freq = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.bp_type = 2,
	.bp_addr = 0x2026000,
	.bp_len = 2,
  };
Event (ffff88014be437b0) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.read_format = 0x5,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.exclude_host = 1,
  };
Event (ffff88014be42520) created by task: 7365/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7365/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.read_format = 0x3,
	.exclude_user = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880001d737b0) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x9,
	.read_format = 0x1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.task = 1,
	.watermark = 1,
	.sample_id_all = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880001d75388) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0xd1,
	.read_format = 0x8,
	.disabled = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88001dbedcd0) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 10215/trinity-c0
  group: 
  attr: {
	.type = 4,
	.config = 0x188688,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
  };
Event (ffff88001dbeb7b0) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0x483,
	.read_format = 0xd,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.precise_ip = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88001dbe9290) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 10215/trinity-c0
  group: 
  attr: {
	.config = 0x9,
	.read_format = 0x3,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff88001dbeca40) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x4,
	.read_format = 0x9,
	.disabled = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.enable_on_exec = 1,
	.precise_ip = 3,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff880184ccd388) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.read_format = 0xf,
	.disabled = 1,
	.pinned = 1,
	.exclusive = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880184cca520) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x7,
	.read_format = 0x6,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.enable_on_exec = 1,
	.watermark = 1,
	.precise_ip = 3,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff880184ccb7b0) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.sample_period = -2930868092,
	.sample_type = 0x2a2cc,
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
	.wakeup_events = 62,
	.branch_sample_type = 0x7f,
  };
Event (ffff880151b60948) created by task: 7371/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7371/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.exclusive = 1,
	.exclude_idle = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff880187518948) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0x3a,
	.sample_period = -15353201,
	.sample_type = 0x20782,
	.read_format = 0xf,
	.exclusive = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.inherit_stat = 1,
	.precise_ip = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.wakeup_events = 6319,
	.config1 = 0x8,
  };
Event (ffff88018751ca40) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.read_format = 0x4,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880187519290) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0x1f2,
	.read_format = 0x7,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
  };
Event (ffff88018751b7b0) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 21559/trinity-c0
  group: 
  attr: {
	.type = 3,
	.config = 0x10004,
	.read_format = 0x6,
	.disabled = 1,
	.inherit = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.comm = 1,
	.freq = 1,
	.exclude_guest = 1,
  };
Event (ffff88018751c0f8) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x7,
	.read_format = 0x7,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.task = 1,
	.precise_ip = 1,
	.mmap_data = 1,
  };
Event (ffff88018751e618) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x2,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.watermark = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88018751ae68) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x5,
	.read_format = 0x8,
	.disabled = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.comm = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
  };
Event (ffff88018751d388) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x3,
	.read_format = 0x4,
	.inherit = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.enable_on_exec = 1,
	.task = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8801007d5cd0) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7423/trinity-main
  group: 
  attr: {
	.type = 1,
	.read_format = 0x1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.watermark = 1,
	.sample_id_all = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff8801007d6f60) created by task: 7423/trinity-main
  cpu: -1
  cgrp: (null)
  task: 21559/trinity-c0
  group: 
  attr: {
	.sample_period = -7740493,
	.sample_type = 0x8256,
	.inherit = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.config2 = 0xf7b96f3ad77bde00,
	.branch_sample_type = 0x252525252525,
	.sample_regs_user = 0x767f77fba6,
	.sample_stack_user = 15445001,
  };
Event (ffff8801565740f8) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.sample_period = -256,
	.sample_type = 0x343be,
	.read_format = 0x5,
	.inherit = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.wakeup_watermark = 654166,
	.branch_sample_type = 0x40000000f99ffb2b,
  };
Event (ffff880028095cd0) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.config = 0x6,
	.read_format = 0x1,
	.pinned = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880028090000) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.read_format = 0xa,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880193711bd8) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.sample_period = -177,
	.sample_type = 0xc297,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.mmap = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_user = 1,
	.wakeup_watermark = 65534,
	.config2 = 0x800000000000d045,
	.branch_sample_type = 0x80007bc6773837ac,
	.sample_regs_user = 0x8800000002000000,
	.sample_stack_user = 15969317,
  };
Event (ffff880193710000) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 4,
	.config = 0x20000000c1a0c3f5,
	.sample_period = -32768,
	.sample_type = 0x304c7,
	.read_format = 0x4,
	.inherit = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.inherit_stat = 1,
	.exclude_host = 1,
	.exclude_callchain_user = 1,
	.wakeup_events = 65534,
	.config2 = 0x1,
  };
Event (ffff880193716618) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x5,
	.sample_period = -131872675856416,
	.sample_type = 0x1e7e4,
	.read_format = 0x9,
	.exclusive = 1,
	.exclude_kernel = 1,
	.mmap = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.wakeup_watermark = 472368239,
  };
Event (ffff88009e1a9bd8) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x5,
	.read_format = 0x1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.precise_ip = 3,
	.mmap_data = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
  };
Event (ffff880193714a40) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 5,
	.config = 0xfffffffffffffffc,
	.read_format = 0x4,
	.exclude_kernel = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.task = 1,
	.watermark = 1,
	.precise_ip = 2,
	.mmap_data = 1,
	.exclude_callchain_user = 1,
	.bp_type = 3,
	.bp_addr = 0x7fe9948b9000,
	.bp_len = 2,
  };
Event (ffff880193710948) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x7,
	.read_format = 0x7,
	.inherit = 1,
	.exclude_idle = 1,
	.comm = 1,
	.inherit_stat = 1,
	.watermark = 1,
	.precise_ip = 3,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880193711290) created by task: 7413/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7413/trinity-main
  group: 
  attr: {
	.type = 4,
	.config = 0x800000,
	.read_format = 0xc,
	.exclusive = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.config1 = 0x84000000000000fa,
  };
Event (ffff880013e20948) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x3,
	.read_format = 0x5,
	.inherit = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_guest = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880013e21290) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 5,
	.config = 0xffffffffffe3f5d5,
	.read_format = 0xf,
	.disabled = 1,
	.exclusive = 1,
	.exclude_hv = 1,
	.exclude_idle = 1,
	.freq = 1,
	.task = 1,
	.watermark = 1,
	.sample_id_all = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.bp_type = 2,
	.bp_len = 1,
  };
Event (ffff880013e24a40) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.sample_period = -9079256697865559261,
	.sample_type = 0x2027b,
	.read_format = 0x1,
	.disabled = 1,
	.inherit = 1,
	.exclusive = 1,
	.exclude_user = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.task = 1,
	.watermark = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
	.wakeup_watermark = 49254,
	.config2 = 0xffffffffffffffff,
  };
Event (ffff880013e22520) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.config = 0x4,
	.read_format = 0xa,
	.exclude_user = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.watermark = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
  };
Event (ffff880013e21bd8) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x1,
	.read_format = 0x5,
	.pinned = 1,
	.exclusive = 1,
	.mmap = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.watermark = 1,
	.sample_id_all = 1,
  };
Event (ffff880013e240f8) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 2,
	.config = 0x17f,
	.read_format = 0xb,
	.disabled = 1,
	.pinned = 1,
	.exclusive = 1,
	.exclude_kernel = 1,
	.exclude_idle = 1,
	.mmap = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.precise_ip = 1,
	.mmap_data = 1,
	.sample_id_all = 1,
	.exclude_guest = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff88002881b7b0) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x6,
	.read_format = 0x3,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.comm = 1,
	.freq = 1,
	.enable_on_exec = 1,
	.task = 1,
	.exclude_host = 1,
  };
Event (ffff88001768b7b0) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.read_format = 0x3,
	.disabled = 1,
	.inherit = 1,
	.exclude_user = 1,
	.exclude_kernel = 1,
	.exclude_hv = 1,
	.mmap = 1,
	.comm = 1,
	.freq = 1,
	.inherit_stat = 1,
	.enable_on_exec = 1,
	.task = 1,
	.exclude_host = 1,
	.exclude_callchain_kernel = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880005c05cd0) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x8,
	.sample_period = -1,
	.sample_type = 0xc0ac,
	.read_format = 0x5,
	.disabled = 1,
	.inherit = 1,
	.pinned = 1,
	.exclude_user = 1,
	.exclude_idle = 1,
	.precise_ip = 2,
	.exclude_callchain_kernel = 1,
	.wakeup_events = 255,
	.config1 = 0xba5010,
  };
Event (ffff880005c06f60) created by task: 7445/trinity-main
  cpu: -1
  cgrp: (null)
  task: 7445/trinity-main
  group: 
  attr: {
	.type = 1,
	.config = 0x1,
	.read_format = 0xe,
	.exclusive = 1,
	.enable_on_exec = 1,
	.task = 1,
	.mmap_data = 1,
	.exclude_callchain_user = 1,
  };
Event (ffff880244efa520) created by task: (null)
  cpu: 3
  cgrp: (null)
  task: (null)
  group: 
  attr: {
	.sample_period = 22945590000,
	.disabled = 1,
	.pinned = 1,
  };
Event (ffff880244efd388) created by task: (null)
  cpu: 2
  cgrp: (null)
  task: (null)
  group: 
  attr: {
	.sample_period = 22945590000,
	.disabled = 1,
	.pinned = 1,
  };
Event (ffff880244ef9bd8) created by task: (null)
  cpu: 1
  cgrp: (null)
  task: (null)
  group: 
  attr: {
	.sample_period = 22945590000,
	.disabled = 1,
	.pinned = 1,
  };
Event (ffff880244efdcd0) created by task: (null)
  cpu: 0
  cgrp: (null)
  task: (null)
  group: 
  attr: {
	.sample_period = 22945590000,
	.disabled = 1,
	.pinned = 1,
  };
