Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKDJqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:46:36 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52281 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaKDJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:46:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
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
Subject: Re: [PATCH v4 1/8] ARM: mediatek: Add basic support for mt8127
Date: Tue, 04 Nov 2014 10:45:40 +0100
Message-ID: <4360790.RbZnni9y9f@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABuKBeL1JX88BBK7uXqpmaGzwCe5D6inB_n-NV6ajUt59V1swA@mail.gmail.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com> <13477264.GuOdydWub7@wuerfel> <CABuKBeL1JX88BBK7uXqpmaGzwCe5D6inB_n-NV6ajUt59V1swA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V2BuAKw1Cx5DHa7wx70a3IMhGUY4xl62L/1QSvu5lzN
 Mye+5h3REgVQZkuZMYItBl8jXJONzctWd7mSMkxYvcT2c+iX4u
 74wWHuXACpfc57433hYBaUpF2HGXl26AgNm5ADrTuf+H4yKJz0
 0Wpj1idEkDLwYisRrPV+E6tqsxbkHD3olj9ecbRTufroY4wgG5
 R2RSsB6o47nskU6BSHX9dkO2HE6Kzq1CH7oTW+lqxfQGQ7/MZU
 tYOCoMjwwv7zLf1YuCGrDWeC5coqMQrN7/EzwGJq+68QGPyP7F
 /kijdqJh2emvynCmbh6CP+GeFbrJsW45XJn4cZpmr35u1Qxa82
 a9AMIfgv+QOl2EfMkKQ4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2014 09:36:39 Matthias Brugger wrote:
> 2014-11-04 8:39 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> > On Tuesday 04 November 2014 14:36:45 HC Yen wrote:
> >> > > +
> >> > > +#include <dt-bindings/interrupt-controller/irq.h>
> >> > > +#include <dt-bindings/interrupt-controller/arm-gic.h>
> >> > > +#include "skeleton64.dtsi"
> >> >
> >> > Cortex a7 is 32 bits, right? So why do you use skeleton64.dtsi?
> >>
> >> Cortex-A7 is 32-bit, but that doesn't mean it can only have 32-bit
> >> physical address.  With LPAE enabled, we can have physical address more
> >> than 32 bits.
> >>
> >> The main difference between "skeleton64.dtsi" and "skeleton.dtsi" is
> >> "#address-cells" property set to 2.  Although there are few sources
> >> using "skeleton64.dtsi", some of them write "#address-cells = <2>"
> >> directly in order to have 64-bit address space.  ARM's TC2 reference
> >> platform (vexpress-v2p-ca15_a7.dts) is an example.
> >>
> >> Some of MediaTek ARMv7 SoCs support address space larger than 4GB. It
> >> will be convenient to share the sources if we all use 64-bit device
> >> tree.
> >
> > Right, in general, I'd use #address-cells=<2> for Cortex-A7/A15/A17.
> 
> Alright, thanks for clarification. So we should use skeleton64.dtsi
> for mt6589 as well, right?

If the chip is capable of accessing memory or registers higher than 4GB
physical address, then you should, yes.

If the SoC has limitations that mean you can't have higher addresses
anyway, then either way is fine, no need to change it.

	Arnd
