Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaKEKqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:46:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58868 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaKEKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:46:46 -0500
Date: Wed, 5 Nov 2014 11:46:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [for-next][PATCH 3/4] ftrace/x86: Allow !CONFIG_PREEMPT dynamic
 ops to use allocated trampolines
Message-ID: <20141105104643.GC5245@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
 <20141027182948.581142569@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141027182948.581142569@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:27:05PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When the static ftrace_ops (like function tracer) enables tracing, and it
> is the only callback that is referencing a function, a trampoline is
> dynamically allocated to the function that calls the callback directly
> instead of calling a loop function that iterates over all the registered
> ftrace ops (if more than one ops is registered).
> 
> But when it comes to dynamically allocated ftrace_ops, where they may be
> freed, on a CONFIG_PREEMPT kernel there's no way to know when it is safe
> to free the trampoline. If a task was preempted while executing on the
> trampoline, there's currently no way to know when it will be off that
> trampoline.
> 
> But this is not true when it comes to !CONFIG_PREEMPT. The current method
> of calling schedule_on_each_cpu() will force tasks off the trampoline,
> becaues they can not schedule while on it (kernel preemption is not
> configured). That means it is safe to free a dynamically allocated
> ftrace ops trampoline when CONFIG_PREEMPT is not configured.
> 
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
