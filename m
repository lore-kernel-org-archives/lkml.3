Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaKSS3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:29:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:46858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaKSS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:29:29 -0500
Date: Wed, 19 Nov 2014 19:29:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] ftrace/x86/extable: Add is_ftrace_trampoline()
 function
In-Reply-To: <20141119103716.1aa83ac3@gandalf.local.home>
Message-ID: <alpine.DEB.2.11.1411191928090.3909@nanos>
References: <20141119033331.689278545@goodmis.org> <20141119034829.497125839@goodmis.org> <87mw7nppu0.fsf@sejong.aot.lge.com> <20141119103716.1aa83ac3@gandalf.local.home>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Tue, 18 Nov 2014 21:14:11 -0500
> Subject: [PATCH] ftrace/x86/extable: Add is_ftrace_trampoline() function
> 
> Stack traces that happen from function tracing check if the address
> on the stack is a __kernel_text_address(). That is, is the address
> kernel code. This calls core_kernel_text() which returns true
> if the address is part of the builtin kernel code. It also calls
> is_module_text_address() which returns true if the address belongs
> to module code.
> 
> But what is missing is ftrace dynamically allocated trampolines.
> These trampolines are allocated for individual ftrace_ops that
> call the ftrace_ops callback functions directly. But if they do a
> stack trace, the code checking the stack wont detect them as they
> are neither core kernel code nor module address space.
> 
> Adding another field to ftrace_ops that also stores the size of
> the trampoline assigned to it we can create a new function called
> is_ftrace_trampoline() that returns true if the address is a
> dynamically allocate ftrace trampoline. Note, it ignores trampolines
> that are not dynamically allocated as they will return true with
> the core_kernel_text() function.
> 
> Link: http://lkml.kernel.org/r/20141119034829.497125839@goodmis.org
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
