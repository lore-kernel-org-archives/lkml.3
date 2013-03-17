Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3CQTGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab3CQTGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:06:43 -0400
Date: Sun, 17 Mar 2013 20:04:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing: syscall_regfunc() should not skip kernel
	threads
Message-ID: <20130317190438.GA24582@redhat.com>
References: <20130317182834.GA22989@redhat.com> <1363546493.25967.129.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363546493.25967.129.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Steven Rostedt wrote:
>
> On Sun, 2013-03-17 at 19:28 +0100, Oleg Nesterov wrote:
> > syscall_regfunc() ignores the kernel thread because "it has
> > no effect", see cc3b13c1 "Don't trace kernel thread syscalls".
> >
> > However, this means that a user-space task spawned by
> > call_usermodehelper() won't report the system calls if
> > kernel_execve() is called when sys_tracepoint_refcount != 0.
> >
> > Remove this check. Hopefully the unnecessary report from
> > ret_from_fork path mentioned by cc3b13c1 is fine. In fact
> > "this is the only case" is not true. Say, kernel_execve()
> > itself does "int 80" on X86_32. Hopefully fine too.
>
> I'm really thinking the TIF_SYSCALL_TRACEPOINT flag is getting a bit
> ridiculous. We really should have a "swap syscall table when tracepoints
> enabled" that changes the syscall table that does exactly the same thing
> as the normal table but wraps the system call with the tracepoints.

But we also need to force the slow path in system_call...

Anyway, do you agree with this change for now?

Oleg.

