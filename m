Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbaLJPwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:52:04 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63200 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbaLJPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:52:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>, yh.chen@mediatek.com
Subject: Re: [PATCH 2/4] irqchip: mediatek: Add support for mt8173
Date: Wed, 10 Dec 2014 15:41:15 +0100
Message-ID: <4428865.bnDr16Yqvr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418222233.21309.17.camel@mtksdaap41>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com> <2545975.QDuBFbG7BN@wuerfel> <1418222233.21309.17.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BhnP1PwS+BZy9xprUQUYQVUTIIpc51HAQtiVM3iz7ChqCkfZqqJ
 tJOjaVZd7nAQzsRF68922LmCN7BfdOSzmDXUmhHa7Yd98EdXphujmq3lSs6+xHpozeCgSfU
 0e8tPeyCR7o3XXMQrc2idWFAX2enITQuSpaLUvrm9sMCLqlr0rjS21FgvAtoozw0Tl4jnBV
 FkfEHOwIIKU9ZCM9wsqmg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 22:37:13 Yingjoe Chen wrote:
> OK, I'll change to something like this in next version:

I've just taken another look at the driver and have a different
suggestion:

> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> @@ -17,12 +17,17 @@ Required properties:
>    use the same interrupt-cells format as GIC.
>  - reg: Physical base address of the intpol registers and length of memory
>    mapped region.
> 
> +Optional properties:
> +- mediatek,intpol-number: The number of interrupts supported by intpol,
> +  default 224 if omitted.
> +
>  Example:
>         sysirq: interrupt-controller@10200100 {
>                 compatible = "mediatek,mt6589-sysirq", "mediatek,mt6577-sysirq";
>                 interrupt-controller;
>                 #interrupt-cells = >;
>                 interrupt-parent = <&gic>;
>                 reg = <0 0x10200100 0 0x1c>;
> +               mediatek,intpol-number = <224>;
>         };

The number of interrupt pins directly corresponds to the size of the reg
property in bits, so I think you can just use that and don't even need
another property.

	Arnd
