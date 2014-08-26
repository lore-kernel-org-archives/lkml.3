Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaHZRq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:46:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbaHZRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:46:57 -0400
Date: Tue, 26 Aug 2014 18:46:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
Message-ID: <20140826174637.GC23445@arm.com>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
 <1408611405-8943-2-git-send-email-takahiro.akashi@linaro.org>
 <CAGXu5jJrTEhdDZ8fipNeaVm1_wto7u2f=uq_KzyMcVHJMT57vw@mail.gmail.com>
 <53F68C81.6020807@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F68C81.6020807@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 01:19:13AM +0100, AKASHI Takahiro wrote:
> On 08/22/2014 01:47 AM, Kees Cook wrote:
> > On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> > <takahiro.akashi@linaro.org> wrote:
> >> To allow tracer to be able to change/skip a system call by re-writing
> >> a syscall number, there are several approaches:
> >>
> >> (1) modify x8 register with ptrace(PTRACE_SETREGSET), and handle this case
> >>      later on in syscall_trace_enter(), or
> >> (2) support ptrace(PTRACE_SET_SYSCALL) as on arm
> >>
> >> Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
> >> tracer as well as that secure_computing() expects a changed syscall number
> >> to be visible, especially case of -1, before this function returns in
> >> syscall_trace_enter(), we'd better take (2).
> >>
> >> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> >
> > Thanks, I like having this on both arm and arm64.
> 
> Yeah, having this simplified the code of syscall_trace_enter() a bit, but
> also imposes some restriction on arm64, too.
> 
>  > I wonder if other archs should add this option too.
> 
> Do you think so? I assumed that SET_SYSCALL is to be avoided if possible.
> 
> I also think that SET_SYSCALL should take an extra argument for a return value
> just in case of -1 (or we have SKIP_SYSCALL?).

I think we should propose this as a new request in the generic ptrace code.
We can have an architecture-hook for actually setting the syscall, and allow
architectures to define their own implementation of the request so they can
be moved over one by one.

Will
