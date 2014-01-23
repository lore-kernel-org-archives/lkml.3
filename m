Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaAWS1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:27:18 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48551 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAWS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <52E074ED.5000906@gmail.com>
References: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com>
 <1390361452-3124-8-git-send-email-marc.ceeeee@gmail.com> <CAGVrzcbPyaSe0aEHt157kz=quvsrBCPOUriCVG27fJfasa45jg@mail.gmail.com>
 <52E074ED.5000906@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 23 Jan 2014 10:26:36 -0800
Message-ID: <CAGVrzcauDKeNM-Tqxt67Km6r6sjqvwe9_ki_GLc9_ZiXOauN8Q@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] ARM: brcmstb: gic: add compatible string for
 Broadcom Brahma15
To: Marc C <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

2014/1/22 Marc C <marc.ceeeee@gmail.com>:
> Hi Florian,
>
>> Do not we also need to update drivers/irqchip/irq-gic.c to look for
>> this compatible property? Alternatively should the example DTS contain
>> the following:
>>
>> compatible = "brcm,brahma-b15-gic", "arm,cortex-a15-gic"?
>
> Patch #8 [1] of this series has the "compatible" string set exactly that way. I was
> following the pattern seen in the other reference DTS files, where "arm,cortex-a15-gic" is
> used as the fall-back.

Ah, I missed that, thanks! How about the CPU compatible property?
AFAIK it is only used by arch/arm/kernel/topology.c, I am not sure if
we have the exact same number to use as the "vanilla" Cortex-A15 here,
or if we should have another number match against "brcm,brahma-b15".
What do you think?

>
> Thanks,
> Marc C
>
> [1] https://lkml.org/lkml/2014/1/21/649
>
> On 01/22/2014 02:40 PM, Florian Fainelli wrote:
>> Hi Marc,
>>
>> 2014/1/21 Marc Carino <marc.ceeeee@gmail.com>:
>>> Document the Broadcom Brahma B15 GIC implementation as compatible
>>> with the ARM GIC standard.
>>>
>>> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
>>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> Do not we also need to update drivers/irqchip/irq-gic.c to look for
>> this compatible property? Alternatively should the example DTS contain
>> the following:
>>
>> compatible = "brcm,brahma-b15-gic", "arm,cortex-a15-gic"?
>>
>>> ---
>>>  Documentation/devicetree/bindings/arm/gic.txt |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>>> index 3dfb0c0..d7409fd 100644
>>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>>> @@ -15,6 +15,7 @@ Main node required properties:
>>>         "arm,cortex-a9-gic"
>>>         "arm,cortex-a7-gic"
>>>         "arm,arm11mp-gic"
>>> +       "brcm,brahma-b15-gic"
>>>  - interrupt-controller : Identifies the node as an interrupt controller
>>>  - #interrupt-cells : Specifies the number of cells needed to encode an
>>>    interrupt source.  The type shall be a <u32> and the value shall be 3.
>>> --
>>> 1.7.1
>>>
>>
>>
>>
>
>
>



-- 
Florian
