Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3KFVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:52:27 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:49577 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3KFVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:52:26 -0500
Date: Wed, 6 Nov 2013 17:00:37 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kees Cook <keescook@google.com>
Subject: Re: a different perf tracepoint bug
In-Reply-To: <20131106150437.7bccfb68@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1311061656250.27317@vincent-weaver-1.um.maine.edu>
References: <20131105162407.59393ee1@gandalf.local.home> <alpine.DEB.2.10.1311061444160.26837@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311061501450.26837@vincent-weaver-1.um.maine.edu> <20131106150437.7bccfb68@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Steven Rostedt wrote:

> > [11559.476002]  <<EOE>>  <IRQ>  [<ffffffff8104acaa>] ? __send_signal+0xd8/0x26f
> 
> Can you find the exact location of __send_signal()?

I'm not sure what you mean, but:

addr2line -e ./vmlinux ffffffff8104acaa
linux-kernel/linux-3.12/kernel/signal.c:1095

which is

        q = __sigqueue_alloc(sig, t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
                override_rlimit);
-->     if (q) {
                list_add_tail(&q->list, &pending->list);
                switch ((unsigned long) info) {
                case (unsigned long) SEND_SIG_NOINFO:
...


though this might just be a case where tracepoints are happening too 
quickly and the kernel gets stuck and can't keep up.  Previously I was
using a hacked kernel that made the watchdog continually print rather than 
just warn once, the better to see if any progress was being made.

Vince
