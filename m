Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaKSSjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:39:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:46146 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756228AbaKSSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:39:13 -0500
Date: Wed, 19 Nov 2014 13:39:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] ftrace/x86/extable: Add is_ftrace_trampoline()
 function
Message-ID: <20141119133911.1b030287@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.11.1411191928090.3909@nanos>
References: <20141119033331.689278545@goodmis.org>
	<20141119034829.497125839@goodmis.org>
	<87mw7nppu0.fsf@sejong.aot.lge.com>
	<20141119103716.1aa83ac3@gandalf.local.home>
	<alpine.DEB.2.11.1411191928090.3909@nanos>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 19:29:25 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 19 Nov 2014, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > Date: Tue, 18 Nov 2014 21:14:11 -0500
> > Subject: [PATCH] ftrace/x86/extable: Add is_ftrace_trampoline() function
> > 
> > Stack traces that happen from function tracing check if the address
> > on the stack is a __kernel_text_address(). That is, is the address
> > kernel code. This calls core_kernel_text() which returns true
> > if the address is part of the builtin kernel code. It also calls
> > is_module_text_address() which returns true if the address belongs
> > to module code.
> > 
> > But what is missing is ftrace dynamically allocated trampolines.
> > These trampolines are allocated for individual ftrace_ops that
> > call the ftrace_ops callback functions directly. But if they do a
> > stack trace, the code checking the stack wont detect them as they
> > are neither core kernel code nor module address space.
> > 
> > Adding another field to ftrace_ops that also stores the size of
> > the trampoline assigned to it we can create a new function called
> > is_ftrace_trampoline() that returns true if the address is a
> > dynamically allocate ftrace trampoline. Note, it ignores trampolines
> > that are not dynamically allocated as they will return true with
> > the core_kernel_text() function.
> > 
> > Link: http://lkml.kernel.org/r/20141119034829.497125839@goodmis.org
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

-- Steve
