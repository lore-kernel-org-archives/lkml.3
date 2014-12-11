Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaLKMrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:47:14 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:46532 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbaLKMrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:47:12 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Yingjoe Chen <yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        YH Chen =?UTF-8?Q?=28=E9=99=B3=E6=98=B1=E8=B1=AA=29?= 
	<yh.chen@mediatek.com>
In-Reply-To: <CABuKBe+U22ogGBToftgaSJw6fcJmciGfa9scAkyP3g5OJSaAOA@mail.gmail.com>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
	 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
	 <1418221662.21309.13.camel@mtksdaap41>
	 <CABuKBe+U22ogGBToftgaSJw6fcJmciGfa9scAkyP3g5OJSaAOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Dec 2014 20:47:06 +0800
Message-ID: <1418302026.1992.18.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 15:50 +0100, Matthias Brugger wrote:
> 2014-12-10 15:27 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> >
> > Hi,
> >
> > On Wed, 2014-12-10 at 18:50 +0800, Eddie Huang wrote:
> > <...>
> >> diff --git a/arch/arm64/boot/dts/mt8173-evb.dts b/arch/arm64/boot/dts/mt8173-evb.dts
> >> new file mode 100644
> >> index 0000000..adf26dd
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/mt8173-evb.dts
> > <...>
> >> +     timer {
> >> +             compatible = "arm,armv8-timer";
> >> +             interrupt-parent = <&gic>;
> >> +             interrupts = <1 13 0x8>,
> >> +                          <1 14 0x8>,
> >> +                          <1 11 0x8>,
> >> +                          <1 10 0x8>;
> >> +             clock-frequency = <13000000>;
> >
> > I believe our firmware doesn't need this line. Please remove it.
> 
> The point here would be to know if you need to enable a special timer
> from the mtk-timer block to get the arch timer working.
> In any case, you will need some sort of timer. This dts does not
> describe the mtk-timer (may in the mt8173 it does not exist) but
> defines the clocks clk26m and clk32k. So if you don't use the
> mtk-timer, please remove the clocks as there isn't a block using them.
> 

MT8173 has two timer set: CPUGPT and APBGPT, and use CPUGPT to enable
arch_timer. Previous series only have APBGPT. MT8173 still need enable
CPUGPT to get arch timer working, we put this in loader, and transparent
to kernel. So I will remove clk26m and clk32k in next version.


