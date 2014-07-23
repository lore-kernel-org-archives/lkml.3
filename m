Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbaGWJJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:09:22 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45119 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:09:20 -0400
Message-ID: <53CF7BB7.8080509@linaro.org>
Date: Wed, 23 Jul 2014 18:09:11 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after ptrace
 operations
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jKkJUGn_MpEEr8U=n_A+iW9s8vSX1WoVNzRJMVyGQRjpA@mail.gmail.com> <53CF5E53.3060409@linaro.org> <20140723082505.GB27260@arm.com>
In-Reply-To: <20140723082505.GB27260@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 05:25 PM, Will Deacon wrote:
> On Wed, Jul 23, 2014 at 08:03:47AM +0100, AKASHI Takahiro wrote:
>> On 07/23/2014 05:15 AM, Kees Cook wrote:
>>> On Tue, Jul 22, 2014 at 2:14 AM, AKASHI Takahiro
>>> <takahiro.akashi@linaro.org> wrote:
>>>>    asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>>>    {
>>>> +       unsigned long saved_x0, saved_x8;
>>>> +
>>>> +       saved_x0 = regs->regs[0];
>>>> +       saved_x8 = regs->regs[8];
>>>> +
>>>>           if (test_thread_flag(TIF_SYSCALL_TRACE))
>>>>                   tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>>>>
>>>> +       regs->syscallno = regs->regs[8];
>>>> +       if ((long)regs->syscallno == ~0UL) { /* skip this syscall */
>>>> +               regs->regs[8] = saved_x8;
>>>> +               if (regs->regs[0] == saved_x0) /* not changed by user */
>>>> +                       regs->regs[0] = -ENOSYS;
>>>
>>> I'm not sure this is right compared to other architectures. Generally
>>> when a tracer performs a syscall skip, it's up to them to also adjust
>>> the return value. They may want to be faking a syscall, and what if
>>> the value they want to return happens to be what x0 was going into the
>>> tracer? It would have no way to avoid this -ENOSYS case. I think
>>> things are fine without this test.
>>
>> Yeah, I know this issue, but was not sure that setting a return value
>> is mandatory. (x86 seems to return -ENOSYS by default if not explicitly
>> specified.)
>> Is "fake a system call" a more appropriate word than "skip"?
>>
>> I will defer to Will.
>
> I agree with Kees -- iirc, I only suggested restoring x8.

OK.

-Takahiro AKASHI

> Will
>
