Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3HGLNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:13:06 -0400
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:60872 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757307Ab3HGLNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:13:04 -0400
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 07:13:04 EDT
Message-ID: <52022797.3060006@overkiz.com>
Date: Wed, 07 Aug 2013 12:55:19 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/dt: split sam9x5 peripheral definitions
References: <1375870466-1093-1-git-send-email-b.brezillon@overkiz.com> <CACQ1gAjsPvHkpUuO_3jK3HfnDBQDoJmO7z1Gj5YkAmybHB_zmg@mail.gmail.com>
In-Reply-To: <CACQ1gAjsPvHkpUuO_3jK3HfnDBQDoJmO7z1Gj5YkAmybHB_zmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2868230013141743781
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On 07/08/2013 12:38, Richard Genoud wrote:
> 2013/8/7 Boris BREZILLON <b.brezillon@overkiz.com>:
>> This patch splits the sam9x5 peripheral definitions into:
>> - a common base for all sam9x5 SoCs (at91sam9x5.dtsi)
>> - several optional peripheral definitions which will be included by specific
>>    sam9x5 SoCs (at91sam9x5_'periph name'.dtsi)
>>
>> This provides a better representation of the real hardware (drop unneeded
>> dt nodes) and avoids future peripheral id conflict (lcdc and isi both use
>> peripheral id 25).
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/boot/dts/at91sam9g25.dtsi       |    2 +
>>   arch/arm/boot/dts/at91sam9g35.dtsi       |    1 +
>>   arch/arm/boot/dts/at91sam9x25.dtsi       |   24 ++---------
>>   arch/arm/boot/dts/at91sam9x35.dtsi       |    1 +
>>   arch/arm/boot/dts/at91sam9x5.dtsi        |   67 ------------------------------
>>   arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   56 +++++++++++++++++++++++++
>>   arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   44 ++++++++++++++++++++
>>   arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   51 +++++++++++++++++++++++
>>   8 files changed, 158 insertions(+), 88 deletions(-)
>>   create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>>   create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>>   create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>>
> [snip]
>> diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>> new file mode 100644
>> index 0000000..5589579
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>> @@ -0,0 +1,51 @@
>> +/*
>> + * at91sam9x5_lcdc.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
>> + * 4 USART.
> One minor comment mistake here !
Nice catch!

I'll fix it for the next version.

BTW did you test it (I didn't: I don't have any board with this SoC 
family) ?

This separation was formerly done in the "at91 common clk" series but I 
removed it
from the new version (which I will submit soon) to ease the review and 
tests.


Best Regards,

Boris
>> + *
>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>> + *
>> + * Licensed under GPLv2.
>> + */
>> +
>> +#include <dt-bindings/pinctrl/at91.h>
>> +#include <dt-bindings/interrupt-controller/irq.h>
>> +
>> +/ {
>> +       ahb {
>> +               apb {
>> +                       pinctrl@fffff400 {
>> +                               usart3 {
>> +                                       pinctrl_usart3: usart3-0 {
>> +                                               atmel,pins =
>> +                                                       <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP        /* PC22 periph B with pullup */
>> +                                                        AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC23 periph B */
>> +                                       };
>> +
>> +                                       pinctrl_usart3_rts: usart3_rts-0 {
>> +                                               atmel,pins =
>> +                                                       <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC24 periph B */
>> +                                       };
>> +
>> +                                       pinctrl_usart3_cts: usart3_cts-0 {
>> +                                               atmel,pins =
>> +                                                       <AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC25 periph B */
>> +                                       };
>> +
>> +                                       pinctrl_usart3_sck: usart3_sck-0 {
>> +                                               atmel,pins =
>> +                                                       <AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC26 periph B */
>> +                                       };
>> +                               };
>> +                       };
>> +
>> +                       usart3: serial@f8028000 {
>> +                               compatible = "atmel,at91sam9260-usart";
>> +                               reg = <0xf8028000 0x200>;
>> +                               interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>> +                               pinctrl-names = "default";
>> +                               pinctrl-0 = <&pinctrl_usart3>;
>> +                               status = "disabled";
>> +                       };
>> +               };
>> +       };
>> +};
>> --
>> 1.7.9.5
>>
>
>

