Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbaATFXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:23:35 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54640 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaATFXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:23:32 -0500
Message-ID: <52DCB2C9.2040702@linaro.org>
Date: Mon, 20 Jan 2014 14:23:21 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 4/6] arm64: audit: Add 32-bit (compat) syscall support
References: <1383733546-2846-1-git-send-email-takahiro.akashi@linaro.org> <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org> <1389946399-4525-5-git-send-email-takahiro.akashi@linaro.org> <20140117164610.GQ16003@mudshark.cambridge.arm.com>
In-Reply-To: <20140117164610.GQ16003@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 01:46 AM, Will Deacon wrote:
> Hi Akashi,
>
> On Fri, Jan 17, 2014 at 08:13:17AM +0000, AKASHI Takahiro wrote:
>> Generic audit code also support compat system calls now.
>> This patch adds a small piece of architecture dependent code.
>
> [...]
>
>>   static inline int syscall_get_nr(struct task_struct *task,
>> @@ -109,6 +110,15 @@ static inline void syscall_set_arguments(struct task_struct *task,
>>   static inline int syscall_get_arch(struct task_struct *task,
>>   				   struct pt_regs *regs)
>>   {
>> +#ifdef CONFIG_COMPAT
>> +	if (is_compat_thread(task_thread_info(task)))
>
> You can call is_compat_thread even when !CONFIG_COMPAT, so you don't need
> that #ifdef.

Right. I will remove it.

>> +#ifdef __AARCH64EB__
>> +		return AUDIT_ARCH_ARMEB; /* only BE on BE */
>
> Well, actually, we only support userspace to be the same endianness as the
> kernel, so you that comment is slightly misleading. You could probably avoid
> these repeated ifdefs by defining things like ARM64_AUDIT_ARCH and
> ARM64_COMPAT_AUDIT_ARCH once depending on endianness.

As in the discussions about "audit(userspace)", if we don't have to care
about endianness, I will remove this #ifdef instead.

Thanks,
-Takahiro AKASHI

> Will
>
