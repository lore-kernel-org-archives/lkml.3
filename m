Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBZQPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:15:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33796 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751078AbaBZQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:15:44 -0500
Date: Wed, 26 Feb 2014 11:15:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Warn and notify if tracepoints are not
 loaded due to module taint
Message-ID: <20140226111542.15657cd6@gandalf.local.home>
In-Reply-To: <192956891.30659.1393418892222.JavaMail.zimbra@efficios.com>
References: <20140225191505.32b56105@gandalf.local.home>
	<188130295.30493.1393375141631.JavaMail.zimbra@efficios.com>
	<20140225194926.4eac5872@gandalf.local.home>
	<20140226085926.GF18404@twins.programming.kicks-ass.net>
	<192956891.30659.1393418892222.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 12:48:12 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > How about instead of a WARN, you use a normal KERN_ERR printk(). There's
> > no point to the entire WARN state dump, that's needlessly verbose.
> > 
> > When you have a normal error print you can have as many as are required
> > and put the mod name back in.
> 
> The good old printk KERN_ERR is a very good idea. I agree that WARN() is
> too verbose for our needs here.

Actually, it's not so bad for the WARN() after my last patch to only
allocate (or even process tracepoints) if mod->num_tracepionts is
greater than zero. I didn't realize you were wasting memory for all
modules that were loaded.

My fear with the KERN_ERR is that it wont be noticeable enough. Where
as a stack dump is something that will catch people's attention.

And as Rusty has said, if you are loading a module that is forced, or
something strange, it is broken. The failure of loading the tracepoints
of a module is a bug if the module happens to have tracepoints.

After the MOD_SIG fix, any failure should be a big banner bug. Either
they are using a forced module with tracepoints that should not be
loaded. Or they have tracepoints is a non-GPL module (which is also a
big no-no).

-- Steve
