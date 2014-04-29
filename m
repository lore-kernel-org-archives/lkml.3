Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108AbaD2T0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:26:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:24518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964887AbaD2T0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:26:38 -0400
Date: Tue, 29 Apr 2014 15:26:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140429152637.590b2b04@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
	<20140417145418.GM11096@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
	<20140418152314.GY11182@twins.programming.kicks-ass.net>
	<20140418165958.GQ13658@twins.programming.kicks-ass.net>
	<20140418171516.GR13658@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
	<20140429094632.GP27561@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 14:21:56 -0400 (EDT)
Vince Weaver <vincent.weaver@maine.edu> wrote:
 
> Also trace-cmd is a pain to use.  Any suggested events I should trace 
> beyond the obvious?
> 
> Part of the problem is that despite what the documentation says it doesn't 
> look like you can combine the "-P pid" and "-c" children option, which 
> makes debugging a forking problem like this a lot harder to trace.

Yeah, I need kernel assistance to fix some of that.

> 
> It's sort of possible to get around that with a really complicated -F ""
> command line that does sudo back to me (don't want to fuzz as root) and 
> such, but still awkward.

I'll try to write up a patch that lets you use -P with -c. But due to
the (crappy) implementation with ptrace, trace-cmd needs to be a parent
of task.

In the mean time, you could run this as root:

 trace-cmd record -p function -F -c su non-root-user fuzz


-- Steve
