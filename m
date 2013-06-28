Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3F1WTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3F1WTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:19:13 -0400
Date: Fri, 28 Jun 2013 16:45:06 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/trace/ftrace.c:1605
 __ftrace_hash_rec_update.part.37+0x20a/0x240()
Message-ID: <20130628204506.GA9767@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130610234806.GA7069@redhat.com>
 <1370910794.9844.150.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370910794.9844.150.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 08:33:14PM -0400, Steven Rostedt wrote:
 > On Mon, 2013-06-10 at 19:48 -0400, Dave Jones wrote:
 > > 3.10-rc5 + the two patches referenced in the RCU thread from earlier.
 > > 
 > > 	Dave
 > > 
 > > [ 2313.381283] WARNING: at kernel/trace/ftrace.c:1605 __ftrace_hash_rec_update.part.37+0x20a/0x240()
 > 
 > Grumble,
 > 
 > Somehow the list of functions that perf enabled got out of sync with
 > what ftrace had. When perf disabled its list of functions from ftrace,
 > perf thought it had a function enabled that wasn't and ftrace cried
 > about that.
 > 
 > What does 'trinity-child2' do? and is this reproducible? I'll go and
 > investigate how perf integrates with ftrace to see if I can find how
 > things got out of sync.

Just hit this again on rc7. So 'reproducable' means "twice a month" apparently ;)
Though now that I have a fix for the lockups I was seeing, maybe I'll start
seeing this more frequently.

	Dave

[  393.396441] WARNING: at kernel/trace/ftrace.c:1605 __ftrace_hash_rec_update.part.37+0x20a/0x240()
[  393.400825] Modules linked in: fuse tun bnep rfcomm ipt_ULOG nfnetlink can_bcm scsi_transport_iscsi can_raw appletalk netrom bluetooth irda af_802154 phonet af_rxrpc nfc rfkill can af_key rose atm ipx p8023 psnap p8022 caif_socket caif crc_ccitt rds llc2 llc ax25 x25 pppoe pppox ppp_generic slhc snd_hda_codec_realtek coretemp hwmon kvm_intel kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec pcspkr snd_hwdep usb_debug snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc ptp snd_timer snd pps_core soundcore xfs libcrc32c
[  393.484160] CPU: 2 PID: 19336 Comm: trinity-child0 Not tainted 3.10.0-rc7+ #37 
[  393.502497]  ffffffff81a17636 ffff8801e49cdc68 ffffffff816e4662 ffff8801e49cdca0
[  393.507648]  ffffffff8104a0c1 0000000000000000 0000000000000001 ffff8801e3667000
[  393.512670]  0000000000000000 ffff8801f1f4cb40 ffff8801e49cdcb0 ffffffff8104a19a
[  393.520041] Call Trace:
[  393.521408]  [<ffffffff816e4662>] dump_stack+0x19/0x1b
[  393.525699]  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
[  393.529232]  [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
[  393.532732]  [<ffffffff8110e3aa>] __ftrace_hash_rec_update.part.37+0x20a/0x240
[  393.538897]  [<ffffffff811103b8>] ftrace_shutdown+0xb8/0x170
[  393.542390]  [<ffffffff81110850>] unregister_ftrace_function+0x30/0x50
[  393.547601]  [<ffffffff8112e247>] perf_ftrace_event_register+0x87/0x130
[  393.551518]  [<ffffffff8112e0ac>] perf_trace_destroy+0x2c/0x50
[  393.556096]  [<ffffffff81135e09>] tp_perf_event_destroy+0x9/0x10
[  393.559632]  [<ffffffff81137481>] free_event+0xa1/0x1c0
[  393.562751]  [<ffffffff81137604>] perf_event_release_kernel+0x64/0x90
[  393.568341]  [<ffffffff811388a0>] put_event+0x120/0x1b0
[  393.571456]  [<ffffffff811387b0>] ? put_event+0x30/0x1b0
[  393.574813]  [<ffffffff81138940>] perf_release+0x10/0x20
[  393.577944]  [<ffffffff811af115>] __fput+0xf5/0x2d0
[  393.580749]  [<ffffffff811af3ae>] ____fput+0xe/0x10
[  393.585035]  [<ffffffff8107464c>] task_work_run+0xac/0xe0
[  393.588187]  [<ffffffff8104f35b>] do_exit+0x2bb/0xcd0
[  393.592297]  [<ffffffff816f5780>] ? ftrace_call+0x5/0x2f
[  393.598091]  [<ffffffff8105115c>] do_group_exit+0x4c/0xc0
[  393.602355]  [<ffffffff810511e4>] SyS_exit_group+0x14/0x20
[  393.608055]  [<ffffffff816f5d54>] tracesys+0xdd/0xe2
[  393.620867] ---[ end trace 113d10486f2930c4 ]---

