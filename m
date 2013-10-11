Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3JKPyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:54:22 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58167 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3JKPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vyPyL0j0nPOZyjxrecusFzXovFPsNBLKYXns5ASWR-wg@mail.gmail.com>
References: <1380902596-4693-1-git-send-email-sujithkv@ti.com>
	<1380902596-4693-2-git-send-email-sujithkv@ti.com>
	<CACRpkdYxegBSYXR1-98smUNnDXpyRHo_vuYdnr3r7zhawENiUA@mail.gmail.com>
	<CA+V-a8vyPyL0j0nPOZyjxrecusFzXovFPsNBLKYXns5ASWR-wg@mail.gmail.com>
Date: Fri, 11 Oct 2013 17:54:18 +0200
Message-ID: <CACRpkdYNexWWXuQ052xuQ4NOdXm2gt-+ByREKeGo-VAnbH4D2w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] gpio: davinci: add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
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

On Fri, Oct 11, 2013 at 4:59 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Oct 4, 2013 at 6:03 PM, Prabhakar Lad
>> <prabhakar.csengg@gmail.com> wrote:

>>> +- ti,davinci-gpio-irq-base: Base from where GPIO interrupt numbering
>>> starts.
>>
>> What is this?
>>
>> If I have ever ACKed this I have been drunk. I take it back.
>>
> here is the ACK https://patchwork.kernel.org/patch/2721181/

And as suspected that version of the patch did not contain
this strange node property.

Don't keep my ACK on patches if you change basic stuff like
that, they need to be re-acked, this runs the risk of abusing
my trust amongst other subsystem maintainers who might
go and merge this because "aha the GPIO maintainer
thinks that this is OK".

>> This "base" is a Linux-specific thing and has no place in the
>> device tree, and shall not be there. You have to find some way to
>> avoid this, what do you think some other OS should do with
>> this value...
>>
>> All IRQs in Linux are assumed to be dynamically assigned numbers
>> nowadays, with a property like this you can never switch on
>> SPARSE_IRQ for the DaVinci.
>>
> Can you point to any alternative solution if you have any ?

First convert this GPIO driver to use an irqdomain to map
HW IRQs to Linux IRQs, and grab a few IRQ descriptors
dynamically off the irq descriptor heap.
Example: commit
a6c45b99a658521291cfb66ecf035cc58b38f206
"pinctrl/coh901: use irqdomain, allocate irqdescs"

Then on a longer term convert DaVinci to use dynamically
allocated IRQs for all interrupt controllers, and move it over
to SPARSE_IRQ so you know this works.

Yours,
Linus Walleij
