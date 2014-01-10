Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaAJN5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:57:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaAJN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:35 -0500
Date: Fri, 10 Jan 2014 14:58:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Sergio Durigan Junior <sergiodj@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Message-ID: <20140110135802.GA26953@redhat.com>
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <52CEEF1F.90803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CEEF1F.90803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Pedro Alves wrote:
>
> On 01/07/2014 03:30 PM, Oleg Nesterov wrote:
> >
> > This way PTRACE_O_SYSCALL_* will work like other ptrace options which
> > ask to report an event.
>
> +10^6.  With PTRACE_SYSCALL/sysgood, we don't have a way to trace
> syscalls when single-stepping, which isn't much of a problem for
> strace, but of course is for GDB.  That is one of the things the
> new API should definitely sort out.

Hmm. I think this is a good point, but this needs more discussion.

So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
executes the "syscall" insn. What it should report?

syscall-entry looks obvious, PTRACE_EVENT_SYSCALL_ENTER should be
reported if PTRACE_O_SYSCALL_ENTER was set.

But what should syscall-exit do? Should it still report SIGSEGV as
it currently does, or should it report _SYSCALL_EXIT instead (if
PTRACE_O_SYSCALL_EXIT of course), or should it report both?

Oleg.

