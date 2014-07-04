Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaGDLFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:05:55 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58709 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbaGDLFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:05:53 -0400
Message-ID: <53B68A8B.1020106@linaro.org>
Date: Fri, 04 Jul 2014 20:05:47 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org
CC: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org> <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org> <5418828.mxvNk2rT0e@wuerfel>
In-Reply-To: <5418828.mxvNk2rT0e@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 07/04/2014 07:06 PM, Arnd Bergmann wrote:
> On Friday 04 July 2014 16:28:29 AKASHI Takahiro wrote:
>> From: Catalin Marinas <catalin.marinas@arm.com>
>>
>> This patch adds __NR_* definitions to asm/unistd32.h, moves the
>> __NR_compat_* definitions to asm/unistd.h and removes all the explicit
>> unistd32.h includes apart from the one building the compat syscall
>> table. The aim is to have the compat __NR_* definitions available but
>> without colliding with the native syscall definitions.
>>
>> And adds more syscall definitions for 3.16.
>
> Can you explain in more detail why you want to add those macros? I've
> looked at all three patches in the series but can't find any code using
> them.

Right. "unistd32.h" is not used by this patch, but by lib/compat_audit.c.
when I thought of adding audit support for arm64, there was duplicated code
of auditing compat system calls across many architectures.
lib/compat_audit.c fixes this issue but at the same time it also requires
__NR_* macros for a couple of compat system calls which arm64 didn't have.

In the first implementation, I generated an extra generated/asm/unistd_32.h
from the original asm/unist32.h by using a sed script. But Catalin suggested
(agreed?) to modify unistd32.h for this purpose.

See
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/228992.html

Thanks,
-Takahiro AKASHI

> I would expect that we don't need to define those macros at all for
> compat mode, since they are meant primarily for user space (glibc)
> compilation, which gets them from arch/arm/include/asm/unistd.h.
>
> 	Arnd
>
