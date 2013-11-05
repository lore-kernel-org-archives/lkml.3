Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3KEIyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:54:22 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62359 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEIyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:54:19 -0500
MIME-Version: 1.0
In-Reply-To: <5277E752.8090005@ti.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
 <1383406775-14902-5-git-send-email-prabhakar.csenng@gmail.com> <5277E752.8090005@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 5 Nov 2013 14:23:54 +0530
Message-ID: <CA+V-a8uV0g36LoQtxFjR56SaMxj7KOE2ztC+pfT_Pn1wGcqEmw@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] gpio: davinci: add OF support
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, LDOC <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

Thanks for the review.

On Mon, Nov 4, 2013 at 11:58 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Prabhakar Lad,
>
>
> On 11/02/2013 05:39 PM, Lad, Prabhakar wrote:
>>
>> From: KV Sujith <sujithkv@ti.com>
>>
>> This patch adds OF parser support for davinci gpio
>> driver and also appropriate documentation in gpio-davinci.txt
>> located at Documentation/devicetree/bindings/gpio/.
>
>
> I worry, do we need to have gpio_chip.of_xlate() callback implemented?

I looked for the other OF GPIO implementations with same "ngpio"
property (marvel, msm) but I don’t see of_xlate() callback implemented.

> - From one side, Davinci GPIO controller in DT described by one entry
> which defines number of supported GPIOs as "ti,ngpio = <144>;"
>
> - From other side, on Linux level more than one gpio_chip objects are
> instantiated (one per each 32 GPIO).
>
> How the standard GPIO biding will work in this case? .. And will they?
>
> Linus, I'd very appreciate if you will be able to clarify this point.
>
>
>>
>> Signed-off-by: KV Sujith <sujithkv@ti.com>
>> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>> [prabhakar.csengg@gmail.com: simplified the OF code, removed
>>                 unnecessary DT property and also simplified
>>                 the commit message]
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>   .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 ++++++++++++
>>   drivers/gpio/gpio-davinci.c                        |   54
>> ++++++++++++++++++--
>>   2 files changed, 83 insertions(+), 3 deletions(-)
>>   create mode 100644
>> Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> new file mode 100644
>> index 0000000..55aae1c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> @@ -0,0 +1,32 @@
>> +Davinci GPIO controller bindings
>> +
>> +Required Properties:
>> +- compatible: should be "ti,dm6441-gpio"
>> +
>> +- reg: Physical base address of the controller and the size of memory
>> mapped
>> +       registers.
>> +
>> +- gpio-controller : Marks the device node as a gpio controller.
>> +
>> +- interrupts: Array of GPIO interrupt number.
>
>
> May be meaning of <interrupts> property need to be extended, because,
> as of now, only banked or unbanked IRQs are supported - and not both.
>
>
OK

>> +
>> +- ti,ngpio: The number of GPIO pins supported.
>> +
>> +- ti,davinci-gpio-unbanked: The number of GPIOs that have an individual
>> interrupt
>> +                            line to processor.
>
>
> Should interrupt-controller; specifier be added here?
>
No

>
>> +
>> +Example:
>> +
>> +gpio: gpio@1e26000 {
>> +       compatible = "ti,dm6441-gpio";
>> +       gpio-controller;
>> +       reg = <0x226000 0x1000>;
>> +       interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
>> +               44 IRQ_TYPE_EDGE_BOTH 45 IRQ_TYPE_EDGE_BOTH
>> +               46 IRQ_TYPE_EDGE_BOTH 47 IRQ_TYPE_EDGE_BOTH
>> +               48 IRQ_TYPE_EDGE_BOTH 49 IRQ_TYPE_EDGE_BOTH
>> +               50 IRQ_TYPE_EDGE_BOTH>;
>> +       ti,ngpio = <144>;
>> +       ti,davinci-gpio-irq-base = <101>;
>
>
>         ^^ Is it still needed?
>
OOps missed to remove that.

Regards,
--Prabhakar Lad
