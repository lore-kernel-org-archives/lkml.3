Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaKDIgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:36:43 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:39326 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKDIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:36:41 -0500
MIME-Version: 1.0
In-Reply-To: <13477264.GuOdydWub7@wuerfel>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	<CABuKBeLYMbD-dV_25FJd_NE1RgfVkgF+SoCiAx9O9jKUUAcexA@mail.gmail.com>
	<1415083006.10186.85.camel@mtksdaap41>
	<13477264.GuOdydWub7@wuerfel>
Date: Tue, 4 Nov 2014 09:36:39 +0100
Message-ID: <CABuKBeL1JX88BBK7uXqpmaGzwCe5D6inB_n-NV6ajUt59V1swA@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] ARM: mediatek: Add basic support for mt8127
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: HC Yen <hc.yen@mediatek.com>, "Joe. C" <yingjoe.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-04 8:39 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 04 November 2014 14:36:45 HC Yen wrote:
>> > > +
>> > > +#include <dt-bindings/interrupt-controller/irq.h>
>> > > +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> > > +#include "skeleton64.dtsi"
>> >
>> > Cortex a7 is 32 bits, right? So why do you use skeleton64.dtsi?
>>
>> Cortex-A7 is 32-bit, but that doesn't mean it can only have 32-bit
>> physical address.  With LPAE enabled, we can have physical address more
>> than 32 bits.
>>
>> The main difference between "skeleton64.dtsi" and "skeleton.dtsi" is
>> "#address-cells" property set to 2.  Although there are few sources
>> using "skeleton64.dtsi", some of them write "#address-cells = <2>"
>> directly in order to have 64-bit address space.  ARM's TC2 reference
>> platform (vexpress-v2p-ca15_a7.dts) is an example.
>>
>> Some of MediaTek ARMv7 SoCs support address space larger than 4GB. It
>> will be convenient to share the sources if we all use 64-bit device
>> tree.
>
> Right, in general, I'd use #address-cells=<2> for Cortex-A7/A15/A17.

Alright, thanks for clarification. So we should use skeleton64.dtsi
for mt6589 as well, right?

>
>         Arnd



-- 
motzblog.wordpress.com
