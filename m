Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbaLJOhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:37:19 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51745 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755993AbaLJOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:37:16 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH 2/4] irqchip: mediatek: Add support for mt8173
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, Robert Richter <rrichter@cavium.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>, <yh.chen@mediatek.com>
In-Reply-To: <2545975.QDuBFbG7BN@wuerfel>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
	 <1418208602-35584-3-git-send-email-eddie.huang@mediatek.com>
	 <2545975.QDuBFbG7BN@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Dec 2014 22:37:13 +0800
Message-ID: <1418222233.21309.17.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnd,

On Wed, 2014-12-10 at 12:00 +0100, Arnd Bergmann wrote:
> On Wednesday 10 December 2014 18:50:00 Eddie Huang wrote:
> > From: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > 
> > MT8173 intpol have 32 more irq pins, add support to it.
> > 
> > Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> > 
> 
> How about adding a property for the number of irq pins and leave the
> old compatible string in place? I don't think it would be good if
> we have to update this driver for each new SoC that uses this
> irqchip just to change one number.
> 
> 	Arnd

OK, I'll change to something like this in next version:


--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
@@ -17,12 +17,17 @@ Required properties:
   use the same interrupt-cells format as GIC.
 - reg: Physical base address of the intpol registers and length of memory
   mapped region.

+Optional properties:
+- mediatek,intpol-number: The number of interrupts supported by intpol,
+  default 224 if omitted.
+
 Example:
        sysirq: interrupt-controller@10200100 {
                compatible = "mediatek,mt6589-sysirq", "mediatek,mt6577-sysirq";
                interrupt-controller;
                #interrupt-cells = <3>;
                interrupt-parent = <&gic>;
                reg = <0 0x10200100 0 0x1c>;
+               mediatek,intpol-number = <224>;
        };

Joe.C


