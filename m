Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3JSAmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:42:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3JSAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:42:03 -0400
Message-ID: <5261D552.6090401@infradead.org>
Date: Fri, 18 Oct 2013 17:41:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "pinctl-single.c" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: Tree for Oct 17 (pinctrl-single.c)
References: <20131018003847.GH2443@sirena.org.uk> <5261792C.7030203@infradead.org> <CACRpkdaz22N8-9Rg8vR=KGOEL5P6sZm6Hh5PT4Uq381+QmPs7g@mail.gmail.com> <20131018233951.GU15154@atomide.com> <5261C72D.1090302@infradead.org> <20131018234914.GV15154@atomide.com> <20131019003925.GW15154@atomide.com>
In-Reply-To: <20131019003925.GW15154@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 17:39, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [131018 16:49]:
>> * Randy Dunlap <rdunlap@infradead.org> [131018 16:41]:
>>> On 10/18/13 16:39, Tony Lindgren wrote:
>>>>
>>>> Looks like we need a little bit of arch specific handling
>>>> with the generic IRQ. Fix the issue with an ifdef the
>>>> same way as other drivers do.
>>>>
>>>> ARM needs things set to IRQF_VALID, which also then sets
>>>> noprobe. Others seem to use just irq_set_noprobe().
>>>>
>>>> Otherwise we can get:
>>>>
>>>> drivers/pinctrl/pinctrl-single.c: In function 'pcs_irqdomain_map':
>>>> drivers/pinctrl/pinctrl-single.c:1750:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
>>>
>>> Did you address this error?  I don't see a fix for it...
>>
>> Yes set_irq_flags() is defined for ARM archs in
>> arch/arm/include/asm/hw_irq.h which is included from
>> include/linux/irq.h as <asm/hw_irq.h>. So the ifdef
>> below takes care of that too.
>>
>>>> +#ifdef CONFIG_ARM
>>>> +	set_irq_flags(irq, IRQF_VALID);
>>>> +#else
>>>> +	irq_set_noprobe(irq);
>>>> +#endif
> 
> OK I've sent the pull request and Olof has now pulled the fix
> into arm-soc next/dt branch.

Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>



-- 
~Randy
