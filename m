Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbbA0KeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:34:24 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:49681 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757862AbbA0KeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:34:21 -0500
Message-ID: <1422354858.14015.39.camel@x220>
Subject: Re: [PATCH v5 1/5] ARM: mediatek: Add config options for mediatek
 SoCs.
From: Paul Bolle <pebolle@tiscali.nl>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com, alan.cheng@mediatek.com, toby.liu@mediatek.com,
        maoguang.meng@mediatek.com, huang eddie <eddie.huang@mediatek.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrsoft.com>
Date: Tue, 27 Jan 2015 11:34:18 +0100
In-Reply-To: <1422354400.32212.25.camel@mtksdaap41>
References: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1421818097-9281-2-git-send-email-hongzhou.yang@mediatek.com>
	 <CABuKBeJGigY5ym9cJy=PYK8jbdsOLLtkmovHq6xho4gYseCAWg@mail.gmail.com>
	 <1422353800.14015.35.camel@x220> <1422354400.32212.25.camel@mtksdaap41>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2015 10:34:18.0972 (UTC) FILETIME=[CE6141C0:01D03A1C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 2015-01-27 at 18:26 +0800, Yingjoe Chen wrote:
> On Tue, 2015-01-27 at 11:16 +0100, Paul Bolle wrote:
> > On Thu, 2015-01-22 at 13:54 +0100, Matthias Brugger wrote:
> > > 2015-01-21 6:28 GMT+01:00 Hongzhou Yang <hongzhou.yang@mediatek.com>:
> > > > From: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > > >
> > > > The upcoming MTK pinctrl driver have a big pin table for each SoC
> > > > and we don't want to bloat the kernel binary if we don't need it.
> > > > Add config options so we can build for one SoC only.
> > > >
> > > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > > Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > > > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> > > 
> > > Applied to v3.20-next/soc
> > 
> > This became commit ad8a221e1f49 ("ARM: mediatek: Add config options for
> > mediatek SoCs.") in today's linux-next (ie, next-20150127). I noticed
> > because a script I use to check linux-next spotted a problem with it.
> > 
> > > > ---
> > > >  arch/arm/mach-mediatek/Kconfig | 22 +++++++++++++++++++++-
> > > >  1 file changed, 21 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
> > > > index f73f588..f7e463c 100644
> > > > --- a/arch/arm/mach-mediatek/Kconfig
> > > > +++ b/arch/arm/mach-mediatek/Kconfig
> > > > @@ -1,6 +1,26 @@
> > > > -config ARCH_MEDIATEK
> > > > +menuconfig ARCH_MEDIATEK
> > > >         bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
> > > >         select ARM_GIC
> > > >         select MTK_TIMER
> > > >         help
> > > >           Support for Mediatek MT65xx & MT81xx SoCs
> > > > +
> > > > +if ARCH_MEDIATEK
> > > > +
> > > > +config MACH_MT6589
> > > > +       bool "MediaTek MT6589 SoCs support"
> > > > +       default ARCH_MEDIATEK
> > > > +
> > > > +config MACH_MT6592
> > > > +       bool "MediaTek MT6592 SoCs support"
> > > > +       default ARCH_MEDIATEK
> > > > +
> > > > +config MACH_MT8127
> > > > +       bool "MediaTek MT8127 SoCs support"
> > > > +       default ARCH_MEDIATEK
> > > > +
> > > > +config MACH_MT8135
> > > > +       bool "MediaTek MT8135 SoCs support"
> > > > +       default ARCH_MEDIATEK
> > > > +
> > > > +endif
> > 
> > None of these four new MACH_MT* Kconfig symbols are currently used in
> > linux-next. I assume that patches that actually use them (either as a
> > Kconfig symbol or as a CONFIG_* macro) are still pending. Is that
> > correct?
> 
> Yes, it is used in patch 3 in this series[1], and is discussed in [2].
> 
> Joe.C
> 
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/318453.html

That only seems to add a user for MACH_MT8135, not for the other three
symbols. The other three symbols will be used too, won't they?

> [2]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/315616.html

(For the record, that is a message regarding v4 of this patch.)


Paul Bolle

