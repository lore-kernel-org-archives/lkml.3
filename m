Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaKDHlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:41:06 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53300 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaKDHlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:41:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: HC Yen <hc.yen@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        "Joe. C" <yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
Date: Tue, 04 Nov 2014 08:39:55 +0100
Message-ID: <13477264.GuOdydWub7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415083006.10186.85.camel@mtksdaap41>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com> <CABuKBeLYMbD-dV_25FJd_NE1RgfVkgF+SoCiAx9O9jKUUAcexA@mail.gmail.com> <1415083006.10186.85.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RCRbeeasEAzLXprxyNSuUeAHZ+zndRBlZD5eJwPv0Ni
 67oUBU2tAeDQWVHet8K+VC1+eNhLwjPzfuXPSJtOfGHB4Zigh3
 b540C/2Dg0EsZ1Zou/GCYIc+TgkeTxip+2SyvJdDEQIyuu/Z0V
 iumHoSe2c0nLqQqOc+CWAEQgN/brULGHap22p7nuFZotfM+Bq+
 8Me3b3GeH2+7wnVZiuC5wxk/Zo8Ry0fqHkEaJVycjO8zFhaK40
 +466BmMNC9hW1Lf+53bwiWWvR95NPHqJaISRCStQVSUZR1DOCI
 tY9YQgWAoZ9mh81W3GnafI1pRIY0+tGEdb81Ma0TeC4uXqtw3D
 WabUUa+Npm/t6gkqxbEI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2014 14:36:45 HC Yen wrote:
> > > +
> > > +#include <dt-bindings/interrupt-controller/irq.h>
> > > +#include <dt-bindings/interrupt-controller/arm-gic.h>
> > > +#include "skeleton64.dtsi"
> > 
> > Cortex a7 is 32 bits, right? So why do you use skeleton64.dtsi?
> 
> Cortex-A7 is 32-bit, but that doesn't mean it can only have 32-bit
> physical address.  With LPAE enabled, we can have physical address more
> than 32 bits.
> 
> The main difference between "skeleton64.dtsi" and "skeleton.dtsi" is
> "#address-cells" property set to 2.  Although there are few sources
> using "skeleton64.dtsi", some of them write "#address-cells = <2>"
> directly in order to have 64-bit address space.  ARM's TC2 reference
> platform (vexpress-v2p-ca15_a7.dts) is an example.
> 
> Some of MediaTek ARMv7 SoCs support address space larger than 4GB. It
> will be convenient to share the sources if we all use 64-bit device
> tree.

Right, in general, I'd use #address-cells=<2> for Cortex-A7/A15/A17.

	Arnd
