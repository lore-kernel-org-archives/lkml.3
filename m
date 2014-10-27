Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaJ0Hof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:44:35 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56789 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254AbaJ0Hoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:44:32 -0400
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 0/7] ARM: mediatek: Add support for interrupt
 polarity
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <arm@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>
In-Reply-To: <1414163209.14830.614.camel@mtksdaap41>
References: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
	 <CABuKBeLjFDm2TSqxc=K3rDnYTKRok3sCvEuL+chxxo7p1UbhLQ@mail.gmail.com>
	 <1414163209.14830.614.camel@mtksdaap41>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Oct 2014 15:44:22 +0800
Message-ID: <1414395862.32399.9.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Matthias,

On Fri, 2014-10-24 at 23:06 +0800, Yingjoe Chen wrote:
> On Fri, 2014-10-24 at 16:59 +0200, Matthias Brugger wrote:
> > Hi Joe,
> > 
> > 2014-10-23 17:53 GMT+02:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> > > This series is 4th version of interrupt polarity support for MediaTek SoCs.
> > > This is based on Jiang's hierarchy irqdomain v2 [1] and my mediatek SoC
> > > basic support [2].
> > >
> > > This version addressed comments from previous discussion[3]. I removed
> > > arm,hierarchy-irq-domain property. When GIC is probed by DT, it will
> > > support hierarchy irqdomain. I still keep the first patch because this is
> > > still base on hierarchy irqdomain v2.
> > 
> > Is this set based on v3.17-rc1?
> > Is it based on one of Jiangs trees [0]?
> > 
> > I tried to use your patch set with v3.18-rc1 using Jiangs tree but the
> > kernel crashed on mt6589 with a null-pointer exception [1]. A test
> > with mt6592 didn't work either.
> > 
> > It would be convenient if you rebase your patches to v3.18-rc1.
> 
> It is based on Jiang's tree[0], which is based on v3.17-rc1. So yes,
> this series is still on v3.17-rc1.
> 
> All I need from Jiang's series are the first 2 patches, I'll bring them
> to v3.18-rc1 to test next week.

I cherry-pick/rebase my series with Jiang's 2 patches to v3.18-rc1,
there are 2 conflicts but they are quite easy to fix so I won't repost
this series now. I tested it on mt8127 with Eddie's uart patch and it
boot to shell successfully.

About crash on mt6589, I made a mistake in mt6589.dtsi. Please help to
test with the following change:

--- a/arch/arm/boot/dts/mt6589.dtsi
+++ b/arch/arm/boot/dts/mt6589.dtsi
@@ -86,7 +86,7 @@
                        interrupt-controller;
                        #interrupt-cells = <3>;
                        interrupt-parent = <&gic>;
-                       reg = <0 0x10200100 0 0x1c>;
+                       reg = <0x10200100 0x1c>;

Joe.C


