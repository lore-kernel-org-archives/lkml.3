Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaA3EQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 23:16:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaA3EQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 23:16:32 -0500
Date: Wed, 29 Jan 2014 23:16:22 -0500
From: Dave Jones <davej@redhat.com>
To: rostedt@goodmis.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20140130041622.GA23875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, rostedt@goodmis.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 3 PID: 796 at kernel/trace/ftrace.c:1655 __ftrace_hash_rec_update.part.38+0x20a/0x240()
CPU: 3 PID: 796 Comm: trinity-main Not tainted 3.13.0+ #100 
 0000000000000009 000000003628f1c9 ffff8802395dfc48 ffffffffb1737a8a
 0000000000000000 ffff8802395dfc80 ffffffffb106d28d 0000000000000000
 0000000000000001 ffff880221165000 0000000000000000 ffff8801db17c9d8
Call Trace:
 [<ffffffffb1737a8a>] dump_stack+0x4e/0x7a
 [<ffffffffb106d28d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffffb106d3ba>] warn_slowpath_null+0x1a/0x20
 [<ffffffffb112128a>] __ftrace_hash_rec_update.part.38+0x20a/0x240
 [<ffffffffb1122fff>] ftrace_shutdown+0x1ff/0x330
 [<ffffffffb11234f0>] unregister_ftrace_function+0x20/0x40
 [<ffffffffb1141a57>] perf_ftrace_event_register+0x87/0x130
 [<ffffffffb11418bc>] perf_trace_destroy+0x2c/0x50
 [<ffffffffb114cec9>] tp_perf_event_destroy+0x9/0x10
 [<ffffffffb114e4b5>] __free_event+0x25/0xb0
 [<ffffffffb114e5b7>] free_event+0x77/0x100
 [<ffffffffb114e6a4>] perf_event_release_kernel+0x64/0x90
 [<ffffffffb114ecdf>] put_event+0xdf/0x130
 [<ffffffffb114ec30>] ? put_event+0x30/0x130
 [<ffffffffb114ed40>] perf_release+0x10/0x20
 [<ffffffffb11c9c4a>] __fput+0xea/0x2c0
 [<ffffffffb11c9e6e>] ____fput+0xe/0x10
 [<ffffffffb1090a24>] task_work_run+0xb4/0xe0
 [<ffffffffb106e835>] do_exit+0x2e5/0xb40
 [<ffffffffb174ac7f>] ? ftrace_call+0x5/0x2f
 [<ffffffffb107007c>] do_group_exit+0x4c/0xc0
 [<ffffffffb1070104>] SyS_exit_group+0x14/0x20
 [<ffffffffb174b1e4>] tracesys+0xdd/0xe2
---[ end trace f3c5dcf3f350edcc ]---


1655                         if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
1656                                 return;


This old friend came back. I first reported this back in July, and we aparently never
got to the bottom of it.

	Dave

