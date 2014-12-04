Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaLDXs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:48:57 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39801 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaLDXsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:48:55 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:18e4:f2cc:a02b:2d5c]
In-Reply-To: <5480F12D.90007@suse.de>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
	<CAOesGMhv+0_SZb2eSiwCGaD77hd=a6EhMp6tVvcrZoBnrHKQjA@mail.gmail.com>
	<5480F12D.90007@suse.de>
Date: Thu, 4 Dec 2014 15:48:50 -0800
Message-ID: <CAOesGMi-sVTxdo8f7vNnYMgd+meBF+Gsf3Pk5VbHEPxv5Q6iDA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
From: Olof Johansson <olof@lixom.net>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 3:41 PM, Alexander Graf <agraf@suse.de> wrote:
>
>
> On 04.12.14 22:15, Olof Johansson wrote:
>> On Thu, Dec 4, 2014 at 7:46 AM, Alexander Graf <agraf@suse.de> wrote:
>>> With binutils 2.25 the default alignment for 32bit arm sections changed to
>>> have everything 64k aligned. Armv7 binaries built with this binutils version
>>> run successfully on an arm64 system.
>>>
>>> Since effectively there is now the chance to run armv7 code on arm64 even
>>> with 64k page size, it doesn't make sense to block people from enabling
>>> CONFIG_COMPAT on those configurations.
>>>
>>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>> ---
>>>  arch/arm64/Kconfig | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index 9532f8d..3cf4f238 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
>>>
>>>  config COMPAT
>>>         bool "Kernel support for 32-bit EL0"
>>> -       depends on !ARM64_64K_PAGES
>>>         select COMPAT_BINFMT_ELF
>>>         select HAVE_UID16
>>>         select OLD_SIGSUSPEND3
>>
>> This is hardly "compat". Sure, it's great to have a new binutils that
>> has larger alignment, but practically not a single existing binary
>> will work today if someone tries to do this.
>
> Yes, but IMHO that's an implementation detail. The same applies for
> 32bit PPC binaries if you use 4k aligned segments. If your applications
> are not aligned for your page size, you can't run them. The only
> platform that managed nevertheless FWIW was IA64 ;).

Yes, but there the binutils change happened early enough that by the
time the kernel change went in, all major distros had binaries that
were compatible.

>> So, it seems very premature to take this off. At the very least
>> document it like Will requested, and make it depend on !ARM_64K_PAGES
>> || EXPERT.
>
> Sure, that certainly works for me (though you probably mean Laura).

Yeah, sorry Laura. :)

> Completely restricting users from enabling it just because our current
> toolchain doesn't generate compatible binaries sounds a bit extreme to me.

Perhaps.

It's in many ways a timing thing too, if ARM had patched binutils a
couple of years ago it might have been fine to just go with it without
EXPERT now. :)


-Olof
