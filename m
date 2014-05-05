Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaEEIfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:35:43 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:25906
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754854AbaEEIfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:35:41 -0400
Date: Mon, 5 May 2014 10:35:04 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Add platform support for LSI AXM55xx
Message-ID: <20140505083407.GA3398@swsaberg01>
References: <cover.1398335771.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1398335771.git.anders.berg@lsi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: CO2PR06CA052.namprd06.prod.outlook.com (10.141.242.52) To
 BLUPR07MB369.namprd07.prod.outlook.com (10.141.26.142)
X-Forefront-PRVS: 0202D21D2F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(24454002)(97756001)(83322001)(19580395003)(76482001)(83072002)(81542001)(33656001)(50466002)(42186004)(83506001)(101416001)(99396002)(4396001)(64706001)(87976001)(77982001)(74662001)(31966008)(74502001)(80022001)(66066001)(46406003)(92566001)(50986999)(54356999)(92726001)(76176999)(86362001)(23726002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB369;H:swsaberg01;FPR:;MLV:sfv;PTR:InfoNoRecords;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anders.Berg@lsi.com; 
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anrd,

Any comments on this updated series?

/Anders

On Thu, Apr 24, 2014 at 12:44:03PM +0200, Anders Berg wrote:
> Hi,
> 
> Verion 2 of this series to introduces basic platform support for the LSI
> AXM5516 SoC. When this is in shape, could it be merged into the arm-soc tree?
> 
> Changes:
> 
> v2:
>     * Rebased to arm-soc/for-next
>     * Removed redundant HAVE_SMP and ARCH_WANT_OPTIONAL_GPIOLIB from Kconfig
>     * Use CPU_METHOD_OF_DECLARE to register smp_operations
>     * Rework smp operations to avoid holding pen and custom headsmp.S
>     * Clean up board file
>     * Corrected clock properties for arm,sp804 dts node.
>     * Changed machine compatible strings to include full model number.
>     * Break out clk-axxia driver as separate patch
>     * Removed Makefile.boot
> 
> Anders Berg (6):
>   ARM: Add platform support for LSI AXM55xx SoC
>   clk: Add clock driver for AXM55xx SoC
>   ARM: dts: Device tree for AXM55xx.
>   ARM: axxia: Adding defconfig for AXM55xx
>   power: reset: Add Axxia system reset driver
>   ARM: dts: axxia: Add reset controller
> 
>  Documentation/devicetree/bindings/arm/axxia.txt    |  12 +
>  .../devicetree/bindings/clock/clk-axxia.txt        |  88 ++++++
>  .../bindings/power_supply/axxia-reset.txt          |  20 ++
>  arch/arm/Kconfig                                   |   2 +
>  arch/arm/Makefile                                  |   2 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/axm5516-amarillo.dts             |  51 ++++
>  arch/arm/boot/dts/axm5516-cpus.dtsi                | 204 ++++++++++++++
>  arch/arm/boot/dts/axm55xx.dtsi                     | 311 +++++++++++++++++++++
>  arch/arm/configs/axm55xx_defconfig                 | 248 ++++++++++++++++
>  arch/arm/mach-axxia/Kconfig                        |  16 ++
>  arch/arm/mach-axxia/Makefile                       |   2 +
>  arch/arm/mach-axxia/axxia.c                        |  28 ++
>  arch/arm/mach-axxia/platsmp.c                      |  89 ++++++
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-axxia.c                            | 281 +++++++++++++++++++
>  drivers/power/reset/Kconfig                        |   8 +
>  drivers/power/reset/Makefile                       |   1 +
>  drivers/power/reset/axxia-reset.c                  |  97 +++++++
>  19 files changed, 1462 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/clk-axxia.txt
>  create mode 100644 Documentation/devicetree/bindings/power_supply/axxia-reset.txt
>  create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
>  create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
>  create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
>  create mode 100644 arch/arm/configs/axm55xx_defconfig
>  create mode 100644 arch/arm/mach-axxia/Kconfig
>  create mode 100644 arch/arm/mach-axxia/Makefile
>  create mode 100644 arch/arm/mach-axxia/axxia.c
>  create mode 100644 arch/arm/mach-axxia/platsmp.c
>  create mode 100644 drivers/clk/clk-axxia.c
>  create mode 100644 drivers/power/reset/axxia-reset.c
> 
> -- 
> 1.8.3.2
> 
