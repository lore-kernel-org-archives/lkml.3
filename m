Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3JKO7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:59:48 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54736 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3JKO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYxegBSYXR1-98smUNnDXpyRHo_vuYdnr3r7zhawENiUA@mail.gmail.com>
References: <1380902596-4693-1-git-send-email-sujithkv@ti.com>
	<1380902596-4693-2-git-send-email-sujithkv@ti.com>
	<CACRpkdYxegBSYXR1-98smUNnDXpyRHo_vuYdnr3r7zhawENiUA@mail.gmail.com>
Date: Fri, 11 Oct 2013 20:29:44 +0530
Message-ID: <CA+V-a8vyPyL0j0nPOZyjxrecusFzXovFPsNBLKYXns5ASWR-wg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] gpio: davinci: add OF support
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus ,

On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Oct 4, 2013 at 6:03 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>
>> This patch adds OF parser support for davinci gpio
>> driver and also appropriate documentation in gpio-davinci.txt
>> located at Documentation/devicetree/bindings/gpio/.
>>
>> Signed-off-by: KV Sujith <sujithkv@ti.com>
>> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> ^Don't trust this guy.
>
>> [prabhakar.csengg@gmail.com: simplified the OF code and also
>>                  the commit message]
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  .../devicetree/bindings/gpio/gpio-davinci.txt      |   34 +++++++++++
>>  drivers/gpio/gpio-davinci.c                        |   60
>> +++++++++++++++++++-
>>  2 files changed, 91 insertions(+), 3 deletions(-)
>>  create mode 100644
>> Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> new file mode 100644
>> index 0000000..87abd3b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>> @@ -0,0 +1,34 @@
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
>> +
>> +- ngpio: The number of GPIO pins supported.
>> +
>> +- ti,davinci-gpio-irq-base: Base from where GPIO interrupt numbering
>> starts.
>
> What is this?
>
> If I have ever ACKed this I have been drunk. I take it back.
>
here is the ACK https://patchwork.kernel.org/patch/2721181/

> This "base" is a Linux-specific thing and has no place in the
> device tree, and shall not be there. You have to find some way to
> avoid this, what do you think some other OS should do with
> this value...
>
> All IRQs in Linux are assumed to be dynamically assigned numbers
> nowadays, with a property like this you can never switch on
> SPARSE_IRQ for the DaVinci.
>
Can you point to any alternative solution if you have any ?

-- 
Regards,
--Prabhakar Lad
