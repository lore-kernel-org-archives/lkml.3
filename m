Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3H2OkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:40:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46972 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3H2Oj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:39:57 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-6d-521f5d3af63d
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, mturquette@linaro.org
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, tomasz.figa@gmail.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 5/6] clk: samsung: Add clock driver for s5pc110/s5pv210
Date: Thu, 29 Aug 2013 16:39:50 +0200
Message-id: <4391436.nyMIuy3Tug@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377706384-3697-6-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-6-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t/xq7pWsfJBBks+G1hMWneAyWL+kXOs
	Fm96O1gsehdcZbM42/SG3WLT42usFgvblrBYXN41h82iZ8NWVosZ5/cxWdy+zGtxcZ28xek1
	p5gtll6/yGTxdMJFNosJ09eyWBxeATRt3cvpQNabdlaLVwfbWCzmtb9ktTg2Ywmjxapdfxgd
	xD3WzFvD6NHS3MPmseDzFXaP15MnMHr8XfWC2WPnrLvsHq9Wz2T1uHNtD5vH5iX1Hgff7WHy
	6NuyitHj8yY5j41zQwN4o7hsUlJzMstSi/TtErgynt3/z1hwbAJTxZLdK5gbGH/cZ+xi5OCQ
	EDCRmPSzvIuRE8gUk7hwbz0biC0ksJRR4u/GuC5GLiC7i0ni3sRzjCAJNgE1ic8Nj8CKRAR8
	JOZv6GQEKWIWWMEiseDCJLAiYQE/iX37T7GC2CwCqhJLd70Ca+AV0JTYtuksWJxfQF3i3ban
	TCBHiAq4SPT9zQQJcwK1Xji+nxVi8URGiQf7rjNB9ApK/Jh8jwXEZhaQB5o/lRXC1pJYv/M4
	0wRGwVlIymYhKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBI/7KDcfExq0OM
	AhyMSjy8D4Llg4RYE8uKK3MPMUpwMCuJ8L7lBArxpiRWVqUW5ccXleakFh9iZOLglGpg5Anj
	3MXXuWL5JJdlxjyPz9d/vSeZ4yv0wySgscq8X5Z5ofRWnsn/rXRsJ/xiTvxZnjpjm3Ri0adZ
	i8wv9/dYK0qayxwIM5n9syu732tFYN/9RfwrlBv/dx4X+ShxdBNLwbNNola7mN3map5ZOvmW
	+IJzjs2NslbHoo2MX144k52puXOF7jVxJZbijERDLeai4kQApPsU+dICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Wednesday 28 of August 2013 18:13:03 Mateusz Krawczuk wrote:
> This patch adds new, Common Clock Framework-based clock driver for
> Samsung S5PV210 SoCs. The driver is just added, without enabling it yet.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  .../bindings/clock/samsung,s5pv210-clock.txt       |  72 ++
>  drivers/clk/samsung/Makefile                       |   3 +
>  drivers/clk/samsung/clk-s5pv210.c                  | 732
> +++++++++++++++++++++ include/dt-bindings/clock/samsung,s5pv210-clock.h 
> | 221 +++++++ 4 files changed, 1028 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt create
> mode 100644 drivers/clk/samsung/clk-s5pv210.c
>  create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h
> 
> diff --git
> a/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt new
> file mode 100644
> index 0000000..753c8f9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> @@ -0,0 +1,72 @@
> +* Samsung S5PC110/S5PV210 Clock Controller
> +
> +The S5PV210 clock controller generates and supplies clock to various
> controllers +within the SoC. The clock binding described here is
> applicable to all SoCs in +the S5PC110/S5PV210 family.
> +
> +Required Properties:
> +
> +- compatible: should be one of the following.
> +  - "samsung,s5pv210-clock" - controller compatible with S5PC110/S5PV210
> SoC. +
> +- reg: physical base address of the controller and length of memory
> mapped +  region.
> +
> +- #clock-cells: should be 1.
> +
> +Each clock is assigned an identifier and client nodes can use this
> identifier +to specify the clock which they consume. Some of the clocks
> are available only +on a particular S5PC110/S5PV210 SoC and this is
> specified where applicable. +
> +All available clocks are defined as preprocessor macros in
> +dt-bindings/clock/samsung,s5pv210-clock.h header and can be used in
> device +tree sources.
> +
> +External clocks:
> +
> +There are several clocks that are generated outside the SoC. It is
> expected +that they are defined using standard clock bindings with
> following +clock-output-names:
> + - "xxti"    - xtal - required
> + - "xusbxti" - USB xtal - required,

Hmm, I'm not sure if all the boards must always provide both of them. 
Actually it looks like the correct statement here would be "At least one of 
the above clocks should be specified.".

> +
> +
> +Example: Clock controller node:
> +
> +	clock: clock-controller@7e00f000 {
> +		compatible = "samsung,s5pv210-clock";
> +		reg = <0x7e00f000 0x1000>;
> +		#clock-cells = <1>;
> +	};
> +
> +Example: Required external clocks:
> +
> +	fin_pll: clock-xxti {
> +		compatible = "fixed-clock";
> +		clock-output-names = "xxti";
> +		clock-frequency = <12000000>;
> +		#clock-cells = <0>;
> +	};
> +
> +	xusbxti: clock-xusbxti {
> +		compatible = "fixed-clock";
> +		clock-output-names = "xusbxti";
> +		clock-frequency = <48000000>;
> +		#clock-cells = <0>;
> +	};
> +
> +Example: UART controller node that consumes the clock generated by the
> clock +  controller (refer to the standard clock bindings for
> information about +  "clocks" and "clock-names" properties):
> +
> +		uart0: serial@7f005000 {
> +			compatible = "samsung,s5pv210-uart";
> +			reg = <0x7f005000 0x100>;
> +			interrupt-parent = <&vic1>;
> +			interrupts = <5>;
> +			clock-names = "uart", "clk_uart_baud2",
> +					"clk_uart_baud3";
> +			clocks = <&clock PCLK_UART0>, <&clocks PCLK_UART0>,
> +					<&clock SCLK_UART>;
> +			status = "disabled";
> +		};
> \ No newline at end of file
> diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
> index 8eb4799..e08c45e 100644
> --- a/drivers/clk/samsung/Makefile
> +++ b/drivers/clk/samsung/Makefile
> @@ -9,3 +9,6 @@ obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
>  obj-$(CONFIG_SOC_EXYNOS5440)	+= clk-exynos5440.o
>  obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
>  obj-$(CONFIG_ARCH_S3C64XX)	+= clk-s3c64xx.o
> +ifeq ($(CONFIG_COMMON_CLK), y)
> +obj-$(CONFIG_ARCH_S5PV210)	+= clk-s5pv210.o
> +endif
> \ No newline at end of file
> diff --git a/drivers/clk/samsung/clk-s5pv210.c
> b/drivers/clk/samsung/clk-s5pv210.c new file mode 100644
> index 0000000..1c5ea5c
> --- /dev/null
> +++ b/drivers/clk/samsung/clk-s5pv210.c
> @@ -0,0 +1,732 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Common Clock Framework support for all S5PC110/S5PV210 SoCs.
> +*/
> +
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <mach/regs-clock.h>

