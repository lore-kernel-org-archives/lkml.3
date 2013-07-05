Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3GEOx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:53:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3GEOx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:53:56 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=Aoph827sFY3SL0nWCQkA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373036034.22688.155.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Jul 2013 10:53:54 -0400
In-Reply-To: <20130705142629.GA325@redhat.com>
References: <20130705142629.GA325@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 10:26 -0400, Dave Jones wrote:
> WARNING: at kernel/trace/ftrace.c:1605 __ftrace_hash_rec_update.part.37+0x20a/0x240()
> Modules linked in: sctp libcrc32c snd_seq_dummy fuse tun rfcomm bnep scsi_transport_iscsi hidp nfnetlink can_bcm irda caif_socket nfc caif netrom crc_ccitt rose x25 appletalk ipt_ULOG rds bluetooth can_raw ipx phonet can rfkill af_802154 pppoe pppox p8023 llc2 af_key ppp_generic psnap p8022 atm llc slhc ax25 af_rxrpc snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq pcspkr snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer snd ptp soundcore pps_core
> CPU: 1 PID: 15820 Comm: trinity-child2 Not tainted 3.10.0+ #21
>  ffffffff81a1f20b ffff8801be9dfc60 ffffffff816f2120 0000000000000000
>  ffff8801be9dfc98 ffffffff8104ca81 0000000000000000 0000000000000001
>  ffff8801be424000 0000000000000000 ffff88022bd25518 ffff8801be9dfca8
> Call Trace:
>  [<ffffffff816f2120>] dump_stack+0x4e/0x82
>  [<ffffffff8104ca81>] warn_slowpath_common+0x61/0x80
>  [<ffffffff8104cb5a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111489a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
>  [<ffffffff811168a8>] ftrace_shutdown+0xb8/0x170
>  [<ffffffff81116d40>] unregister_ftrace_function+0x30/0x50
>  [<ffffffff81134487>] perf_ftrace_event_register+0x87/0x130
>  [<ffffffff811342ec>] perf_trace_destroy+0x2c/0x50
>  [<ffffffff8113caf9>] tp_perf_event_destroy+0x9/0x10
>  [<ffffffff8113f0f7>] free_event+0xa7/0x310
>  [<ffffffff8113f3c4>] perf_event_release_kernel+0x64/0x90
>  [<ffffffff8113f830>] put_event+0x120/0x1b0
>  [<ffffffff8113f740>] ? put_event+0x30/0x1b0
>  [<ffffffff8113f8d0>] perf_release+0x10/0x20
>  [<ffffffff811b7d15>] __fput+0xf5/0x2d0
>  [<ffffffff811b7fae>] ____fput+0xe/0x10
>  [<ffffffff8107798c>] task_work_run+0xac/0xe0
>  [<ffffffff81051d27>] do_exit+0x2c7/0xcd0
>  [<ffffffff81704b00>] ? ftrace_call+0x5/0x2f
>  [<ffffffff81053afc>] do_group_exit+0x4c/0xc0
>  [<ffffffff81053b84>] SyS_exit_group+0x14/0x20
>  [<ffffffff817050d4>] tracesys+0xdd/0xe2
> ---[ end trace df06ab36fcd44d8b ]---
> 
> 
> 1605                         if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
> 1606                                 return;
> 

Can you find an easy reproducer for this?

-- Steve


