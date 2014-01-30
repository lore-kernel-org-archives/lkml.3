Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaA3FAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:00:47 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:48879 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751975AbaA3FAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:00:45 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 00:00:45 EST
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::,RULES_HIT:41:152:355:379:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3872:3873:4321:4385:4605:5007:7652:7875:7903:8660:9121:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12555:13148:13230:13894:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sign04_4206b8eb64160
X-Filterd-Recvd-Size: 2853
User-Agent: K-9 Mail for Android
In-Reply-To: <20140130041622.GA23875@redhat.com>
References: <20140130041622.GA23875@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 29 Jan 2014 23:50:43 -0500
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <cbf0c86a-317e-451f-9bb4-48c582ab4e1e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you running as root?  If not, you found another way to get perf to start function tracing.

-- Steve


Dave Jones <davej@redhat.com> wrote:
>WARNING: CPU: 3 PID: 796 at kernel/trace/ftrace.c:1655
>__ftrace_hash_rec_update.part.38+0x20a/0x240()
>CPU: 3 PID: 796 Comm: trinity-main Not tainted 3.13.0+ #100 
> 0000000000000009 000000003628f1c9 ffff8802395dfc48 ffffffffb1737a8a
> 0000000000000000 ffff8802395dfc80 ffffffffb106d28d 0000000000000000
> 0000000000000001 ffff880221165000 0000000000000000 ffff8801db17c9d8
>Call Trace:
> [<ffffffffb1737a8a>] dump_stack+0x4e/0x7a
> [<ffffffffb106d28d>] warn_slowpath_common+0x7d/0xa0
> [<ffffffffb106d3ba>] warn_slowpath_null+0x1a/0x20
> [<ffffffffb112128a>] __ftrace_hash_rec_update.part.38+0x20a/0x240
> [<ffffffffb1122fff>] ftrace_shutdown+0x1ff/0x330
> [<ffffffffb11234f0>] unregister_ftrace_function+0x20/0x40
> [<ffffffffb1141a57>] perf_ftrace_event_register+0x87/0x130
> [<ffffffffb11418bc>] perf_trace_destroy+0x2c/0x50
> [<ffffffffb114cec9>] tp_perf_event_destroy+0x9/0x10
> [<ffffffffb114e4b5>] __free_event+0x25/0xb0
> [<ffffffffb114e5b7>] free_event+0x77/0x100
> [<ffffffffb114e6a4>] perf_event_release_kernel+0x64/0x90
> [<ffffffffb114ecdf>] put_event+0xdf/0x130
> [<ffffffffb114ec30>] ? put_event+0x30/0x130
> [<ffffffffb114ed40>] perf_release+0x10/0x20
> [<ffffffffb11c9c4a>] __fput+0xea/0x2c0
> [<ffffffffb11c9e6e>] ____fput+0xe/0x10
> [<ffffffffb1090a24>] task_work_run+0xb4/0xe0
> [<ffffffffb106e835>] do_exit+0x2e5/0xb40
> [<ffffffffb174ac7f>] ? ftrace_call+0x5/0x2f
> [<ffffffffb107007c>] do_group_exit+0x4c/0xc0
> [<ffffffffb1070104>] SyS_exit_group+0x14/0x20
> [<ffffffffb174b1e4>] tracesys+0xdd/0xe2
>---[ end trace f3c5dcf3f350edcc ]---
>
>
>1655                         if (FTRACE_WARN_ON((rec->flags &
>~FTRACE_FL_MASK) == 0))
>1656                                 return;
>
>
>This old friend came back. I first reported this back in July, and we
>aparently never
>got to the bottom of it.
>
>	Dave

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
