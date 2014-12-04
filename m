Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaLDXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:41:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbaLDXlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:41:35 -0500
Message-ID: <5480F12D.90007@suse.de>
Date: Fri, 05 Dec 2014 00:41:33 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <CAOesGMhv+0_SZb2eSiwCGaD77hd=a6EhMp6tVvcrZoBnrHKQjA@mail.gmail.com>
In-Reply-To: <CAOesGMhv+0_SZb2eSiwCGaD77hd=a6EhMp6tVvcrZoBnrHKQjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04.12.14 22:15, Olof Johansson wrote:
> On Thu, Dec 4, 2014 at 7:46 AM, Alexander Graf <agraf@suse.de> wrote:
>> With binutils 2.25 the default alignment for 32bit arm sections changed to
>> have everything 64k aligned. Armv7 binaries built with this binutils version
>> run successfully on an arm64 system.
>>
>> Since effectively there is now the chance to run armv7 code on arm64 even
>> with 64k page size, it doesn't make sense to block people from enabling
>> CONFIG_COMPAT on those configurations.
>>
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>> ---
>>  arch/arm64/Kconfig | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 9532f8d..3cf4f238 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
>>
>>  config COMPAT
>>         bool "Kernel support for 32-bit EL0"
>> -       depends on !ARM64_64K_PAGES
>>         select COMPAT_BINFMT_ELF
>>         select HAVE_UID16
>>         select OLD_SIGSUSPEND3
> 
> This is hardly "compat". Sure, it's great to have a new binutils that
> has larger alignment, but practically not a single existing binary
> will work today if someone tries to do this.

Yes, but IMHO that's an implementation detail. The same applies for
32bit PPC binaries if you use 4k aligned segments. If your applications
are not aligned for your page size, you can't run them. The only
platform that managed nevertheless FWIW was IA64 ;).

> So, it seems very premature to take this off. At the very least
> document it like Will requested, and make it depend on !ARM_64K_PAGES
> || EXPERT.

Sure, that certainly works for me (though you probably mean Laura).
Completely restricting users from enabling it just because our current
toolchain doesn't generate compatible binaries sounds a bit extreme to me.


Alex
