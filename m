Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaIEKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:08:52 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42269 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbaIEKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:08:50 -0400
Message-ID: <54098BA1.3090508@linaro.org>
Date: Fri, 05 Sep 2014 19:08:33 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <53FD72E2.4020103@linaro.org> <20140901114751.GG30401@n2100.arm.linux.org.uk> <54058421.5070506@linaro.org> <20140902091622.GK30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140902091622.GK30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 06:16 PM, Russell King - ARM Linux wrote:
> On Tue, Sep 02, 2014 at 05:47:29PM +0900, AKASHI Takahiro wrote:
>> On 09/01/2014 08:47 PM, Russell King - ARM Linux wrote:
>>> On Wed, Aug 27, 2014 at 02:55:46PM +0900, AKASHI Takahiro wrote:
>>>> 1)
>>>> setting x0 to -ENOSYS is necessary because, otherwise, user-issued syscall(-1) will
>>>> return a bogus value when audit tracing is on.
>>>>
>>>> Please note that, on arm,
>>>>                    not traced      traced
>>>>                    ------          ------
>>>> syscall(-1)      aborted         OOPs(BUG_ON)
>>>> syscall(-3000)   aborted         aborted
>>>> syscall(1000)    ENOSYS          ENOSYS
>>>
>>> Two points here:
>>>
>>> 1. You've found a case which causes a BUG_ON().  Where is the bug report
>>>      for this, so the problem can be investigated and resolved?
>>
>> I think that I mentioned it could also happen on arm somewhere in a talk
>> with Will, but don't remember exactly when.
>
> Sorry, not good enough.  Please report this bug so it can be investigated
> and fixed.

Please review my patch as well as the commit message.

>>> 2. What do you mean by "aborted" ?
>>
>> I mean that the process will receive SIGILL and get aborted.
>> A system call number, like -1 and -3000, won't be trapped by *switch*
>> statement in asm_syscall() and end up with being signaled.
>
> That is correct behaviour - because numbers greater than 0xf0000 (or
> 0x9f0000 for OABI - the 0x900000 offset on the syscalls on OABI is to
> distinguish them from syscalls used by RISC OS) are not intended to
> be Linux syscalls per-se.

I tried to make such invalid/pseudo syscalls hehave in the same way
whether or not a task is traced (by seccomp, ptrace or audit).

>>> Please, if you find a problem with 32-bit ARM, report it.  Don't hide it,
>>> because hiding it can be a security issue or in the case of BUG_ON(), it
>>> could be a denial of service issue.
>>>
>>> As you're part of Linaro, I would have thought you'd be more responsible
>>> in this regard - after all, Linaro is supposed to be about improving the
>>> ARM kernel...  Maybe I got that wrong, and Linaro is actually about
>>> ensuring that the ARM kernel is stuffed full of broken features?
>>
>> I thought my first priority was on arm64 (and then arm), but now that
>> you and Will seem to want to see the fix first on arm, okey, I will
>> start with arm issue.
>
> So what you're saying there is that if you find a bug in ARM code, which
> everyone is currently using, you can ignore it until you've sorted out
> ARM64 which almost no one is using.
>
> This is absurd, and whoever has set your priorities is clearly on drugs.

Thank you. I learned a new English word, absurd.

-Takahiro AKASHI

>


