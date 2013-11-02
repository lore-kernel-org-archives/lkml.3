Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3KBPuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:50:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54699 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3KBPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <525BE2B2.8020105@ti.com>
References: <1380902596-4693-1-git-send-email-sujithkv@ti.com>
 <1380902596-4693-2-git-send-email-sujithkv@ti.com> <CACRpkdYxegBSYXR1-98smUNnDXpyRHo_vuYdnr3r7zhawENiUA@mail.gmail.com>
 <CA+V-a8vyPyL0j0nPOZyjxrecusFzXovFPsNBLKYXns5ASWR-wg@mail.gmail.com>
 <CACRpkdYNexWWXuQ052xuQ4NOdXm2gt-+ByREKeGo-VAnbH4D2w@mail.gmail.com>
 <CA+V-a8vH7VXqz=2cz-uD=YfRBRYrJ10K1Aptw28vV8gP+PiT2g@mail.gmail.com> <525BE2B2.8020105@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 2 Nov 2013 21:19:59 +0530
Message-ID: <CA+V-a8uqErBvzjnHq4yvtti4cJ1D6sXx3_r-p=E+yhMCTZ6JJw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] gpio: davinci: add OF support
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
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

Hi Grygorii,

On Mon, Oct 14, 2013 at 5:55 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Prabhakar Lad,
>
> On 10/11/2013 07:18 PM, Prabhakar Lad wrote:
>> Hi Linus,
>>
>> On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Fri, Oct 11, 2013 at 4:59 PM, Prabhakar Lad
>>> <prabhakar.csengg@gmail.com> wrote:
>>>> On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>>> On Fri, Oct 4, 2013 at 6:03 PM, Prabhakar Lad
>>>>> <prabhakar.csengg@gmail.com> wrote:
>>>
>>>>>> +- ti,davinci-gpio-irq-base: Base from where GPIO interrupt numbering
>>>>>> starts.
>>>>>
>>>>> What is this?
>>>>>
>>>>> If I have ever ACKed this I have been drunk. I take it back.
>>>>>
>>>> here is the ACK https://patchwork.kernel.org/patch/2721181/
>>>
>>> And as suspected that version of the patch did not contain
>>> this strange node property.
>>>
>> The property did exist in the patch 'intc_irq_num', I just renamed
>> it and gave a proper description to it.
>>
>>> Don't keep my ACK on patches if you change basic stuff like
>>> that, they need to be re-acked, this runs the risk of abusing
>>> my trust amongst other subsystem maintainers who might
>>> go and merge this because "aha the GPIO maintainer
>>> thinks that this is OK".
>>>
>> Agreed, I carry forwarded the ACK since it had minor changes.
>>
>>>>> This "base" is a Linux-specific thing and has no place in the
>>>>> device tree, and shall not be there. You have to find some way to
>>>>> avoid this, what do you think some other OS should do with
>>>>> this value...
>>>>>
>>>>> All IRQs in Linux are assumed to be dynamically assigned numbers
>>>>> nowadays, with a property like this you can never switch on
>>>>> SPARSE_IRQ for the DaVinci.
>>>>>
>>>> Can you point to any alternative solution if you have any ?
>>>
>>> First convert this GPIO driver to use an irqdomain to map
>>> HW IRQs to Linux IRQs, and grab a few IRQ descriptors
>>> dynamically off the irq descriptor heap.
>>> Example: commit
>>> a6c45b99a658521291cfb66ecf035cc58b38f206
>>> "pinctrl/coh901: use irqdomain, allocate irqdescs"
>>>
>>> Then on a longer term convert DaVinci to use dynamically
>>> allocated IRQs for all interrupt controllers, and move it over
>>> to SPARSE_IRQ so you know this works.
>>>
>> Thanks for the pointers.
>>
>
> Could it be possible to use "interrupts" and "interrupt-names" to identify
> assigned banked & unbanked IRQs?
>
I did give thought for it but found out its taken as a single interrupt,
and comparing the names in the driver would be tedious. so as
of now I have kept as is for this.

> For example DM646x (http://www.ti.com/lit/ug/sprueq8a/sprueq8a.pdf):
>
> interrupts = <48 IRQ_TYPE_EDGE_BOTH>,
>              <49 IRQ_TYPE_EDGE_BOTH>,
>              <50 IRQ_TYPE_EDGE_BOTH>,
>              <51 IRQ_TYPE_EDGE_BOTH>,
>              <52 IRQ_TYPE_EDGE_BOTH>,
>              <53 IRQ_TYPE_EDGE_BOTH>,
>              <54 IRQ_TYPE_EDGE_BOTH>,
>              <55 IRQ_TYPE_EDGE_BOTH>,
>              <56 IRQ_TYPE_EDGE_BOTH>,
>              <57 IRQ_TYPE_EDGE_BOTH>,
>              <58 IRQ_TYPE_EDGE_BOTH>;
> interrupt-names = "gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7", "bank0", "bank1", "bank2";
>
> For example OMAP-L138 (http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf):
>
> interrupts = <42 IRQ_TYPE_EDGE_BOTH>,
>              <43 IRQ_TYPE_EDGE_BOTH>,
>              <44 IRQ_TYPE_EDGE_BOTH>,
>              <45 IRQ_TYPE_EDGE_BOTH>,
>              <46 IRQ_TYPE_EDGE_BOTH>,
>              <47 IRQ_TYPE_EDGE_BOTH>,
>              <48 IRQ_TYPE_EDGE_BOTH>,
>              <49 IRQ_TYPE_EDGE_BOTH>,
>              <50 IRQ_TYPE_EDGE_BOTH>;
>
> interrupt-names = "bank0", "bank1", "bank2", "bank3", "bank4", "bank5", "bank6", "bank7", "bank8";
>
> For example Keystone 66AK2E05/02
>  (http://www.ti.com/lit/ds/sprs865a/sprs865a.pdf and http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf):
>
> interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
>              <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
> [..]
>              <GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>,
>              <GIC_SPI 151 IRQ_TYPE_LEVEL_HIGH>;
>
>
> interrupt-names = "gpio0", "gpio1", [...], "gpio30", "gpio31";
>
> So then, following properties would not be needed at all, because all inf. can be
> taken from interrupt's properties:
> +- ti,davinci-gpio-irq-base: Base from where GPIO interrupt numbering starts.
Yeah dropped this.

> +- ti,davinci-gpio-unbanked: The number of GPIOs that have an individual interrupt line to processor.
>
Kept as is
> It should work good if Davinci-gpio driver will be converted to use
> linear IRQ domains for banked irqs.
>
Yeah migrated it to use IRQ domains.

I have posted the updated patch series at [1], please have a look at it.

[1] http://linux.omap.com/pipermail/davinci-linux-open-source/2013-November/028220.html

Regards,
--Prabhakar Lad
