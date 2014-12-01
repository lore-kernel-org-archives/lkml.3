Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaLATVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:21:12 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:53963 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaLATVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:21:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141128184344.GA3968@arm.com>
References: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
	<20141128184344.GA3968@arm.com>
Date: Mon, 1 Dec 2014 11:21:10 -0800
X-Google-Sender-Auth: RzHPETRl1obeVUT67CuIkZophqQ
Message-ID: <CAGXu5jJb+OSQBSnLnEU2zuehUjBnuLWKBeSXC+=zv=bCRUi8Eg@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] arm64: add seccomp support
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 10:43 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Nov 28, 2014 at 05:26:33AM +0000, AKASHI Takahiro wrote:
>> This patch series enables secure computing (system call filtering) on arm64,
>> and contains related enhancements and bug fixes.
>>
>>   NOTE: This versions contain a workaround against possible BUG_ON() failure
>>   at audit_syscall_exit(), but doesn't contain an extra optimization, as I
>>   submitted for arm, of excluding syscall enter/exit tracing against invalid
>>   system calls due to an issue that I reported in:
>>        http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292170.html
>>
>> The code was tested on ARMv8 fast model with 64-bit/32-bit userspace using:
>>  * libseccomp v2.1.1 with modifications for arm64, especially its "live"
>>    tests: No.20, 21 and 24.
>>  * modified version of Kees' seccomp test for 'changing/skipping a syscall'
>>    and seccomp() system call
>>  * in-house tests for 'changing/skipping a system call' by tracing with
>>    ptrace(SETREGSET, NT_SYSTEM_CALL) (that is, not via seccomp filter)'
>> with and without audit tracing.
>>
>>
>> Changes v9 -> v10:
>> * modified system_call_get() for big-endian build [1/6]
>> * modified the way to check for syscall(-1) on syscall entry [2/6]
>
> Applied, thanks.

Yay! Thanks for all the revisions on this. I'll start preparing some
patches to use the generic seccomp.h file now...

-Kees

-- 
Kees Cook
Chrome OS Security
