Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaBKTnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:43:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33771 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbaBKTnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:43:00 -0500
Message-ID: <52FA7D1A.8090408@ti.com>
Date: Tue, 11 Feb 2014 21:42:18 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Paul Bolle <pebolle@tiscali.nl>
CC: Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 15/28] Remove TI_AEMIF
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-16-git-send-email-richard@nod.at> <1391979242.25855.37.camel@x220> <20140211190404.GI18440@ld-irv-0074>
In-Reply-To: <20140211190404.GI18440@ld-irv-0074>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 09:04 PM, Brian Norris wrote:
> + Ivan, others
>
> On Sun, Feb 09, 2014 at 09:54:02PM +0100, Paul Bolle wrote:
>> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
>>> The symbol is an orphan, get rid of it.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>   drivers/mtd/nand/Kconfig | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
>>> index 90ff447..a195d57 100644
>>> --- a/drivers/mtd/nand/Kconfig
>>> +++ b/drivers/mtd/nand/Kconfig
>>> @@ -465,7 +465,7 @@ config MTD_NAND_SH_FLCTL
>>>   
>>>   config MTD_NAND_DAVINCI
>>>           tristate "Support NAND on DaVinci/Keystone SoC"
>>> -        depends on ARCH_DAVINCI || (ARCH_KEYSTONE && TI_AEMIF)
>>> +        depends on ARCH_DAVINCI || ARCH_KEYSTONE
>>>           help
>>>   	  Enable the driver for NAND flash chips on Texas Instruments
>>>   	  DaVinci/Keystone processors.
>> What's strange about the current dependency is that the only aemif code
>> I could find lives at arch/arm/mach-davinci/aemif.c. Is that reachable
>> for code in arch/arm/mach-keystone?
> It looks like I merged this code before the supporting aemif driver [1] was
> merged. I think this is harmless, and so I plan to leave it as-is for
> now. Or if Ivan prefers, I can drop the Keystone dependency entirely
> until it is ready.
>
> https://lkml.org/lkml/2013/11/20/283
>
> Brian

It is harmless.

For Keystone NAND depends on AEMIF.
AEMIF is responsible to set timings.

In case of Davinci the timings are set by arch/arm/mach-davinci/aemif.c.
In case of Keystone the timings are going to be set by AEMIF driver.

AEMIF is going to be merged I hope. That's plan.

So you can leave it.

-- 
Regards,
Ivan Khoronzhuk

