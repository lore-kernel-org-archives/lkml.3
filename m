Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaKSSjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:39:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30543 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754641AbaKSSi7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:38:59 -0500
Date: Wed, 19 Nov 2014 13:38:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 1/2] ftrace/x86: Add frames pointers to trampoline as
 necessary
Message-ID: <20141119133856.411b0b34@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.11.1411191926150.3909@nanos>
References: <20141119033331.689278545@goodmis.org>
	<20141119034829.355440340@goodmis.org>
	<alpine.DEB.2.11.1411191926150.3909@nanos>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 19:26:48 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 18 Nov 2014, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > When CONFIG_FRAME_POINTERS are enabled, it is required that the
> > ftrace_caller and ftrace_regs_caller trampolines set up frame pointers
> > otherwise a stack trace from a function call wont print the functions
> > that called the trampoline. This is due to a check in
> > __save_stack_address():
> > 
> >  #ifdef CONFIG_FRAME_POINTER
> > 	if (!reliable)
> > 		return;
> >  #endif
> > 
> > The "reliable" variable is only set if the function address is equal to
> > contents of the address before the address the frame pointer register
> > points to. If the frame pointer is not set up for the ftrace caller
> > then this will fail the reliable test. It will miss the function that
> > called the trampoline. Worse yet, if fentry is used (gcc 4.6 and
> > beyond), it will also miss the parent, as the fentry is called before
> > the stack frame is set up. That means the bp frame pointer points
> > to the stack of just before the parent function was called.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Shouldn't this be tagged stable?

>From the cover letter:

"I stated testing the other triggers and discovered two other bugs.
One was caused by my latest changes, but the other one has been in
mainline for some time. It's been there since 3.16, and I haven't
tested it further. It's not that big of a bug so I'm not labeling
it with stable."

I guess I can tag it. I have to see how far back it goes. My configs
for the kernels I use this with didn't have FRAME_POINTER enabled, so I
never noticed. I noticed it with my test configs.

> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 

Thanks!

-- Steve
