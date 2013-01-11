Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3AKB6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:58:40 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:2847 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab3AKB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:58:39 -0500
X-Forefront-Antispam-Report: CIP:132.245.2.69;KIP:(null);UIP:(null);IPV:NLI;H:BN1PRD0712HT003.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: PS-1(zz1443Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h1155h)
Message-ID: <50EF71C9.4010907@caviumnetworks.com>
Date: Thu, 10 Jan 2013 17:58:33 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips <linux-mips@linux-mips.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Ftrace test failure on MIPS - Looking for insight..
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I am trying to track down the cause of:

.
.
.
Brought up 32 CPUs
Testing tracer function: PASSED
Testing dynamic ftrace: .. filter failed count=0 ..FAILED!
------------[ cut here ]------------
WARNING: at kernel/trace/trace.c:878 register_tracer+0x23c/0x300()
Modules linked in:
Call Trace:
[<ffffffff815a0578>] dump_stack+0x14/0x40
[<ffffffff8113e8fc>] warn_slowpath_common+0x84/0xb0
[<ffffffff811bd04c>] register_tracer+0x23c/0x300
[<ffffffff81100538>] do_one_initcall+0x110/0x178
[<ffffffff8159234c>] kernel_init+0x174/0x318
[<ffffffff81119de4>] ret_from_kernel_thread+0x14/0x1c

---[ end trace 204112383c2d190e ]---
.
.
.


This is a MIPS64 kernel build from Linus' tree of today (commit 
254adaa465c40151df11fc1f88f93e6e86eb61d4)

I think the failure is long standing (since 3.4.x at least).

If you have any ideas off the top of your head as to what the cause 
might be, I would love to hear them.

In any event, I will try to track down the root cause and fix it.  But 
if something jumped out at you, that could speed up my search for the cause.


Thanks in advance,
David Daney

