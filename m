Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3IMO6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:58:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54962 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3IMO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:58:21 -0400
Date: Fri, 13 Sep 2013 16:58:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913145810.GH21832@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913111447.GN31370@twins.programming.kicks-ass.net>
 <20130913142856.GB6799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913142856.GB6799@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:28:56AM -0400, Dave Jones wrote:
> With that, I now get a different bug... yay?
> 
> [  212.012514] WARNING: CPU: 1 PID: 575 at kernel/events/core.c:1109 add_event_to_ctx+0x1fd/0x210()
> [  212.016034] Modules linked in: pppoe pppox ppp_generic slhc ipt_ULOG can_raw can scsi_transport_iscsi nfnetlink af_802154 nfc rfkill irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e usb_debug soundcore ptp pps_core pcspkr
> [  212.026484] CPU: 1 PID: 575 Comm: trinity-child11 Not tainted 3.11.0+ #75 
> [  212.031121]  ffffffff81a2b40e ffff88023087dcc0 ffffffff81720482 0000000000000000
> [  212.033279]  ffff88023087dcf8 ffffffff810540bd ffff88024197e418 ffff88023976ae68
> [  212.035471]  ffff88024197e418 000000007b016bc1 ffff8802419a9530 ffff88023087dd08
> [  212.037549] Call Trace:
> [  212.038277]  [<ffffffff81720482>] dump_stack+0x54/0x74
> [  212.039604]  [<ffffffff810540bd>] warn_slowpath_common+0x7d/0xa0
> [  212.040946]  [<ffffffff8105419a>] warn_slowpath_null+0x1a/0x20
> [  212.042296]  [<ffffffff8114383d>] add_event_to_ctx+0x1fd/0x210
> [  212.043650]  [<ffffffff81149a36>] __perf_install_in_context+0x136/0x260
> [  212.045147]  [<ffffffff811434a0>] ? rcu_read_lock_held+0x50/0x50
> [  212.046523]  [<ffffffff811434e0>] remote_function+0x40/0x50
> [  212.047759]  [<ffffffff810cc670>] smp_call_function_single+0x190/0x1e0
> [  212.048337]  [<ffffffff8107d969>] ? wait_rcu_gp+0x79/0xa0
> [  212.048374]  [<ffffffff810cc4e5>] ? smp_call_function_single+0x5/0x1e0
> [  212.048418]  [<ffffffff811423c4>] task_function_call+0x44/0x50
> [  212.048458]  [<ffffffff81149900>] ? perf_cpu_hrtimer_handler+0x1f0/0x1f0
> [  212.048502]  [<ffffffff811438d7>] perf_install_in_context+0x87/0x100
> [  212.048546]  [<ffffffff8114eebc>] SYSC_perf_event_open+0xcec/0xea0
> [  212.048590]  [<ffffffff8114f449>] SyS_perf_event_open+0x9/0x10
> [  212.048629]  [<ffffffff81733d54>] tracesys+0xdd/0xe2

Hmm.. seems somewhat connected to your earlier list corruption. I'm
going over that code as we speak, but its 5pm on a friday, need to run
soon.

Could you attach that trinity patch to an email? Maybe I can reproduce
locally tonight or tomorrow.
