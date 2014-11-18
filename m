Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaKRQYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:24:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47595 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaKRQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:24:47 -0500
Date: Tue, 18 Nov 2014 17:24:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Heiko =?utf-8?B?U3Tvv71ibmVy?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eddie.huang@mediatek.com,
        dandan.he@mediatek.com, alan.cheng@mediatek.com, toby.liu@mediatek.com
Subject: Re: [PATCH v3 0/3] Add Mediatek SoC Pinctrl/GPIO driver for MT8135.
Message-ID: <20141118162422.GI14482@pengutronix.de>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:19:57 up 34 days,  3:33, 83 users,  load average: 0.16, 0.06,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Is this driver generally ok? It basically implements the binding
suggested as RFC (except that mediatek,pins should only be pins).
Are you Ok with this approach? Anything else missing?

Sascha

On Tue, Nov 11, 2014 at 08:38:52PM +0800, Hongzhou Yang wrote:
> This is v3 of add Mediatek SoC Pinctrl/GPIO drvier for MT8135.
> It is based on Joe.C' basic device tree support.
> See http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296093.html
> 
> This driver include common and MT8135 part, other Mediatek SoCs will share the common part,
> and MT8135 part only support MT8135. MT8135 has GPIO controller, it includes 203 pins.
> 
> Changes in v3:
>   - Rebase on 3.18-rc1.
>   - Follow '[RFC] pinctrl: Provide a generic device tree binding for per-pin pin controllers', modify mediatek,pins format,
>     add config setting for each pin, the reason is that each pin may have different config.
>     The RFC link: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296491.html
>   - Switch to use syscon regmap.
>   - Add CLR_ADDR() and SET_ADDR() macros.
>   - Add mtk_pconf_set_ies() and mtk_pconf_set_smt() functions to deal with input-enable and input-schmitt-enable.
>   - Rename mt_gpio_devdata to mtk_pinctrl_devdata.
>   - Rename all mt_prefix to mtk_prefix.
>   - Rename mt_pconf_pull_conf() to mtk_pconf_parse_conf, add mtk_pconf_set_pull_select() to deal with pull enable and pull up/down.
>     And we will add PIN_CONFIG_DRIVE_STRENGTH to mtk_pconf_parse_conf().
> 
> According to Linus' suggestion, make some following changes:
>   - Add port_shf, port_mask and port_align members to mtk_pinctrl_devdata struct.
>   - Use BIT(x) instead of 1 << (x).
>   - Remove mt_pctrl_write_reg() and mt_pctrl_read_reg().
>   - Remove mt_gpio_of_xlate().
>   - Use .set_mux() instead of .enable().
>   - Add some comments.
> 
> Hongzhou Yang (3):
>   ARM: mediatek: Add Pinctrl/GPIO driver for mt8135.
>   dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
>   ARM: dts: mt8135: Add pinctrl/GPIO node for mt8135.
> 
>   .../devicetree/bindings/pinctrl/pinctrl-mt65xx.txt |  123 +
>   arch/arm/boot/dts/mt8135-pinfunc.h                 | 1304 +++++++++++
>   arch/arm/boot/dts/mt8135.dtsi                      |   19 +
>   arch/arm/mach-mediatek/Kconfig                     |    1 +
>   drivers/pinctrl/Kconfig                            |    1 +
>   drivers/pinctrl/Makefile                           |    1 +
>   drivers/pinctrl/mediatek/Kconfig                   |   12 +
>   drivers/pinctrl/mediatek/Makefile                  |    5 +
>   drivers/pinctrl/mediatek/pinctrl-mt8135.c          |   87 +
>   drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |  861 +++++++
>   drivers/pinctrl/mediatek/pinctrl-mtk-common.h      |  123 +
>   drivers/pinctrl/mediatek/pinctrl-mtk-mt8135.h      | 2460 ++++++++++++++++++++
>   include/dt-bindings/pinctrl/mt65xx.h               |   23 +
>   13 files changed, 5020 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-mt65xx.txt
>   create mode 100644 arch/arm/boot/dts/mt8135-pinfunc.h
>   create mode 100644 drivers/pinctrl/mediatek/Kconfig
>   create mode 100644 drivers/pinctrl/mediatek/Makefile
>   create mode 100644 drivers/pinctrl/mediatek/pinctrl-mt8135.c
>   create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-common.c
>   create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-common.h
>   create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-mt8135.h
>   create mode 100644 include/dt-bindings/pinctrl/mt65xx.h
> 
> --
> 1.8.1.1.dirty
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
