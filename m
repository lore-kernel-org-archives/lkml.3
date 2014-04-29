Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaD2TVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:21:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:61482 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932759AbaD2TVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:21:51 -0400
Date: Tue, 29 Apr 2014 15:21:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140429152148.5efd48f3@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1404291407180.22490@vincent-weaver-1.umelst.maine.edu>
References: <20140417142213.GA29338@gmail.com>
	<alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
	<20140417145418.GM11096@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
	<20140418152314.GY11182@twins.programming.kicks-ass.net>
	<20140418165958.GQ13658@twins.programming.kicks-ass.net>
	<20140418171516.GR13658@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
	<20140429085236.GO27561@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404291407180.22490@vincent-weaver-1.umelst.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 14:11:09 -0400 (EDT)
Vince Weaver <vincent.weaver@maine.edu> wrote:
 
> I've actually given up on source code inspection to figure out what's 
> going on in kernel/events/core.c.  What I do now is write simple test
> cases and do an ftrace function trace.  The results are often surprising.

You might want to remove this from the kernel/events/Makefile:


ifdef CONFIG_FUNCTION_TRACER
CFLAGS_REMOVE_core.o = -pg
endif

It will let you function trace more of what is happening.

-- Steve
