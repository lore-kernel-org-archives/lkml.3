Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaJBODA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:03:00 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62902 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaJBOC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140924124044.GC4992@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
	<CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
	<20140924124044.GC4992@pengutronix.de>
Date: Thu, 2 Oct 2014 16:02:58 +0200
Message-ID: <CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 2:40 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Sep 24, 2014 at 01:23:09PM +0200, Linus Walleij wrote:

>> I haven't got to reviewing the driver, but this looks just wrong.
>>
>> Have the magic numbers in the driver.
>>
>> Use strings to describe functions, not integers.
>
> Interrupts, clocks, gpios, dma channels, nearly everything in the device tree is
> arbitrarily numbered. Instead of "irq-i2c0" we have <0 36 IRQ_TYPE_LEVEL_HIGH>
> in the device tree. These numbers can be resolved efficiently in the
> driver by shifting them to get a bitmask or by adding them as offset to
> a register base.
> Why do you want to make pinctrl different?

Because pin control is about combining groups of pins with
certain functions.

> Thanks to the recently
> introduced defines in the device trees these numbers are not magic at
> all anymore.

Yeah that is good but not what I'm after here.

>> We need to move toward standardized device tree bindings
>> for this stuff, and that means using strings, not magic
>> numbers.
>
> Agreed for standardized device tree bindings, but not for using strings.

What is the alternative? Device Tree is very much about strings,
as is shown by the pin config bindings.

Yours,
Linus Walleij
