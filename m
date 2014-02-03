Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbaBCF7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 00:59:53 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43683 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBCF7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 00:59:51 -0500
Message-ID: <52EF304F.80202@linaro.org>
Date: Mon, 03 Feb 2014 14:59:43 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Will.Deacon@arm.com, arndb@arndb.de,
        linux-kernel@vger.kernel.org,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        viro@zeniv.linux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] audit: Enable arm64 support
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org> <1389946399-4525-2-git-send-email-takahiro.akashi@linaro.org> <20140123141808.GD27520@arm.com> <52E5EAC1.2070306@linaro.org> <20140129202127.GA24068@madcap2.tricolour.ca> <20140129223652.GA13702@madcap2.tricolour.ca>
In-Reply-To: <20140129223652.GA13702@madcap2.tricolour.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

On 01/30/2014 07:36 AM, Richard Guy Briggs wrote:
> On 14/01/29, Richard Guy Briggs wrote:
>> On 14/01/27, AKASHI Takahiro wrote:
>>> [To audit maintainers]
>>>
>>> On 01/23/2014 11:18 PM, Catalin Marinas wrote:
>>>> On Fri, Jan 17, 2014 at 08:13:14AM +0000, AKASHI Takahiro wrote:
>>>>> --- a/include/uapi/linux/audit.h
>>>>> +++ b/include/uapi/linux/audit.h
>>>>> @@ -327,6 +327,8 @@ enum {
>>>>>   /* distinguish syscall tables */
>>>>>   #define __AUDIT_ARCH_64BIT 0x80000000
>>>>>   #define __AUDIT_ARCH_LE	   0x40000000
>>>>> +#define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>>>>> +#define AUDIT_ARCH_AARCH64EB	(EM_AARCH64|__AUDIT_ARCH_64BIT)
>>>>>   #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>>>>>   #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
>>>>>   #define AUDIT_ARCH_ARMEB	(EM_ARM)
>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>> index 79383d3..3aae602 100644
>>>>> --- a/init/Kconfig
>>>>> +++ b/init/Kconfig
>>>>> @@ -284,7 +284,7 @@ config AUDIT
>>>>>
>>>>>   config AUDITSYSCALL
>>>>>   	bool "Enable system-call auditing support"
>>>>> -	depends on AUDIT && (X86 || PARISC || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
>>>>> +	depends on AUDIT && (X86 || PARISC || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT) || ARM64)
>>>>
>>>> The usual comment for such changes: could you please clean this up and
>>>> just use something like "depends on HAVE_ARCH_AUDITSYSCALL"?
>>>
>>> Do you agree to this change?
>>>
>>> If so, I can create a patch, but have some concerns:
>>> 1) I can't verify it on other architectures than (arm &) arm64.
>>> 2) Some architectures (microblaze, mips, openrisc) are not listed here, but
>>>     their ptrace.c have a call to audit_syscall_entry/exit().
>>>     (audit_syscall_entry/exit are null if !AUDITSYSCALL, though)
>>
>> I can try: ppc s390 x86_64 ppc64 i686 s390x
>
> These arches above all pass compile and basic tests with the following patches applied:
>
> 	audit: correct a type mismatch in audit_syscall_exit() pending (already upstream)
>
> 	audit: Modify a set of system calls in audit class definitions (already upstream)
>
> 	[PATCH v3] audit: Add generic compat syscall support
>
> 	[PATCH v2] audit: Enable arm64 support
> 	[PATCH v2] arm64: Add regs_return_value() in syscall.h
> 	[PATCH v2] arm64: Add audit support
> 	[PATCH v2] arm64: audit: Add 32-bit (compat) syscall support
> 	[PATCH v2] arm64: audit: Add makefile rule to create unistd_32.h for compat syscalls
> 	[PATCH v2] arm64: audit: Add audit hook in ptrace/syscall_trace

I think that you missed Catalin's suggestion.
Please use the patch I will post after this message and try it again, please?

Thanks,
-Takahiro AKASHI



>>> So I'm afraid that the change might break someone's assumption.
>>>
>>> Thanks,
>>> -Takahiro AKASHI
>>
>> - RGB
>
> - RGB
>
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
>
