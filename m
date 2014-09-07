Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaIGCtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 22:49:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33396 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaIGCtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 22:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <53558632.2D4ZDSZcaf@wuerfel>
References: <1409959302-13976-1-git-send-email-behanw@converseincode.com>
	<53558632.2D4ZDSZcaf@wuerfel>
Date: Sat, 6 Sep 2014 19:49:21 -0700
Message-ID: <CAFzeTN1fimq-OP9Nn4fpoF7fDcyYfyCYOAgG5mm33G8UOuXCoA@mail.gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Add missing abort() for AARCH64
From: Mark Charlebois <charlebm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Behan Webster <behanw@converseincode.com>, catalin.marinas@arm.com,
        jays.lee@samsung.com, will.deacon@arm.com, kgene.kim@samsung.com,
        steve.capper@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sungjinn.chung@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 7:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 05 September 2014 16:21:42 behanw@converseincode.com wrote:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> Add missing abort for arch aarch64.
>>
>> This patch makes the aarch64 kernel able to compile with gcc or clang.
>>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>
> You don't describe why this is needed. When does clang emit an abort()
> call? Is that the expected behavior when not linking against a full
> C library?

I just tried recompiling for vexpress64 without the abort call and it
seems the patch is no longer needed. When I added this I mimicked the
behavior of abort for arm which at the time was defined in the kernel
code.

Sorry for the churn.

-Mark

>
>>  arch/arm64/kernel/traps.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> index 02cd3f0..123cd6e 100644
>> --- a/arch/arm64/kernel/traps.c
>> +++ b/arch/arm64/kernel/traps.c
>> @@ -349,6 +349,15 @@ void __pgd_error(const char *file, int line, unsigned long val)
>>         pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
>>  }
>>
>> +void abort(void)
>> +{
>> +       BUG();
>> +
>> +       /* if that doesn't kill us, halt */
>> +       panic("Oops failed to kill thread");
>> +}
>> +EXPORT_SYMBOL(abort);
>
> I don't see the point in doing both BUG() and panic(). Doesn't panic()
> already print all the information you want in this case?
>
>         Arnd
