Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3JAD4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:56:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:25544 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755937Ab3JAD4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:56:21 -0400
Message-ID: <1380599766.16752.6.camel@pippen.local.home>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 30 Sep 2013 23:56:06 -0400
In-Reply-To: <20130930171201.GA10474@redhat.com>
References: <20130828034627.GA30596@redhat.com>
	 <20130828095408.37c3dd83@gandalf.local.home>
	 <20130828095833.103ccdf0@gandalf.local.home>
	 <20130828111746.35369b84@gandalf.local.home>
	 <20130828182710.GA14103@redhat.com> <20130828182902.GB14103@redhat.com>
	 <20130828152745.18a73c4e@gandalf.local.home>
	 <20130930171201.GA10474@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 13:12 -0400, Dave Jones wrote:
> On Wed, Aug 28, 2013 at 03:27:45PM -0400, Steven Rostedt wrote:
> 
>  > > [ 6619.050768] WARNING: CPU: 1 PID: 16351 at kernel/trace/ftrace.c:1640 __ftrace_hash_rec_update.part.37+0x20a/0x240()
>  > > [ 6619.053767] Modules linked in: lec snd_seq_dummy bridge stp fuse tun bnep hidp rfcomm nfnetlink ipt_ULOG scsi_transport_iscsi can_bcm can_raw nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc e1000e ptp snd_timer pcspkr pps_core snd soundcore usb_debug
>  > > [ 6619.060523] CPU: 1 PID: 16351 Comm: trinity-child2 Not tainted 3.11.0-rc7+ #31 
>  > > [ 6619.062161]  ffffffff81a21901 ffff8802267b9ce0 ffffffff816f9e4f 0000000000000000
>  > > [ 6619.063733]  ffff8802267b9d18 ffffffff81052dcd 0000000000000000 0000000000000001
>  > > [ 6619.065309]  ffff8802203a3000 0000000000000000 ffff880225e962d0 ffff8802267b9d28
>  > > [ 6619.066895] Call Trace:
>  > > [ 6619.068437]  [<ffffffff816f9e4f>] dump_stack+0x54/0x74
>  > > [ 6619.070046]  [<ffffffff81052dcd>] warn_slowpath_common+0x7d/0xa0
>  > > [ 6619.071642]  [<ffffffff81052eaa>] warn_slowpath_null+0x1a/0x20
>  > > [ 6619.073224]  [<ffffffff81115d1a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
>  > > [ 6619.074817]  [<ffffffff81117e18>] ftrace_shutdown+0xb8/0x160
>  > > [ 6619.076399]  [<ffffffff811182a0>] unregister_ftrace_function+0x30/0x50
>  > > [ 6619.077983]  [<ffffffff81135e57>] perf_ftrace_event_register+0x87/0x150
>  > > [ 6619.079565]  [<ffffffff81135cdc>] perf_trace_destroy+0x2c/0x50
>  > > [ 6619.081180]  [<ffffffff8113df49>] tp_perf_event_destroy+0x9/0x10
>  > > [ 6619.082742]  [<ffffffff81140527>] free_event+0xa7/0x300
>  > > [ 6619.084264]  [<ffffffff81141620>] __perf_event_exit_task+0xe0/0x130
>  > > [ 6619.085792]  [<ffffffff8114a491>] perf_event_exit_task+0x1f1/0x230
>  > > [ 6619.087329]  [<ffffffff810546dd>] do_exit+0x30d/0xcd0
>  > > [ 6619.088860]  [<ffffffff8170cfc0>] ? ftrace_call+0x5/0x2f
>  > > [ 6619.090460]  [<ffffffff8105643c>] do_group_exit+0x4c/0xc0
>  > > [ 6619.092036]  [<ffffffff810564c4>] SyS_exit_group+0x14/0x20
>  > > [ 6619.093614]  [<ffffffff8170d594>] tracesys+0xdd/0xe2
>  >
>  > The first failure disables function tracing completely, which is one of
>  > the causes to return an error, which triggered the warning I added.
>  > 
>  > I was hoping that it failed for another reason and then that would
>  > cause things to break. But you said the hash corruption happened first
>  > (the original bug), so that's not the case.
>  > 
>  > Back to staring at code.
> 
> Steve, any further thoughts on this ? I can't do more than a few hours of fuzz-testing
> without eventually running into this.

I'm currently traveling, but as it seems that you have a pretty good
reproducer, can trace what trinity does up to the point it crashes?

I think we can do that with other buffers. If you download the latest
trace-cmd, you can run:

trace-cmd record -e syscalls -B trinity trinity <args>

This will create a ftrace sub buffer called trinity and shouldn't be
affected by the other ftrace functions. Then it should trace all the
syscalls that trinity does. I guess a strace could be used too.

-- Steve


