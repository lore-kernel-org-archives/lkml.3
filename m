Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbaGRKWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:22:43 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:54807 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbaGRKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:22:40 -0400
Message-ID: <53C8F56C.5070706@imgtec.com>
Date: Fri, 18 Jul 2014 11:22:36 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MIPS seccomp and changing syscalls
References: <CAGXu5jJJ7dqC-or=ZhKKj8=eA5itKX4aLRsnxmFZvwnyRcrUrw@mail.gmail.com>
In-Reply-To: <CAGXu5jJJ7dqC-or=ZhKKj8=eA5itKX4aLRsnxmFZvwnyRcrUrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On 07/17/2014 11:29 PM, Kees Cook wrote:
> Hi,
> 
> I recently fixed a bug in seccomp on ARM that I think may be present
> in the MIPS implementation too. In arch/mips/kernel/ptrace.c
> syscall_trace_enter, the syscall variable is used (and returned), but
> the syscall may be changed by either secure_computing or
> tracehook_report_syscall_entry (via ptracers which can block and
> change the registers). (I would note that "ret" is also set but never
> used, so tracehook_report_syscall_entry failures actually won't get
> noticed.)
> 
> The discussion about this bug on ARM is here:
> https://lkml.org/lkml/2014/6/20/439

Thanks for letting us know.
Right, I believe MIPS will have the same problem and a similar patch to
Will Deacon's one will fix it properly. Would you like to submit one for
MIPS too? Otherwise I can do it myself.

> 
> I don't yet have a working MIPS environment to test this on, but it
> feels like the same bug. (Though, for testing, what's the right way to
> change syscall during PTRACE_SYSCALL? On x86 it's the orig_ax
> register, on ARM it's a arch-specific ptrace function
> (PTRACE_SET_SYSCALL).

For MIPS, the syscall numbers is in the v0 register ($2). But the o32
ABI also has the syscall() system call. So in case of indirect system
calls, the real system call is the first argument of syscall(), which is
register a0 ($4). See syscall_get_nr in arch/mips/include/asm/syscall.h

-- 
markos
