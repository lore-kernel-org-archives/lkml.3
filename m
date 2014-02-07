Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaBGU2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:28:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20628 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751446AbaBGU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:28:16 -0500
Date: Fri, 7 Feb 2014 15:28:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [RFC - beta][PATCH] tracing: Introduce TRACE_MARKER() no
 argument trace event
Message-ID: <20140207152814.16e263ab@gandalf.local.home>
In-Reply-To: <20140207112357.35552998@gandalf.local.home>
References: <20140207112357.35552998@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014 11:23:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> The TRACE_MARKER() is basically an optimized version of TRACE_EVENT()
> with no arguments. It can be enabled and disabled the same way as any
> other event, and stays within the system it was created in.
> 
> Is this worth doing?
> 

I'm thinking no. And unless someone can give me a good reason that we
should have such a thing, I will Nack my own patch!

Johannes,

What's up with trace_iwlwifi_dev_irq()?  You are tracing it but not
saving any information. There's obviously a reason for the
iwl_pcie_isr() to be called (it's handling something). Does it do the
exact same thing every time?  No variables are needed then?

What I'm trying to say is, if you go through the trouble of inserting a
tracepoint into some location, might as well extract data from it.
Otherwise you are wasting space in memory. If all you want to know is
if the function was called or not, then simply use a kprobe or function
trace that function (noinline to allow ftrace to trace it).

Unless I get some feedback to why this is a good idea...

Nacked-myself-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
