Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3KUKfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:35:32 -0500
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:54626 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455Ab3KUKfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:35:31 -0500
Message-ID: <528DE1C4.6060900@overkiz.com>
Date: Thu, 21 Nov 2013 11:34:44 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek
 board
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>	<1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>	<20131120145926.GE14627@ns203013.ovh.net>	<528CDFFB.1020601@overkiz.com> <CACRpkdboBg4YOnMNiar0DDBVnoky=zNky+Pzyp1=P_POtH15qQ@mail.gmail.com>
In-Reply-To: <CACRpkdboBg4YOnMNiar0DDBVnoky=zNky+Pzyp1=P_POtH15qQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16268690705623120093
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 21/11/2013 10:48, Linus Walleij wrote:
> On Wed, Nov 20, 2013 at 5:14 PM, boris brezillon
> <b.brezillon@overkiz.com> wrote:
>> On 20/11/2013 15:59, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> On 13:06 Wed 28 Aug     , Boris BREZILLON wrote:
>>>> mmc0_slot0_switch-0 {
>>>> +                                               atmel,pins =
>>>> +                                                       <AT91_PIOB 22
>>>> AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
>>>> +                                       };
>>> nack this is a regulator the pinctrl API is not done for gpio default
>>> value
>> I know this can be represented as a regulator, but looking at the datasheet,
>> this looks more like a switch than a regulator.
> No matter whether it's a switch or a GPIO regulator it seems we
> are in violent agreement that it should not be controlled by the
> pin control states at least.
>
> Start with making it a GPIO then you can figure out whether
> a GPIO regulator or drivers/extcon/extcon-gpio.c should be
> used.

Thanks for pointing this out. I wasn't aware of the extcon subsystem.

Actually, I think it's a little bit more tricky.

The switch connected to gpio PB22 is used to enable one device or the other:
  - PB22 set to high level enables slot0 of mmc0 (connect mmc signals to 
the mmc
    connector)
  - PB22 set to low level enables the dataflash (connect to the SPI0 
signals to the
    dataflash device)

I can declare a regulator for the mmc device and attach it to the mmc 
(AFAIK, the
mmc core will request the mmc regulator for us, and configure it 
accordingly).

But AFAICT (tell me if I'm wrong), there's no such things for spi devices.

The pinctrl approach has the benefit of providing a transparent way (no 
existing
drivers modifications) to enable one device or the other.

But if you think this is better done (or cleaner) with an extcon or a 
regulator device,
I'll try to find a way to do it this way.

Best Regards,

Boris

>
> Yours,
> Linus Walleij

