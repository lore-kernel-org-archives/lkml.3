Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaH0Fcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:32:53 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60711 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaH0Fcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:32:51 -0400
Message-ID: <53FD6D7C.8030700@linaro.org>
Date: Wed, 27 Aug 2014 14:32:44 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-2-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJrTEhdDZ8fipNeaVm1_wto7u2f=uq_KzyMcVHJMT57vw@mail.gmail.com> <53F68C81.6020807@linaro.org> <20140826174637.GC23445@arm.com>
In-Reply-To: <20140826174637.GC23445@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

On 08/27/2014 02:46 AM, Will Deacon wrote:
> On Fri, Aug 22, 2014 at 01:19:13AM +0100, AKASHI Takahiro wrote:
>> On 08/22/2014 01:47 AM, Kees Cook wrote:
>>> On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
>>> <takahiro.akashi@linaro.org> wrote:
>>>> To allow tracer to be able to change/skip a system call by re-writing
>>>> a syscall number, there are several approaches:
>>>>
>>>> (1) modify x8 register with ptrace(PTRACE_SETREGSET), and handle this case
>>>>       later on in syscall_trace_enter(), or
>>>> (2) support ptrace(PTRACE_SET_SYSCALL) as on arm
>>>>
>>>> Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
>>>> tracer as well as that secure_computing() expects a changed syscall number
>>>> to be visible, especially case of -1, before this function returns in
>>>> syscall_trace_enter(), we'd better take (2).
>>>>
>>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>
>>> Thanks, I like having this on both arm and arm64.
>>
>> Yeah, having this simplified the code of syscall_trace_enter() a bit, but
>> also imposes some restriction on arm64, too.
>>
>>   > I wonder if other archs should add this option too.
>>
>> Do you think so? I assumed that SET_SYSCALL is to be avoided if possible.
>>
>> I also think that SET_SYSCALL should take an extra argument for a return value
>> just in case of -1 (or we have SKIP_SYSCALL?).
>
> I think we should propose this as a new request in the generic ptrace code.
> We can have an architecture-hook for actually setting the syscall, and allow
> architectures to define their own implementation of the request so they can
> be moved over one by one.

What do you think about this request?

-Takahiro AKASHI

> Will
>
