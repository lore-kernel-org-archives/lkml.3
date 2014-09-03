Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaICJoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:44:15 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43251 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaICJoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:44:14 -0400
Message-ID: <5406E2EC.4050201@linaro.org>
Date: Wed, 03 Sep 2014 10:44:12 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v11 06/19] irqchip: gic: Provide support for interrupt
 grouping
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-7-git-send-email-daniel.thompson@linaro.org> <20140902193355.GW30401@n2100.arm.linux.org.uk> <CBF5C246-DBB2-4FC3-A507-CA3E15013F7C@arm.com>
In-Reply-To: <CBF5C246-DBB2-4FC3-A507-CA3E15013F7C@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/14 22:36, Catalin Marinas wrote:
> On 2 Sep 2014, at 20:33, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> On Tue, Sep 02, 2014 at 02:00:40PM +0100, Daniel Thompson wrote:
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index 4b959e6..423707c 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -41,6 +41,9 @@
>>> #include <linux/irqchip/arm-gic.h>
>>>
>>> #include <asm/cputype.h>
>>> +#ifdef CONFIG_FIQ
>>> +#include <asm/fiq.h>
>>> +#endif
>>
>> Is there much advantage to this ifdef over providing a dummy asm/fiq.h
>> in ARM64?
> 
> While it’s unlikely we’ll use FIQs on arm64 (they are generally
> reserved for the secure world/firmware), I don’t mind an empty
> asm/fiq.h file.

Thanks Catalin, Thanks Russell.

I will do this.

