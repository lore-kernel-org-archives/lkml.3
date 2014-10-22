Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJVNSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:18:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49857 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaJVNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <1413973797-17619-9-git-send-email-yingjoe.chen@mediatek.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	<1413973797-17619-9-git-send-email-yingjoe.chen@mediatek.com>
Date: Wed, 22 Oct 2014 15:18:33 +0200
Message-ID: <CABuKBe+Ew6R2Kb90-gDHBQ4HuydfFxJdYmr+v9-KNC-b0K4Tkw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] ARM: mediatek: Add config option for mediatek SoCs.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, arm@kernel.org,
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
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 12:29 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
>
> Add config options for ARCH_MT6589, ARCH_MT8127, ARCH_MT8135. The
> upcoming pinctrl, clk drivers need to isolate SoCs support base on
> these options.
>
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/mach-mediatek/Kconfig | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
> index 2c043a2..25fe6cf 100644
> --- a/arch/arm/mach-mediatek/Kconfig
> +++ b/arch/arm/mach-mediatek/Kconfig
> @@ -1,6 +1,22 @@
> -config ARCH_MEDIATEK
> -       bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
> +menuconfig ARCH_MEDIATEK
> +       bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
>         select ARM_GIC
>         select MTK_TIMER
>         help
> -         Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
> +         Support for Mediatek MT65xx & MT81xx SoCs
> +
> +if ARCH_MEDIATEK
> +
> +config MACH_MT6589
> +       bool "MediaTek MT6589 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +config MACH_MT8127
> +       bool "MediaTek MT8127 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +config MACH_MT8135
> +       bool "MediaTek MT8135 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +endif

MACH_MTxxxx are not used nowhere, please remove them.

> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
