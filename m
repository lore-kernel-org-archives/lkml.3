Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161170AbaDJTz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:55:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:18143 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753679AbaDJTz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:55:57 -0400
Date: Thu, 10 Apr 2014 15:55:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
 kernel threads
Message-ID: <20140410155554.44f88536@gandalf.local.home>
In-Reply-To: <20140410193820.GA15624@redhat.com>
References: <20140409170505.GA27638@redhat.com>
	<20140409170616.GC27638@redhat.com>
	<20140410092842.1f9a8760@gandalf.local.home>
	<20140410133855.GC12228@redhat.com>
	<20140410102816.24337ffe@gandalf.local.home>
	<20140410144655.GA25316@redhat.com>
	<20140410110848.64c3f25e@gandalf.local.home>
	<20140410175705.GB32332@redhat.com>
	<20140410181417.GA2104@redhat.com>
	<20140410151340.7d24aafd@gandalf.local.home>
	<20140410193820.GA15624@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 21:38:20 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> I _think_ that the kernel thread can only return from "call *%rbx" if
> it is no longer a kernel thread, iow, do_execve() was called.

Ah right. But only in special cases.

Actually, it only returns if the function in kernel_thread() returns,
and in the case of ____call_usermodehelper, it does an exec and
returns on success. But if it fails, it needs to call do_exit().

Thus, it's not sufficient to just say "only if do_execve is called" but
to say, if the handler that is called is only allowed to return iff it
did a execve first and succeeded.

-- Steve
