Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaAIStX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:49:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbaAIStN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:49:13 -0500
Message-ID: <52CEEF1F.90803@redhat.com>
Date: Thu, 09 Jan 2014 18:49:03 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Sergio Durigan Junior <sergiodj@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com>
In-Reply-To: <20140107153036.GA4749@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 03:30 PM, Oleg Nesterov wrote:
> 
> If we add the new API, perhaps we should change ptrace_resume ?
> I mean,
> 
> 	--- x/kernel/ptrace.c
> 	+++ x/kernel/ptrace.c
> 	@@ -723,7 +723,9 @@ static int ptrace_resume(struct task_str
> 		if (!valid_signal(data))
> 			return -EIO;
> 	 
> 	-	if (request == PTRACE_SYSCALL)
> 	+	if (request == PTRACE_SYSCALL ||
> 	+	    ptrace_event_enabled(PTRACE_EVENT_SYSCALL_ENTER) ||
> 	+	    ptrace_event_enabled(PTRACE_EVENT_SYSCALL_EXIT))
> 			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> 		else
> 			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> 
> 
> This way PTRACE_O_SYSCALL_* will work like other ptrace options which
> ask to report an event.

+10^6.  With PTRACE_SYSCALL/sysgood, we don't have a way to trace
syscalls when single-stepping, which isn't much of a problem for
strace, but of course is for GDB.  That is one of the things the
new API should definitely sort out.

-- 
Pedro Alves

