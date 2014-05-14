Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaENSt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaENSt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:49:56 -0400
Message-ID: <5373BACB.9090807@redhat.com>
Date: Wed, 14 May 2014 19:49:47 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Sergio Durigan Junior <sergiodj@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <52CEEF1F.90803@redhat.com> <20140110135802.GA26953@redhat.com> <m3sisk4rfq.fsf@redhat.com> <20140119152922.GA13689@redhat.com>
In-Reply-To: <20140119152922.GA13689@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realized now that I responded to this.  Sorry about that.

On 01/19/2014 03:29 PM, Oleg Nesterov wrote:
> On 01/19, Sergio Durigan Junior wrote:
>>
>> On Friday, January 10 2014, Oleg Nesterov wrote:
>>
>>> So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
>>> executes the "syscall" insn. What it should report?
>> [...]
>>> But what should syscall-exit do? Should it still report SIGSEGV as
>>> it currently does, or should it report _SYSCALL_EXIT instead (if
>>> PTRACE_O_SYSCALL_EXIT of course), or should it report both?
>>
>> Both only if _SYSCALL_EXIT is set.  Otherwise, stick to the current
>> behavior, I guess.
> 
> OK, both. In which order? Probably _EXIT first. But this looks a bit
> strange. Suppose that the tracee reports _EXIT, then debugger does
> ptrace(PTRACE_CONT), should the tracee report SIGTRAP?

Seems to me that this should be very much the same as fork/vfork/clone
event handling.  Those are triggered by a syscall anyway.  So, say:

- ptrace(PTRACE_SINGLESTEP)
- the tracee executes the "syscall" insn, and the syscall is "clone".
- PTRACE_EVENT_FORK is reported.
- The debugger does ptrace(PTRACE_CONT).

What should be reported?  What is reported now?

-- 
Pedro Alves