NAK.

Please don't use headers from mach/ or plat/ directories in drivers, as 
this will break future enablement of multiplatform support for S5PV210.

> +
> +#include "clk.h"
> +#include "clk-pll.h"
> +
> +#include <dt-bindings/clock/samsung,s5pv210-clock.h>
> +
> +/* S5PC110/S5PV210 clock controller register offsets */
> +#define APLL_LOCK		0x0000
> +#define MPLL_LOCK		0x0008
> +#define EPLL_LOCK		0x0010
> +#define VPLL_LOCK		0x0020
> +#define APLL_CON0		0x0100
> +#define APLL_CON1		0x0104
> +#define MPLL_CON		0x0108
> +#define EPLL_CON0		0x0110
> +#define EPLL_CON1		0x0114
> +#define VPLL_CON0		0x0120
> +#define CLK_SRC0		0x0200
> +#define CLK_SRC1		0x0204
> +#define CLK_SRC2		0x0208
> +#define CLK_SRC3		0x020c
> +#define CLK_SRC4		0x0210
> +#define CLK_SRC5		0x0214
> +#define CLK_SRC6		0x0218
> +#define CLK_SRC_MASK0		0x0280
> +#define CLK_SRC_MASK1		0x0284
> +#define CLK_DIV0		0x0300
> +#define CLK_DIV1		0x0304
> +#define CLK_DIV2		0x0308
> +#define CLK_DIV3		0x030c
> +#define CLK_DIV4		0x0310
> +#define CLK_DIV5		0x0314
> +#define CLK_DIV6		0x0318
> +#define CLK_DIV7		0x031c
> +#define CLK_GATE_SCLK		0x0444
> +#define CLK_GATE_IP0		0x0460
> +#define CLK_GATE_IP1		0x0464
> +#define CLK_GATE_IP2		0x0468
> +#define CLK_GATE_IP3		0x046c
> +#define CLK_GATE_IP4		0x0470
> +#define CLK_GATE_BLOCK		0x0480
> +#define CLK_GATE_IP5		0x0484
> +#define DAC_CONTROL		0xe810
> +
> +/* Helper macros to define clock arrays. */
> +#define FIXED_RATE_CLOCKS(name)	\
> +		static struct samsung_fixed_rate_clock name[]
> +#define MUX_CLOCKS(name)	\
> +		static struct samsung_mux_clock name[]
> +#define DIV_CLOCKS(name)	\
> +		static struct samsung_div_clock name[]
> +#define GATE_CLOCKS(name)	\
> +		static struct samsung_gate_clock name[]
> +
> +/* Helper macros for gate types present on S5PC110/S5PV210. */
> +#define GATE_BUS(_id, cname, pname, o, b) \
> +		GATE(_id, cname, pname, o, b, 0, 0)
> +#define GATE_SCLK(_id, cname, pname, o, b) \
> +		GATE(_id, cname, pname, o, b, CLK_SET_RATE_PARENT, 0)
> +#define GATE_ON(_id, cname, pname, o, b) \
> +		GATE(_id, cname, pname, o, b, CLK_IGNORE_UNUSED, 0)

These three macros above does not seem to be used anywhere in this driver. 
You can either remove them or change the driver to use them, as I can see 
several places they would be appropriate. See below.

