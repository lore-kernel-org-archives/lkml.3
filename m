Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaLHCAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 21:00:02 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:19488 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 21:00:00 -0500
X-IronPort-AV: E=Sophos;i="5.07,535,1413270000"; 
   d="scan'208";a="52326546"
Message-ID: <5485061D.1060302@broadcom.com>
Date: Sun, 7 Dec 2014 17:59:57 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] gpio: Cygnus: add GPIO driver
References: <Ray Jui <rjui@broadcom.com>	 <1417826408-1600-1-git-send-email-rjui@broadcom.com>	 <1417826408-1600-3-git-send-email-rjui@broadcom.com> <1417829282.31745.3.camel@perches.com> <5482668F.1040907@broadcom.com>
In-Reply-To: <5482668F.1040907@broadcom.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/5/2014 6:14 PM, Ray Jui wrote:
>>> +static struct irq_chip bcm_cygnus_gpio_irq_chip = {
>>> +    .name = "bcm-cygnus-gpio",
>>> +    .irq_ack = bcm_cygnus_gpio_irq_ack,
>>> +    .irq_mask = bcm_cygnus_gpio_irq_mask,
>>> +    .irq_unmask = bcm_cygnus_gpio_irq_unmask,
>>> +    .irq_set_type = bcm_cygnus_gpio_irq_set_type,
>>> +};
>>
>> const?
>>
>
>
> Sure, will add const to bcm_cygnus_gpio_irq_chip
>
>>> +static struct irq_domain_ops bcm_cygnus_irq_ops = {
>>> +    .map = bcm_cygnus_gpio_irq_map,
>>> +    .unmap = bcm_cygnus_gpio_irq_unmap,
>>> +    .xlate = irq_domain_xlate_twocell,
>>> +};
>>
>> const here too?
>>
>
> Yes, will make bcm_cygnus_irq_ops const.
>
Actually, I cannot make them const here. Note they are passed into other 
APIs which can potentially modifies their values internally.

drivers/gpio/gpio-bcm-cygnus.c: In function ‘bcm_cygnus_gpio_irq_map’:
drivers/gpio/gpio-bcm-cygnus.c:430:4: warning: passing argument 2 of 
‘irq_set_chip_and_handler’ discards ‘const’ qualifier from pointer 
target type [enabled by default]
     handle_simple_irq);
     ^
In file included from drivers/gpio/gpio-bcm-cygnus.c:17:0:
include/linux/irq.h:461:20: note: expected ‘struct irq_chip *’ but 
argument is of type ‘const struct irq_chip *’
  static inline void irq_set_chip_and_handler(unsigned int irq, struct 
irq_chip *chip,
                     ^
drivers/gpio/gpio-bcm-cygnus.c: In function ‘bcm_cygnus_gpio_probe’:
drivers/gpio/gpio-bcm-cygnus.c:679:5: warning: passing argument 2 of 
‘irq_set_chip_and_handler’ discards ‘const’ qualifier from pointer 
target type [enabled by default]
      handle_simple_irq);
      ^
In file included from drivers/gpio/gpio-bcm-cygnus.c:17:0:
include/linux/irq.h:461:20: note: expected ‘struct irq_chip *’ but 
argument is of type ‘const struct irq_chip *’
  static inline void irq_set_chip_and_handler(unsigned int irq, struct 
irq_chip *chip,
