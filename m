Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaA0Rjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaA0Rjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:39:44 -0500
Date: Mon, 27 Jan 2014 18:39:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127173931.GB32450@redhat.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com> <20140127102759.GY11314@laptop.programming.kicks-ass.net> <20140127113627.GC10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127113627.GC10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Al Viro wrote:
>
> BTW, there's an additional pile of obfuscation:
> /* work to do on interrupt/exception return */
> #define _TIF_WORK_MASK                                                  \
>         (0x0000FFFF &                                                   \
>          ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|                       \
>            _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
>
> /* work to do on any return to user space */
> #define _TIF_ALLWORK_MASK                                               \
>         ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |       \
>         _TIF_NOHZ)

Heh, yes ;)

> Why is _TIF_UPROBE *not* a part
> of _TIF_DO_NOTIFY_MASK, for example?

Yes, please see another email. That is why uprobe_deny_signal()
sets TIF_NOTIFY_RESUME along with TIF_UPROBE.

Oleg.

