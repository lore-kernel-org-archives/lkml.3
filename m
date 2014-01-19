Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaASCtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 21:49:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaASCtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 21:49:05 -0500
From: Sergio Durigan Junior <sergiodj@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Organization: Red Hat Brazil
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com>
	<52CEEF1F.90803@redhat.com> <20140110135802.GA26953@redhat.com>
X-URL: http://www.redhat.com
Date: Sun, 19 Jan 2014 00:48:57 -0200
In-Reply-To: <20140110135802.GA26953@redhat.com> (Oleg Nesterov's message of
	"Fri, 10 Jan 2014 14:58:02 +0100")
Message-ID: <m3sisk4rfq.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 10 2014, Oleg Nesterov wrote:

> So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
> executes the "syscall" insn. What it should report?
[...]
> But what should syscall-exit do? Should it still report SIGSEGV as
> it currently does, or should it report _SYSCALL_EXIT instead (if
> PTRACE_O_SYSCALL_EXIT of course), or should it report both?

Both only if _SYSCALL_EXIT is set.  Otherwise, stick to the current
behavior, I guess.  Isn't it what my current patch does, by the way?  I
didn't test this scenario so I'm just guessing here...

-- 
Sergio
