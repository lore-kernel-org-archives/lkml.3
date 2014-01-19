Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaASCkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 21:40:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaASCjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 21:39:51 -0500
From: Sergio Durigan Junior <sergiodj@redhat.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Organization: Red Hat Brazil
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com>
	<20140109210456.A3B0574425@topped-with-meat.com>
X-URL: http://www.redhat.com
Date: Sun, 19 Jan 2014 00:39:42 -0200
In-Reply-To: <20140109210456.A3B0574425@topped-with-meat.com> (Roland
	McGrath's message of "Thu, 9 Jan 2014 13:04:56 -0800 (PST)")
Message-ID: <m3wqhw4rv5.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09 2014, Roland McGrath wrote:

>> I won't argue, but it is not clear to me if this is really useful,
>> given that the debugger can read the regs.
>
> I do see the utility of having a consistent machine-independent way to get
> the syscall number from userspace.  But note that this could be probably
> accomplished with just a uapi header change, providing an inline or macro
> to extract the syscall number from the regset data.  (It was once the case
> that there were some machines where the syscall number is not in any
> register and has to be extracted by decoding the instruction.  I'm not sure
> if that is still an issue anywhere.)
>
> Also note that adding a separate copy of the syscall number introduces a
> new wrinkle into the interface.  This might be considered to be good, bad,
> or indifferent, but I think it should at least be considered explicitly.
> That is, at the entry stop the syscall number (when it's in a register) can
> be changed via ptrace.  So if the number is delivered via ptrace_message,
> that's a separate copy of the original number that does not reflect any
> changes made via ptrace--so it reflects what userland asked for, as opposed
> to what the kernel actually acted on.
>
> I don't have a particular opinion about which way to go with that.
> I just wanted all the issues (I'm aware of) to be considered.

Hm, thanks for your insights.

I don't really have a strong opinion here.  I could say that I think
ptrace should report the syscall that was originally called (and not the
one that will effectively be called), but maybe that would sound like I
am defending what I current have, heh...

Anyway, one question that I'm having now is what currently happens.
Guess I will take a look.

Having said that, if adding the syscall number information to
ptrace_message is too much controversial, I guess I will abandon this
idea for now and just implement the notifications.

-- 
Sergio
