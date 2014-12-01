Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaLAHF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:05:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLAHF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:05:27 -0500
Date: Mon, 1 Dec 2014 08:04:37 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v2 0/8] Add Support for MediaTek PMIC MT6397 MFD Core and
 Regulator
Message-ID: <20141201070437.GQ14482@pengutronix.de>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:52:43 up 46 days, 18:06, 44 users,  load average: 0.05, 0.09,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Flora,

Your Cc list is huge. You should limit it to the lists and to the
individuals you know are interested in this series, like maintainers,
people who work on Mediatek SoCs, people who commented on previous
series.

Sascha

On Fri, Nov 28, 2014 at 11:54:26AM +0800, Flora Fu wrote:
> 
> The patch sets add support for MediaTek PMIC MT6397 MFD core and its regulator driver.
> This is hardware layout for access PMIC MT6397 from AP SoC MT8135.
> Between PMIC MT6397 and MT8135, the physical signal channel is SPI bus.
> A specific hardware called PMIC Wrapper or PWRAP to handle access protocols in both PMIC and AP side.
> 
> +-----------------+           +---------------+
> |                 |           |               |
> | Mediatek AP SoC |           |               |
> | (ex. MT8135)    |           |    MT6397     |
> |                 |           |               |
> |      +--------+ | (SPI bus) | +--------+    |
> |      |        | |-----------| |        |    |
> |      |  PMIC  | |-----------| |  PMIC  |    |
> |      | Wrapper| |-----------| | Wrapper|    |
> |      |        | |-----------| |        |    |
> |      +--------+ |           | +--------+    |
> |                 |           |               |
> +-----------------+           +---------------+
> 
> Changes since v1
> ================
> (1) Patch 1/8: Add MT8135 PMIC wrapper driver for SoC's proprietary hardware.
> (2) Patch 2/8: Update patch of MT6397 MFD driver to contain only MFD related codes and fix defeat of coding styles.
> (3) Patch 3/8: Update MT6397 regulator driver
> 	- use helpers and standard ways for specifying data in regulator description.
> 	- add more comments to explaining why the driver implement its own regulator_ops for ".is_enabled", ".set_voltage_sel" and ".get_voltage_sel".
> 	- update driver implement for coding styles.
> (4) Patch 4/8: Add document for MT8135 PMIC wrapper.
> (5) Patch 5/8: Update document for MT6397 MFD.
> (6) Patch 6/8: Update document for MT6397 regulators.
> (7) Patch 7/8: Add device tree for MT6397 MFD in mt8135.dtsi.
> (8) Patch 8/8: Update device tree for MT6397 regulators in mt8135.dtsi.
> 
> Initial version (v1):
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/302984.html
> 
> This driver is based on 3.18-rc1.
> 
> Flora Fu (8):
>   soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
>   mfd: MT6397: Add support for PMIC MT6397 MFD
>   regulator: MT6397: Add support for MT6397 regulator
>   dt-bindings:: Add document for MT8135 PMIC Wrapper
>   dt-bindings: Add document for MT6397 MFD
>   dt-bindings: Add document for MT6397 regulator
>   ARM: dts: mt8135: Add support for PMIC MT6397 MFD
>   ARM: dts: mt8135: Add support for MT6397 regulator
> 
>  Documentation/devicetree/bindings/mfd/mt6397.txt   |  73 ++
>  .../bindings/regulator/mt6397-regulator.txt        |  32 +
>  .../soc/mediatek/mediatek,mt8135-pwrap.txt         |  79 ++
>  arch/arm/boot/dts/mt8135.dtsi                      | 211 ++++++
>  drivers/mfd/Kconfig                                |  10 +
>  drivers/mfd/Makefile                               |   1 +
>  drivers/mfd/mt6397-core.c                          |  84 ++
>  drivers/regulator/Kconfig                          |   9 +
>  drivers/regulator/Makefile                         |   2 +-
>  drivers/regulator/mt6397-regulator.c               | 369 +++++++++
>  drivers/soc/Kconfig                                |   1 +
>  drivers/soc/Makefile                               |   1 +
>  drivers/soc/mediatek/Kconfig                       |  11 +
>  drivers/soc/mediatek/Makefile                      |   1 +
>  drivers/soc/mediatek/mt8135-pmic-wrap.c            | 844 +++++++++++++++++++++
>  drivers/soc/mediatek/mt8135-pmic-wrap.h            | 138 ++++
>  include/linux/mfd/mt6397/core.h                    |  23 +
>  include/linux/mfd/mt6397/registers.h               | 362 +++++++++
>  include/linux/regulator/mt6397-regulator.h         |  49 ++
>  include/linux/soc/mediatek/mtk-pmic-wrap.h         |  25 +
>  20 files changed, 2324 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mt6397.txt
>  create mode 100644 Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt
>  create mode 100644 drivers/mfd/mt6397-core.c
>  create mode 100644 drivers/regulator/mt6397-regulator.c
>  create mode 100644 drivers/soc/mediatek/Kconfig
>  create mode 100644 drivers/soc/mediatek/Makefile
>  create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.c
>  create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.h
>  create mode 100644 include/linux/mfd/mt6397/core.h
>  create mode 100644 include/linux/mfd/mt6397/registers.h
>  create mode 100644 include/linux/regulator/mt6397-regulator.h
>  create mode 100644 include/linux/soc/mediatek/mtk-pmic-wrap.h
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
