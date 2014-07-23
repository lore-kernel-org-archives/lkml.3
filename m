Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbaGWPgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:36:08 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49478 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbaGWPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <53CF5F9E.4020404@linaro.org>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
	<CAGXu5j+1huPbBKH25HK6PmAL3Mi-zgD5UDRp-6wx8vuPVOBDEg@mail.gmail.com>
	<53CF5F9E.4020404@linaro.org>
Date: Wed, 23 Jul 2014 08:36:05 -0700
X-Google-Sender-Auth: 2L8S1udKfTyfcTWDJ5T_PuoJv9A
Message-ID: <CAGXu5j+2MXht31xQcsXL2DaRGrgxn2YxJY8vgbDHHKZAcidfbA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] arm64: Add seccomp support
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Drewry <wad@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:09 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> On 07/23/2014 05:16 AM, Kees Cook wrote:
>>
>> On Tue, Jul 22, 2014 at 2:14 AM, AKASHI Takahiro
>> <takahiro.akashi@linaro.org> wrote:
>>>
>>> (Please apply this patch after my audit patch in order to avoid some
>>> conflict on arm64/Kconfig.)
>>>
>>> This patch enables secure computing (system call filtering) on arm64.
>>> System calls can be allowed or denied by loaded bpf-style rules.
>>> Architecture specific part is to run secure_computing() on syscall entry
>>> and check the result. See [3/3]
>>
>>
>> Thanks for working on this!
>>
>>> Prerequisites are:
>>>   * "arm64: Add audit support" patch
>>>
>>> This code is tested on ARMv8 fast model using
>>>   * libseccomp v2.1.1 with modifications for arm64 and verified by its
>>> "live"
>>>     tests, 20, 21 and 24.
>>>   * modified version of Kees' seccomp test for 'changing/skipping a
>>> syscall'
>>>     behavior
>>
>>
>> Would you be able to share this? I'd love to add it to the seccomp
>> regression suite for the arm64-specific parts.
>
>
> Yep, I forked your repo here:
> https://github.com/t-akashi/seccomp.git
> (See trace_arm64 branch)

Great, thanks! I'll incorporate your changes into my trace branch. (It
looks like using PTRACE_GETREGSET works on all archs, so I'll switch
to using that for all.)

-Kees

>
> Thanks,
> -Takahiro AKASHI
>
>
>> Thanks!
>>
>> -Kees
>>
>>>
>>> Changes v4 -> v5:
>>> * rebased to v3.16-rc
>>> * add patch [1/3] to allow ptrace to change a system call
>>>    (please note that this patch should be applied even without seccomp.)
>>>
>>> Changes v3 -> v4:
>>> * removed the following patch and moved it to "arm64: prerequisites for
>>>    audit and ftrace" patchset since it is required for audit and ftrace
>>> in
>>>    case of !COMPAT, too.
>>>    "arm64: is_compat_task is defined both in asm/compat.h and
>>> linux/compat.h"
>>>
>>> Changes v2 -> v3:
>>> * removed unnecessary 'type cast' operations [2/3]
>>> * check for a return value (-1) of secure_computing() explicitly [2/3]
>>> * aligned with the patch, "arm64: split syscall_trace() into separate
>>>    functions for enter/exit" [2/3]
>>> * changed default of CONFIG_SECCOMP to n [2/3]
>>>
>>> Changes v1 -> v2:
>>> * added generic seccomp.h for arm64 to utilize it [1,2/3]
>>> * changed syscall_trace() to return more meaningful value (-EPERM)
>>>    on seccomp failure case [2/3]
>>> * aligned with the change in "arm64: make a single hook to
>>> syscall_trace()
>>>    for all syscall features" v2 [2/3]
>>> * removed is_compat_task() definition from compat.h [3/3]
>>>
>>> AKASHI Takahiro (3):
>>>    arm64: ptrace: reload a syscall number after ptrace operations
>>>    asm-generic: Add generic seccomp.h for secure computing mode 1
>>>    arm64: Add seccomp support
>>>
>>>   arch/arm64/Kconfig               |   14 ++++++++++++++
>>>   arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
>>>   arch/arm64/include/asm/unistd.h  |    3 +++
>>>   arch/arm64/kernel/entry.S        |    2 ++
>>>   arch/arm64/kernel/ptrace.c       |   18 ++++++++++++++++++
>>>   include/asm-generic/seccomp.h    |   28 ++++++++++++++++++++++++++++
>>>   6 files changed, 90 insertions(+)
>>>   create mode 100644 arch/arm64/include/asm/seccomp.h
>>>   create mode 100644 include/asm-generic/seccomp.h
>>>
>>> --
>>> 1.7.9.5
>>>
>>
>>
>>
>



-- 
Kees Cook
Chrome OS Security
