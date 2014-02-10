Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBJV7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:59:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaBJV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:59:34 -0500
Message-ID: <52F94BC3.1060307@codeaurora.org>
Date: Mon, 10 Feb 2014 13:59:31 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCHv2 2/2] arm: Get rid of meminfo
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org> <1391558551-31395-3-git-send-email-lauraa@codeaurora.org> <20140207020949.GQ1706@sonymobile.com> <52F846AE.3050800@codeaurora.org> <20140210172808.GS1706@sonymobile.com>
In-Reply-To: <20140210172808.GS1706@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/2014 9:28 AM, Courtney Cavin wrote:
> On Mon, Feb 10, 2014 at 04:25:34AM +0100, Laura Abbott wrote:
>> On 2/6/2014 6:09 PM, Courtney Cavin wrote:
>>> On Wed, Feb 05, 2014 at 01:02:31AM +0100, Laura Abbott wrote:
>>>> memblock is now fully integrated into the kernel and is the prefered
>>>> method for tracking memory. Rather than reinvent the wheel with
>>>> meminfo, migrate to using memblock directly instead of meminfo as
>>>> an intermediate.
>>>>
>>>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>>> [...]
>>>> diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
>>>> index 0b11c1a..51d814e 100644
>>>> --- a/arch/arm/mach-pxa/spitz.c
>>>> +++ b/arch/arm/mach-pxa/spitz.c
>>>> @@ -32,6 +32,7 @@
>>>>    #include <linux/io.h>
>>>>    #include <linux/module.h>
>>>>    #include <linux/reboot.h>
>>>> +#include <linux/memblock.h>
>>>>
>>>>    #include <asm/setup.h>
>>>>    #include <asm/mach-types.h>
>>>> @@ -971,13 +972,9 @@ static void __init spitz_init(void)
>>>>           spitz_i2c_init();
>>>>    }
>>>>
>>>> -static void __init spitz_fixup(struct tag *tags, char **cmdline,
>>>> -                              struct meminfo *mi)
>>>> +static void __init spitz_fixup(struct tag *tags, char **cmdline)
>>>>    {
>>>> -       sharpsl_save_param();
>>>> -       mi->nr_banks = 1;
>>>> -       mi->bank[0].start = 0xa0000000;
>>>> -       mi->bank[0].size = (64*1024*1024);
>>>> +       memblock_addr(0xa0000000, SZ_64M);
>>>
>>> memblock_add() ?
>> Yes, that was a typo on my part. I'll send out a v3 with collected acks.
>>
>
> So, I also just noticed that you specifically remove the call to
> sharpsl_save_param() here.  I'm presuming that this is also an error, as
> you haven't removed it from any of the other pxa fixups, and it seems
> unrelated to the change.
>
> -Courtney

Clearly not my finest hour at all. Thanks for reviewing.

Laura


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