> +enum s5pv210_plls {
> +	apll, mpll, epll, vpll,
> +};
> +
> +static unsigned long s5pv210_clk_regs[] __initdata = {
> +	CLK_SRC0,
> +	CLK_SRC1,
> +	CLK_SRC2,
> +	CLK_SRC3,
> +	CLK_SRC4,
> +	CLK_SRC5,
> +	CLK_SRC6,
> +	CLK_DIV0,
> +	CLK_DIV1,
> +	CLK_DIV2,
> +	CLK_DIV3,
> +	CLK_DIV4,
> +	CLK_DIV5,
> +	CLK_DIV6,
> +	CLK_DIV7,
> +	CLK_GATE_SCLK,
> +	CLK_GATE_IP0,
> +	CLK_GATE_IP1,
> +	CLK_GATE_IP2,
> +	CLK_GATE_IP3,
> +	CLK_GATE_IP4,
> +	CLK_GATE_IP5,
> +	CLK_SRC_MASK0,
> +	CLK_SRC_MASK1,
> +	APLL_CON0,
> +	MPLL_CON,
> +	EPLL_CON0,
> +	VPLL_CON0,
> +	APLL_LOCK,
> +	MPLL_LOCK,
> +	EPLL_LOCK,
> +	VPLL_LOCK,
> +};
> +
> +/* List of parent clocks common for all S5PC110 SoCs. */
> +PNAME(mout_apll_p) = {
> +	"fin_pll",
> +	"fout_apll"
> +};
> +
> +PNAME(mout_mpll_p) = {
> +	"fin_pll",
> +	"fout_mpll"
> +};
> +
> +PNAME(mout_epll_p) = {
> +	"fin_pll",
> +	"fout_epll"
> +};
> +
> +PNAME(mout_vpllsrc_p) = {
> +	"fin_pll",
> +	"sclk_hdmi27m"
> +};
> +
> +PNAME(mout_vpll_p) = {
> +	"fin_pll",
> +	"fout_vpll"
> +};
> +
> +PNAME(mout_group1_p) = {
> +	"dout_a2m",
> +	"mout_mpll",
> +	"mout_epll",
> +	"mout_vpll"
> +};
> +
> +PNAME(mout_group2_p) = {
> +	"xxti",
> +	"xusbxti",
> +	"sclk_hdmi27m",
> +	"sclk_usbphy0",
> +	"sclk_usbphy1",
> +	"sclk_hdmiphy",
> +	"mout_mpll",
> +	"mout_epll",
> +	"mout_vpll",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none"
> +};
> +
> +PNAME(mout_audio0_p) = {
> +	"xxti",
> +	"pcmcdclk0",
> +	"sclk_hdmi27m",
> +	"sclk_usbphy0",
> +	"sclk_usbphy1",
> +	"sclk_hdmiphy",
> +	"mout_mpll",
> +	"mout_epll",
> +	"mout_vpll",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none"
> +};
> +
> +PNAME(mout_audio1_p) = {
> +	"i2scdclk1",
> +	"pcmcdclk1",
> +	"sclk_hdmi27m",
> +	"sclk_usbphy0",
> +	"sclk_usbphy1",
> +	"sclk_hdmiphy",
> +	"mout_mpll",
> +	"mout_epll",
> +	"mout_vpll",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none"
> +};
> +
> +PNAME(mout_audio2_p) = {
> +	"i2scdclk2",
> +	"pcmcdclk2",
> +	"sclk_hdmi27m",
> +	"sclk_usbphy0",
> +	"sclk_usbphy1",
> +	"sclk_hdmiphy",
> +	"mout_mpll",
> +	"mout_epll",
> +	"mout_vpll",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none",
> +	"none"
> +};
> +
> +PNAME(mout_spdif_p) = {
> +	"dout_audio0",
> +	"dout_audio1",
> +	"dout_audio3",
> +	"none"
> +};
> +
> +PNAME(mout_group3_p) = {
> +	"mout_apll",
> +	"mout_mpll"
> +};
> +PNAME(mout_group4_p) = {
> +	"mout_mpll",
> +	"dout_a2m"
> +};
> +
> +PNAME(mout_flash_p) = {
> +	"dout_hclkd",
> +	"dout_hclkp"
> +};
> +
> +PNAME(mout_dac_p) = {
> +	"mout_vpll",
> +	"sclk_hdmiphy"
> +};
> +
> +PNAME(mout_hdmi_p) = {
> +	"sclk_hdmiphy",
> +	"dout_tblk"
> +
> +};
> +
> +PNAME(mout_mixer_p) = {
> +	"mout_dac",
> +	"mout_hdmi"
> +};
> +
> +/* register S5PC110/S5PV210 clocks */
> +MUX_CLOCKS(s5pv210_mux_clks) __initdata = {
> +	MUX(MOUT_FLASH, "mout_flash", mout_flash_p, CLK_SRC0, 28, 1),
> +	MUX(MOUT_PSYS, "mout_psys", mout_group4_p, CLK_SRC0, 24, 1),
> +	MUX(MOUT_DSYS, "mout_dsys", mout_group4_p, CLK_SRC0, 20, 1),
> +	MUX(MOUT_MSYS, "mout_msys", mout_group3_p, CLK_SRC0, 16, 1),
> +	MUX(MOUT_VPLL, "mout_vpll", mout_vpll_p, CLK_SRC0, 12, 1),
> +	MUX(MOUT_EPLL, "mout_epll", mout_epll_p, CLK_SRC0, 8, 1),
> +	MUX(MOUT_MPLL, "mout_mpll", mout_mpll_p, CLK_SRC0, 4, 1),
> +	MUX(MOUT_APLL, "mout_apll", mout_apll_p, CLK_SRC0, 0, 1),
> +
> +	MUX(MOUT_VPLLSRC, "mout_vpllsrc", mout_vpllsrc_p, CLK_SRC1, 28, 1),
> +	MUX(MOUT_CSIS, "mout_csis", mout_group2_p, CLK_SRC1, 24, 4),
> +	MUX(MOUT_FIMD, "mout_fimd", mout_group2_p, CLK_SRC1, 20, 4),
> +	MUX(MOUT_CAM1, "mout_cam1", mout_group2_p, CLK_SRC1, 16, 4),
> +	MUX(MOUT_CAM0, "mout_cam0", mout_group2_p, CLK_SRC1, 12, 4),
> +	MUX(MOUT_DAC, "mout_dac", mout_dac_p, CLK_SRC1, 8, 1),
> +	MUX(MOUT_MIXER, "mout_mixer", mout_mixer_p, CLK_SRC1, 4, 1),
> +
> +	MUX(MOUT_HDMI, "mout_hdmi", mout_hdmi_p, CLK_SRC1, 0, 1),
> +	MUX(MOUT_G2D, "mout_g2d", mout_group1_p, CLK_SRC2, 8, 2),
> +	MUX(MOUT_MFC, "mout_mfc", mout_group1_p, CLK_SRC2, 4, 2),
> +	MUX(MOUT_G3D, "mout_g3d", mout_group1_p, CLK_SRC2, 0, 2),
> +
> +	MUX(MOUT_FIMC2, "mout_fimc2", mout_group2_p, CLK_SRC3, 20, 4),
> +	MUX(MOUT_FIMC1, "mout_fimc1", mout_group2_p, CLK_SRC3, 16, 4),
> +	MUX(MOUT_FIMC0, "mout_fimc0", mout_group2_p, CLK_SRC3, 12, 4),
> +
> +	MUX(MOUT_UART3, "mout_uart3", mout_group2_p, CLK_SRC4, 28, 4),
> +	MUX(MOUT_UART2, "mout_uart2", mout_group2_p, CLK_SRC4, 24, 4),
> +	MUX(MOUT_UART1, "mout_uart1", mout_group2_p, CLK_SRC4, 20, 4),
> +	MUX(MOUT_UART0, "mout_uart0", mout_group2_p, CLK_SRC4, 16, 4),
> +	MUX(MOUT_MMC3, "mout_mmc3", mout_group2_p, CLK_SRC4, 12, 4),
> +	MUX(MOUT_MMC2, "mout_mmc2", mout_group2_p, CLK_SRC4, 8, 4),
> +	MUX(MOUT_MMC1, "mout_mmc1", mout_group2_p, CLK_SRC4, 4, 4),
> +	MUX(MOUT_MMC0, "mout_mmc0", mout_group2_p, CLK_SRC4, 0, 4),
> +
> +	MUX(MOUT_PWM, "mout_pwm", mout_group2_p, CLK_SRC5, 12, 4),
> +	MUX(MOUT_SPI1, "mout_spi1", mout_group2_p, CLK_SRC5, 4, 4),
> +	MUX(MOUT_SPI0, "mout_spi0", mout_group2_p, CLK_SRC5, 0, 4),
> +
> +	MUX(MOUT_DMC0, "mout_dmc0", mout_group1_p, CLK_SRC6, 24, 2),
> +	MUX(MOUT_PWI, "mout_pwi", mout_group2_p, CLK_SRC6, 20, 4),
> +	MUX(MOUT_HPM, "mout_hpm", mout_group3_p, CLK_SRC6, 16, 1),
> +	MUX(MOUT_SPDIF, "mout_spdif", mout_spdif_p, CLK_SRC6, 12, 2),
> +	MUX(MOUT_AUDIO2, "mout_audio2", mout_audio2_p, CLK_SRC6, 8, 4),
> +	MUX(MOUT_AUDIO1, "mout_audio1", mout_audio1_p, CLK_SRC6, 4, 4),
> +	MUX(MOUT_AUDIO0, "mout_audio0", mout_audio0_p, CLK_SRC6, 0, 4)
> +};
> +
> +/* Fixed rate clocks generated outside the soc */
> +FIXED_RATE_CLOCKS(s5pv210_fixed_rate_ext_clks) __initdata = {
> +	FRATE(0, "xxti", NULL, CLK_IS_ROOT, 0),
> +	FRATE(0, "xusbxti", NULL, CLK_IS_ROOT, 0),
> +};
> +
> +/* Fixed rate clocks generated inside the soc */
> +FIXED_RATE_CLOCKS(s5pv210_fixed_rate_clks) __initdata = {
> +	FRATE(0, "sclk_hdmi27m", NULL, CLK_IS_ROOT, 27000000),
> +	FRATE(0, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
> +	FRATE(0, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
> +	FRATE(0, "sclk_usbphy1", NULL, CLK_IS_ROOT, 48000000),

I think the four fixed rate clocks above should be assigned IDs too, to 
allow referencing them from device tree. The external fixed rate clocks are 
an exception to this, because they are specified in device tree using 
separate nodes.

> +};
> +
> +/* list of divider clocks supported in all S5PC110/S5PV210 soc's */
> +DIV_CLOCKS(s5pv210_div_clks) __initdata = {
> +	DIV(DOUT_PCLKP, "dout_pclkp", "dout_hclkp", CLK_DIV0, 28, 3),
> +	DIV(DOUT_HCLKP, "dout_hclkp", "mout_psys", CLK_DIV0, 24, 4),
> +	DIV(DOUT_PCLKD, "dout_pclkd", "dout_hclkd", CLK_DIV0, 20, 3),
> +	DIV(DOUT_HCLKD, "dout_hclkd", "mout_dsys", CLK_DIV0, 16, 4),
> +	DIV(DOUT_PCLKM, "dout_pclkm", "dout_hclkm", CLK_DIV0, 12, 3),
> +	DIV(DOUT_HCLKM, "dout_hclkm", "dout_apll", CLK_DIV0, 8, 3),
> +	DIV(DOUT_A2M, "dout_a2m", "mout_apll", CLK_DIV0, 4, 3),
> +	DIV(DOUT_APLL, "dout_apll", "mout_msys", CLK_DIV0, 0, 3),
> +
> +	DIV(DOUT_CSIS, "dout_csis", "mout_csis", CLK_DIV1, 28, 4),
> +	DIV(DOUT_FIMD, "dout_fimd", "mout_fimd", CLK_DIV1, 20, 4),
> +	DIV(DOUT_CAM1, "dout_cam1", "mout_cam1", CLK_DIV1, 16, 4),
> +	DIV(DOUT_CAM0, "dout_cam0", "mout_cam0", CLK_DIV1, 12, 4),
> +	DIV(DOUT_TBLK, "dout_tblk", "mout_vpll", CLK_DIV1, 0, 4),
> +
> +	DIV(DOUT_G2D, "dout_g2d", "mout_g2d", CLK_DIV2, 8, 4),
> +	DIV(DOUT_MFC, "dout_mfc", "mout_mfc", CLK_DIV2, 4, 4),
> +	DIV(DOUT_G3D, "dout_g3d", "mout_g3d", CLK_DIV2, 0, 4),
> +
> +	DIV(DOUT_FIMC2, "dout_fimc2", "mout_fimc2", CLK_DIV3, 20, 4),
> +	DIV(DOUT_FIMC1, "dout_fimc1", "mout_fimc1", CLK_DIV3, 16, 4),
> +	DIV(DOUT_FIMC0, "dout_fimc0", "mout_fimc0", CLK_DIV3, 12, 4),
> +
> +	DIV(DOUT_UART3, "dout_uart3", "mout_uart3", CLK_DIV4, 28, 4),
> +	DIV(DOUT_UART2, "dout_uart2", "mout_uart2", CLK_DIV4, 24, 4),
> +	DIV(DOUT_UART1, "dout_uart1", "mout_uart1", CLK_DIV4, 20, 4),
> +	DIV(DOUT_UART0, "dout_uart0", "mout_uart0", CLK_DIV4, 16, 4),
> +
> +	DIV(DOUT_MMC3, "dout_mmc3", "mout_mmc3", CLK_DIV4, 12, 4),
> +	DIV(DOUT_MMC2, "dout_mmc2", "mout_mmc2", CLK_DIV4, 8, 4),
> +	DIV(DOUT_MMC1, "dout_mmc1", "mout_mmc1", CLK_DIV4, 4, 4),
> +	DIV(DOUT_MMC0, "dout_mmc0", "mout_mmc0", CLK_DIV4, 0, 4),
> +
> +	DIV(DOUT_PWM, "dout_pwm", "mout_pwm", CLK_DIV5, 12, 4),
> +	DIV(DOUT_SPI1, "dout_spi1", "mout_spi1", CLK_DIV5, 4, 4),
> +	DIV(DOUT_SPI0, "dout_spi0", "mout_spi0", CLK_DIV5, 0, 4),
> +
> +	DIV(DOUT_DMC0, "dout_dmc0", "mout_dmc0", CLK_DIV6, 28, 4),
> +	DIV(DOUT_PWI, "dout_pwi", "mout_pwi", CLK_DIV6, 24, 4),
> +	DIV(DOUT_HPM, "dout_hpm", "dout_copy", CLK_DIV6, 20, 3),
> +	DIV(DOUT_COPY, "dout_copy", "mout_hpm", CLK_DIV6, 16, 3),
> +	DIV(DOUT_FLASH, "dout_flash", "mout_flash", CLK_DIV6, 12, 3),
> +	DIV(DOUT_AUDIO2, "dout_audio2", "mout_audio2", CLK_DIV6, 8, 4),
> +	DIV(DOUT_AUDIO1, "dout_audio1", "mout_audio1", CLK_DIV6, 4, 4),
> +	DIV(DOUT_AUDIO0, "dout_audio0", "mout_audio0", CLK_DIV6, 0, 4),
> +
> +	DIV(DOUT_DPM, "dout_dpm", "dout_pclkp", CLK_DIV7, 8, 7),
> +	DIV(DOUT_DVSEM, "dout_dvsem", "dout_pclkp", CLK_DIV7, 0, 7),
> +};
> +
> +/* list of gate clocks supported in all S5PC110/S5PV210 soc's */
> +struct samsung_gate_clock s5pv210_gate_clks[] __initdata = {
> +

nit: Stray blank line.

> +	GATE(CSIS, "clk_csis", "dout_hclkd", CLK_GATE_IP0, 31, 0, 0),
> +	GATE(ROTATOR, "rotator", "dout_hclkd", CLK_GATE_IP0, 29, 0, 0),
> +
> +	GATE(MFC, "mfc", "dout_hclkm", CLK_GATE_IP0, 16, 0, 0),
> +	GATE(G2D, "g2d", "dout_hclkd", CLK_GATE_IP0, 12, 0, 0),
> +	GATE(G3D, "g3d", "dout_hclkm",
> +			CLK_GATE_IP0, 8, CLK_SET_RATE_PARENT, 0),

This CLK_SET_RATE_PARENT flag doesn't look correctly. Why should it be able 
to set rate of dout_hclkm, which is shared by multiple peripherals?

> +	GATE(IMEM, "imem", "dout_hclkm", CLK_GATE_IP0, 5, 0, 0),
> +	GATE(PDMA1, "pdma1", "dout_hclkp", CLK_GATE_IP0, 4, 0, 0),
> +	GATE(PDMA0, "pdma0", "dout_hclkp", CLK_GATE_IP0, 3, 0, 0),
> +	GATE(MDMA, "mdma", "dout_hclkd", CLK_GATE_IP0, 2, 0, 0),
> +
> +	GATE(NFCON, "nfcon", "dout_hclkp", CLK_GATE_IP1, 28, 0, 0),
> +	GATE(SROMC, "sromc", "dout_hclkp", CLK_GATE_IP1, 26, 0, 0),
> +	GATE(CFCON, "cfcon", "dout_hclkp", CLK_GATE_IP1, 25, 0, 0),
> +	GATE(NANDXL, "nandxl", "dout_hclkp", CLK_GATE_IP1, 24, 0, 0),
> +	GATE(USB_HOST, "usb_host", "dout_hclkp", CLK_GATE_IP1, 17, 0, 0),
> +	GATE(USB_OTG, "usb_otg", "dout_hclkp", CLK_GATE_IP1, 16, 0, 0),
> +	GATE(HDMI, "hdmi", "dout_hclkd", CLK_GATE_IP1, 11, 0, 0),
> +	GATE(TVENC, "tvenc", "dout_hclkd", CLK_GATE_IP1, 10, 0, 0),
> +	GATE(MIXER, "mixer", "dout_hclkd", CLK_GATE_IP1, 9, 0, 0),
> +	GATE(VP, "vp", "dout_hclkd", CLK_GATE_IP1, 8, 0, 0),
> +	GATE(DSIM, "dsim", "dout_pclkd", CLK_GATE_IP1, 2, 0, 0),
> +	GATE(FIMD, "fimd", "dout_hclkd", CLK_GATE_IP1, 0, 0, 0),
> +
> +	GATE(TZIC3, "tzic3", "dout_hclkm", CLK_GATE_IP2, 31, 0, 0),
> +	GATE(TZIC2, "tzic2", "dout_hclkm", CLK_GATE_IP2, 30, 0, 0),
> +	GATE(TZIC1, "tzic1", "dout_hclkm", CLK_GATE_IP2, 29, 0, 0),
> +	GATE(TZIC0, "tzic0", "dout_hclkm", CLK_GATE_IP2, 28, 0, 0),
> +	GATE(TSI, "tsi", "dout_hclkd", CLK_GATE_IP2, 20, 0, 0),
> +	GATE(HSMMC3, "hsmmc3", "dout_hclkp", CLK_GATE_IP2, 19, 0, 0),
> +	GATE(HSMMC2, "hsmmc2", "dout_hclkp", CLK_GATE_IP2, 18, 0, 0),
> +	GATE(HSMMC1, "hsmmc1", "dout_hclkp", CLK_GATE_IP2, 17, 0, 0),
> +	GATE(HSMMC0, "hsmmc0", "dout_hclkp", CLK_GATE_IP2, 16, 0, 0),
> +	GATE(JTAG, "jtag", "dout_hclkp", CLK_GATE_IP2, 11, 0, 0),
> +	GATE(MODEMIF, "modemif", "dout_hclkp", CLK_GATE_IP2, 9, 0, 0),
> +	GATE(CORESIGHT, "coresight", "dout_pclkp", CLK_GATE_IP2, 8, 0, 0),
> +	GATE(SDM, "sdm", "dout_pclkm", CLK_GATE_IP2, 1, 0, 0),
> +	GATE(SECSS, "secss", "dout_hclkp", CLK_GATE_IP2, 0, 0, 0),
> +
> +	GATE(PCM2, "pcm2", "dout_pclkp", CLK_GATE_IP3, 30, 0, 0),
> +	GATE(PCM1, "pcm1", "dout_pclkp", CLK_GATE_IP3, 29, 0, 0),
> +	GATE(PCM0, "pcm0", "dout_pclkp", CLK_GATE_IP3, 28, 0, 0),
> +	GATE(TSADC, "tsadc", "dout_pclkp", CLK_GATE_IP3, 24, 0, 0),
> +	GATE(PWM, "pwm", "dout_pclkp", CLK_GATE_IP3, 23, 0, 0),
> +	GATE(WDT, "watchdog", "dout_pclkp", CLK_GATE_IP3, 22, 0, 0),
> +	GATE(KEYIF, "keyif", "dout_pclkp", CLK_GATE_IP3, 21, 0, 0),
> +	GATE(UART3, "uart3", "dout_pclkp", CLK_GATE_IP3, 20, 0, 0),
> +	GATE(UART2, "uart2", "dout_pclkp", CLK_GATE_IP3, 19, 0, 0),
> +	GATE(UART1, "uart1", "dout_pclkp", CLK_GATE_IP3, 18, 0, 0),
> +	GATE(UART0, "uart0", "dout_pclkp", CLK_GATE_IP3, 17, 0, 0),
> +	GATE(SYSTIMER, "systimer", "dout_pclkp", CLK_GATE_IP3, 16, 0, 0),
> +	GATE(RTC, "rtc", "dout_pclkp", CLK_GATE_IP3, 15, 0, 0),
> +	GATE(SPI1, "spi1", "dout_pclkp", CLK_GATE_IP3, 13, 0, 0),
> +	GATE(SPI0, "spi0", "dout_pclkp", CLK_GATE_IP3, 12, 0, 0),
> +	GATE(I2C_HDMI_PHY, "i2c_hdmi_phy", "dout_pclkd",
> +			CLK_GATE_IP3, 11, 0, 0),
> +	GATE(I2C_HDMI_CEC, "i2c_hdmi_cec", "dout_pclkd",
> +			CLK_GATE_IP3, 10, 0, 0),
> +	GATE(I2C2, "i2c2", "dout_pclkp", CLK_GATE_IP3, 9, 0, 0),
> +	GATE(I2C0, "i2c0", "dout_pclkp", CLK_GATE_IP3, 7, 0, 0),
> +	GATE(I2S1, "i2s1", "dout_pclkp", CLK_GATE_IP3, 6, 0, 0),
> +	GATE(I2S2, "i2s2", "dout_pclkp", CLK_GATE_IP3, 5, 0, 0),
> +	GATE(I2S0, "i2s0", "dout_pclkp", CLK_GATE_IP3, 4, 0, 0),
> +	GATE(AC97, "ac97", "dout_pclkp", CLK_GATE_IP3, 1, 0, 0),
> +	GATE(SPDIF, "spdif", "dout_pclkp", CLK_GATE_IP3, 0, 0, 0),
> +
> +	GATE(TZPC3, "tzpc.3", "dout_pclkd", CLK_GATE_IP4, 8, 0, 0),
> +	GATE(TZPC2, "tzpc.2", "dout_pclkd", CLK_GATE_IP4, 7, 0, 0),
> +	GATE(TZPC1, "tzpc.1", "dout_pclkp", CLK_GATE_IP4, 6, 0, 0),
> +	GATE(TZPC0, "tzpc.0", "dout_pclkm", CLK_GATE_IP4, 5, 0, 0),
> +	GATE(SECKEY, "seckey", "dout_pclkp", CLK_GATE_IP4, 3, 0, 0),
> +	GATE(IEM_APC, "iem_apc", "dout_pclkp", CLK_GATE_IP4, 2, 0, 0),
> +	GATE(IEM_IEC, "iem_iec", "dout_pclkp", CLK_GATE_IP4, 1, 0, 0),
> +	GATE(CHIPID, "chipid", "dout_pclkp", CLK_GATE_IP4, 0, 0, 0),
> +
> +	GATE(JPEG, "jpeg", "dout_hclkd", CLK_GATE_IP5, 29, 0, 0),
> +

You can use GATE_SCLK() macro for all the SCLK gates below.

> +	GATE(SCLK_SPDIF, "sclk_spdif", "mout_spdif", CLK_SRC_MASK0, 27,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_AUDIO2, "sclk_audio2", "dout_audio2", CLK_SRC_MASK0, 26,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_AUDIO1, "sclk_audio1", "dout_audio1", CLK_SRC_MASK0, 25,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_AUDIO0, "sclk_audio0", "dout_audio0", CLK_SRC_MASK0, 24,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_PWM, "sclk_pwm", "dout_pwm", CLK_SRC_MASK0, 19,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_SPI1, "sclk_spi1", "dout_spi1", CLK_SRC_MASK0, 17,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_SPI0, "sclk_spi0", "dout_spi0", CLK_SRC_MASK0, 16,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_UART3, "sclk_uart3", "dout_uart3", CLK_SRC_MASK0, 15,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_UART2, "sclk_uart2", "dout_uart2", CLK_SRC_MASK0, 14,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_UART1, "sclk_uart1", "dout_uart1", CLK_SRC_MASK0, 13,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_UART0, "sclk_uart0", "dout_uart0", CLK_SRC_MASK0, 12,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_MMC3, "sclk_mmc3", "dout_mmc3", CLK_SRC_MASK0, 11,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_MMC2, "sclk_mmc2", "dout_mmc2", CLK_SRC_MASK0, 10,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_MMC1, "sclk_mmc1", "dout_mmc1", CLK_SRC_MASK0, 9,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_MMC0, "sclk_mmc0", "dout_mmc0", CLK_SRC_MASK0, 8,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_CSIS, "sclk_csis", "dout_csis", CLK_SRC_MASK0, 6,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_FIMD, "sclk_fimd", "dout_fimd", CLK_SRC_MASK0, 5,
> +				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
> +	GATE(SCLK_CAM1, "sclk_cam1", "dout_cam1", CLK_SRC_MASK0, 4,
> +				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
> +	GATE(SCLK_CAM0, "sclk_cam0", "dout_cam0", CLK_SRC_MASK0, 3,
> +				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),

This CLK_IGNORE_UNUSED in the three clocks above does not look correct to 
me. It should be responsibility of the driver to claim the clock and 
control it. CLK_IGNORE_UNUSED should be rather used as last resort, for 
example if there is no driver yet, but the clock must be kept enabled.

> +	GATE(SCLK_DAC, "sclk_dac", "mout_dac", CLK_SRC_MASK0, 2, 0, 0),
> +	GATE(SCLK_MIXER, "sclk_mixer", "mout_mixer", CLK_SRC_MASK0, 1, 0, 0),
> +	GATE(SCLK_HDMI, "sclk_hdmi", "mout_hdmi", CLK_SRC_MASK0, 0, 0, 0),
> +
> +	GATE(SCLK_FIMC2, "sclk_fimc2", "dout_fimc2", CLK_SRC_MASK1, 4,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_FIMC1, "sclk_fimc1", "dout_fimc1", CLK_SRC_MASK1, 3,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(SCLK_FIMC0, "sclk_fimc0", "dout_fimc0", CLK_SRC_MASK1, 2,
> +				CLK_SET_RATE_PARENT, 0),
> +	GATE(FIMC2, "fimc2", "dout_hclkd", CLK_GATE_IP0, 26, 0, 0),
> +	GATE(FIMC1, "fimc1", "dout_hclkd", CLK_GATE_IP0, 25, 0, 0),
> +	GATE(FIMC0, "fimc0", "dout_hclkd", CLK_GATE_IP0, 24, 0, 0),
> +
> +	/*HACK dacphy isn`t real clock*/
> +	GATE(DACPHY, "dacphy", "dout_hclkd", DAC_CONTROL, 0, 0, 0),

You should be careful with this kind of hack, because the DACPHY index 
introduced here, when first used in DT, would become an ABI, support for 
which would have to be kept in future.

There are three possible ways to deal with this:
 1) remove this and thus break DAC support (does any existing board file 
use it?),
 2) implement this hack only for board files, without assigning a clock 
specifier index for this clock and thus making it unavailable for DT.
 3) implement this properly,

While option 3 would be the best one, I understand that it would require a 
significant amount of work, so other choices might better for now. Option 
1, if there are board files that have working DAC, will introduce a 
regression, so it isn't really good. I guess we could go with 2) for now.

> +};
> +
> +/* list of all parent clock list */
> +static struct samsung_clock_alias s5pv210_clock_aliases[] = {
> +	ALIAS(FIMC0, "s5pv210-fimc.0", "fimc"),
> +	ALIAS(FIMC1, "s5pv210-fimc.1", "fimc"),
> +	ALIAS(FIMC2, "s5pv210-fimc.2", "fimc"),
> +	ALIAS(MOUT_FIMC2, NULL, "mout_fimc2"),
> +	ALIAS(MOUT_FIMC1, NULL, "mout_fimc1"),
> +	ALIAS(MOUT_FIMC0, NULL, "mout_fimc0"),

These aliases should not have NULL here. I belive this is to allow looking 
these clocks up from board files, but this can be done using clk_get_sys() 
and passing appropriate device name to the function.

This would also make the X in mout_fimcX redundant, so the clocks could be 
specified as follows:

	ALIAS(MOUT_FIMC2, "s5pv210-fimc.0", "mout_fimc"),
	ALIAS(MOUT_FIMC1, "s5pv210-fimc.1", "mout_fimc"),
	ALIAS(MOUT_FIMC0, "s5pv210-fimc.2", "mout_fimc"),

> +	ALIAS(SCLK_FIMC0, "s5pv210-fimc.0", "sclk_fimc"),
> +	ALIAS(SCLK_FIMC1, "s5pv210-fimc.1", "sclk_fimc"),
> +	ALIAS(SCLK_FIMC2, "s5pv210-fimc.2", "sclk_fimc"),
> +
> +	ALIAS(MOUT_APLL, NULL, "mout_apll"),
> +	ALIAS(MOUT_MPLL, NULL, "mout_mpll"),
> +	ALIAS(MOUT_EPLL, NULL, "mout_epll"),
> +	ALIAS(MOUT_VPLL, NULL, "mout_vpll"),

Hmm. This is a bit problematic. I believe the reason for exporting this is 
exactly the same as for mout_fimcX. Am I right?

I believe there should be some way to do this kind of lookup from platform 
code, without the need to add fake aliases for the clocks. Mike, do you 
have any suggestsions?

> +	ALIAS(UART0, "s5pv210-uart.0", "uart"),
> +	ALIAS(UART1, "s5pv210-uart.1", "uart"),
> +	ALIAS(UART2, "s5pv210-uart.2", "uart"),
> +	ALIAS(UART3, "s5pv210-uart.3", "uart"),
> +	ALIAS(UART0, "s5pv210-uart.0", "clk_uart_baud0"),
> +	ALIAS(UART1, "s5pv210-uart.1", "clk_uart_baud0"),
> +	ALIAS(UART2, "s5pv210-uart.2", "clk_uart_baud0"),
> +	ALIAS(UART3, "s5pv210-uart.3", "clk_uart_baud0"),
> +	ALIAS(SCLK_UART0, "s5pv210-uart.0", "clk_uart_baud1"),
> +	ALIAS(SCLK_UART1, "s5pv210-uart.1", "clk_uart_baud1"),
> +	ALIAS(SCLK_UART2, "s5pv210-uart.2", "clk_uart_baud1"),
> +	ALIAS(SCLK_UART3, "s5pv210-uart.3", "clk_uart_baud1"),
> +	ALIAS(HSMMC0, "s3c-sdhci.0", "hsmmc"),
> +	ALIAS(HSMMC1, "s3c-sdhci.1", "hsmmc"),
> +	ALIAS(HSMMC2, "s3c-sdhci.2", "hsmmc"),
> +	ALIAS(HSMMC3, "s3c-sdhci.3", "hsmmc"),
> +	ALIAS(HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
> +	ALIAS(HSMMC1, "s3c-sdhci.1", "mmc_busclk.0"),
> +	ALIAS(HSMMC2, "s3c-sdhci.2", "mmc_busclk.0"),
> +	ALIAS(HSMMC3, "s3c-sdhci.3", "mmc_busclk.0"),
> +	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
> +	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
> +	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
> +	ALIAS(SCLK_MMC3, "s3c-sdhci.3", "mmc_busclk.2"),
> +	ALIAS(SPI0, "s5pv210-spi.0", "spi_busclk0"),
> +	ALIAS(SPI1, "s5pv210-spi.1", "spi_busclk0"),
> +	ALIAS(SCLK_SPI0, "s5pv210-spi.0", "spi_busclk1"),
> +	ALIAS(SCLK_SPI1, "s5pv210-spi.1", "spi_busclk1"),
> +	ALIAS(PDMA0, "dma-pl330.0", "apb_pclk"),
> +	ALIAS(PDMA1, "dma-pl330.1", "apb_pclk"),
> +	ALIAS(PWM, NULL, "timers"),

This one if fine, as the PWM clocksource driver does not have a struct 
device bound to it. (Generally speaking, this should be fixed by using 
clk_get_sys() in that driver, but this is a material for separate patches.)

> +
> +	ALIAS(JPEG, NULL, "jpeg"),

This one should have a device name as well.

> +	ALIAS(MFC, "s5p-mfc", "mfc"),
> +	ALIAS(TVENC, "s5p-sdo", "dac"),
> +	ALIAS(MIXER, "s5p-mixer", "mixer"),
> +	ALIAS(VP, "s5p-mixer", "vp"),
> +	ALIAS(HDMI, "s5p-hdmi", "hdmi"),
> +	ALIAS(SCLK_HDMI, "s5p-hdmi", "hdmiphy"),
> +
> +	ALIAS(SCLK_DAC, NULL, "sclk_dac"),

Ditto.

> +	ALIAS(DACPHY, "s5p-sdo", "dacphy"),
> +	ALIAS(USB_OTG, NULL, "usbotg"),
> +	ALIAS(USB_OTG, NULL, "otg"),
> +	ALIAS(USB_HOST, NULL, "usb-host"),
> +	ALIAS(USB_HOST, NULL, "usbhost"),

4 x Ditto.

Also why these clocks have two aliases? What are their users?

> +	ALIAS(FIMD, "s5pv210-fb", "lcd"),
> +	ALIAS(CFCON, NULL, "cfcon"),

Does anything even use this alias?

> +	ALIAS(SYSTIMER, NULL, "systimer"),

Does anything use this alias?

> +	ALIAS(WDT, NULL, "watchdog"),
> +	ALIAS(RTC, NULL, "rtc"),

Device names x 2.

> +	ALIAS(I2C0, "s3c2440-i2c.0", "i2c"),
> +	ALIAS(I2C_HDMI_CEC, "s3c2440-i2c.1", "i2c"),
> +	ALIAS(I2C2, "s3c2440-i2c.2", "i2c"),
> +	ALIAS(I2C_HDMI_PHY, "s3c2440-hdmiphy-i2c", "i2c"),
> +	ALIAS(TSADC, NULL, "adc"),

Ditto.

> +	ALIAS(KEYIF, "s5pv210-keypad", "keypad"),
> +	ALIAS(I2S0, "samsung-i2s.0", "iis"),
> +	ALIAS(I2S1, "samsung-i2s.1", "iis"),
> +	ALIAS(I2S2, "samsung-i2s.2", "iis"),
> +	ALIAS(SPDIF, NULL, "spdif"),
> +	ALIAS(ROTATOR, NULL, "rot"),

Device names x 2. (Although I'm not sure if something really uses the "rot" 
alias.)

> +	ALIAS(DOUT_APLL, NULL, "armclk"),

This one is needed by s5pv210-cpufreq indeed, but it also needs sclk_dmc0 
and hclk_msys, which don't seem to have aliases defined in this driver. 
However I also believe that s5pv210-cpufreq should be fixed to use 
clk_get_sys(), with some made up device name, e.g. "s5pv210-cpufreq".

> +	ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
> +	ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
> +	ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
> +
> +	ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
> +	ALIAS(SCLK_CAM0, NULL, "sclk_cam0"),
> +	ALIAS(SCLK_CAM1, NULL, "sclk_cam1"),

Device names. x2

> +	ALIAS(G2D, "s5p-g2d", "fimg2d"),
> +	ALIAS(DOUT_G2D, "s5p-g2d", "sclk_fimg2d"),
> +	ALIAS(CSIS, "s5p-mipi-csis", "csis"),
> +	ALIAS(SCLK_CSIS, "s5p-mipi-csis", "sclk_csis"),
> +	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk0"),
> +	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk1"),
> +	ALIAS(SCLK_FIMD, NULL, "sclk_fimd"),
> +	ALIAS(MOUT_CAM0, NULL, "mout_cam0"),
> +	ALIAS(MOUT_CAM1, NULL, "mout_cam1"),
> +
> +	ALIAS(MOUT_CSIS, NULL, "mout_csis"),
> +	ALIAS(MOUT_VPLL, NULL, "sclk_vpll"),
> +	ALIAS(SCLK_MIXER, NULL, "sclk_mixer"),
> +	ALIAS(SCLK_HDMI, NULL, "sclk_hdmi"),

Device names. x7

> +};
> +
> +static unsigned long __init s5pv210_get_xom(void)
> +{
> +	unsigned long xom = 1;
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "samsung,s5pv210-chipid");
> +	if (np) {

Instead of moving the successful path under the if, what about calling 
panic() if the node couldn't be found?

> +		void __iomem *chipid_base = of_iomap(np, 0);
> +
> +		if (!chipid_base)
> +			panic("%s: failed to map chipid\n", __func__);
> +		else {

Coding style: Braces should be used consistently, i.e. if used for "if" 
clause, then should be used for "else" clause as well and vice versa.

Also you don't even need this else, because panic() does not return.

> +			xom = readl(chipid_base + 8);
> +			iounmap(chipid_base);
> +		}
> +	}
> +
> +	return xom;
> +}
> +
> +static void __init s5pv210_clk_register_finpll(unsigned long xom)
> +{
> +	struct samsung_fixed_rate_clock fclk;
> +	struct clk *clk;
> +	unsigned long finpll_f = 24000000;
> +	char *parent_name;
> +
> +	parent_name = xom & 1 ? "xusbxti" : "xxti";
> +	clk = clk_get(NULL, parent_name);
> +	if (IS_ERR(clk))
> +		pr_err("%s: failed to lookup parent clock %s, assuming fin_pll clock
> frequency is 24MHz\n", +						__func__, parent_name);
> +	else
> +		finpll_f = clk_get_rate(clk);

Hmm, I wonder if it's the right assumption. Maybe it would be better to 
simply fail here? I'd like to hear other opinions on this.

> +
> +	fclk.id = FIN_PLL;
> +	fclk.name = "fin_pll";
> +	fclk.parent_name = NULL;
> +	fclk.flags = CLK_IS_ROOT;
> +	fclk.fixed_rate = finpll_f;
> +	samsung_clk_register_fixed_rate(&fclk, 1);

Also if you could register here a fixed factor clock with 1:1 factor that 
would just have the right parent clock set, instead of fixed rate clock, 
the clock tree would be closer to reality.

> +}
> +
> +static void __init s5pv210_clk_register_fixed_ext(unsigned long xxti_f,
> +						unsigned long xusbxti_f)
> +{
> +	s5pv210_fixed_rate_ext_clks[0].fixed_rate = xxti_f;
> +	s5pv210_fixed_rate_ext_clks[1].fixed_rate = xusbxti_f;
> +	samsung_clk_register_fixed_rate(s5pv210_fixed_rate_ext_clks,
> +				ARRAY_SIZE(s5pv210_fixed_rate_ext_clks));
> +}
> +
> +static struct samsung_pll_clock s5pv210_pll_clks[] __initdata = {
> +	[apll] = PLL(pll_4508, FOUT_APLL, "fout_apll", "fin_pll",
> +						APLL_LOCK, APLL_CON0, NULL),
> +	[mpll] = PLL(pll_4502, FOUT_MPLL, "fout_mpll", "fin_pll",
> +						MPLL_LOCK, MPLL_CON, NULL),
> +	[epll] = PLL(pll_4600, FOUT_EPLL, "fout_epll", "fin_pll",
> +						EPLL_LOCK, EPLL_CON0, NULL),
> +	[vpll] = PLL(pll_4502, FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
> +						VPLL_LOCK, VPLL_CON0, NULL),
> +};
> +
> +void __init s5pv210_clk_init(struct device_node *np, unsigned long
> xxti_f, +			unsigned long xusbxti_f, void __iomem *reg_base)
> +{
> +	unsigned long xom = s5pv210_get_xom();

What about XOM value when booting without device tree? Shouldn't you have 
some way to read XOM value in platform code and pass it here, like it was 
done in Exynos4 clock driver before we dropped non-DT support for Exynos?

Otherwise looks good.

Best regards,
Tomasz

