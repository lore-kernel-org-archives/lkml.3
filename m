Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3IZBtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:49:36 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51025 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IZBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:49:34 -0400
Date: Thu, 26 Sep 2013 10:49:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 2/4] ARM: shmobile: r8a7790: add I2C support in Device
 Tree mode
Message-ID: <20130926014927.GA18396@verge.net.au>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
 <1378742636-11215-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378742636-11215-3-git-send-email-g.liakhovetski@gmx.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:03:54PM +0200, Guennadi Liakhovetski wrote:
> This patch adds clocks and clock lookup entries for the four I2C
> controllers on r8a7790 and respective Device Tree nodes.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7790.dtsi         |   36 ++++++++++++++++++++++++++++++++
>  arch/arm/mach-shmobile/clock-r8a7790.c |   10 ++++++++
>  2 files changed, 46 insertions(+), 0 deletions(-)

Hi Guennadi,

please split this patch into two patches.
1. A SoC patch which updates clock-r8a7790.c
2. A DT patch which updates r8a7790.dtsi

Thanks

> 
> diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> index 885f9f4..a5021112 100644
> --- a/arch/arm/boot/dts/r8a7790.dtsi
> +++ b/arch/arm/boot/dts/r8a7790.dtsi
> @@ -127,6 +127,42 @@
>  		interrupts = <0 0 4>, <0 1 4>, <0 2 4>,	<0 3 4>;
>  	};
>  
> +	i2c0: i2c@e6508000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "renesas,i2c-rcar-h2";
> +		reg = <0 0xe6508000 0 0x40>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 287 0x4>;
> +	};
> +
> +	i2c1: i2c@e6518000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "renesas,i2c-rcar-h2";
> +		reg = <0 0xe6518000 0 0x40>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 288 0x4>;
> +	};
> +
> +	i2c2: i2c@e6530000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "renesas,i2c-rcar-h2";
> +		reg = <0 0xe6530000 0 0x40>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 286 0x4>;
> +	};
> +
> +	i2c3: i2c@e6540000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "renesas,i2c-rcar-h2";
> +		reg = <0 0xe6540000 0 0x40>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 290 0x4>;
> +	};
> +
>  	mmcif0: mmcif@ee200000 {
>  		compatible = "renesas,sh-mmcif";
>  		reg = <0 0xee200000 0 0x80>;
> diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
> index fc36d3d..8e5e90b 100644
> --- a/arch/arm/mach-shmobile/clock-r8a7790.c
> +++ b/arch/arm/mach-shmobile/clock-r8a7790.c
> @@ -52,6 +52,7 @@
>  #define SMSTPCR5 0xe6150144
>  #define SMSTPCR7 0xe615014c
>  #define SMSTPCR8 0xe6150990
> +#define SMSTPCR9 0xe6150994
>  
>  #define SDCKCR		0xE6150074
>  #define SD2CKCR		0xE6150078
> @@ -181,6 +182,7 @@ static struct clk div6_clks[DIV6_NR] = {
>  
>  /* MSTP */
>  enum {
> +	MSTP931, MSTP930, MSTP929, MSTP928,
>  	MSTP813,
>  	MSTP721, MSTP720,
>  	MSTP717, MSTP716,
> @@ -192,6 +194,10 @@ enum {
>  };
>  
>  static struct clk mstp_clks[MSTP_NR] = {
> +	[MSTP931] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 31, 0), /* I2C0 */
> +	[MSTP930] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 30, 0), /* I2C1 */
> +	[MSTP929] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 29, 0), /* I2C2 */
> +	[MSTP928] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 28, 0), /* I2C3 */
>  	[MSTP813] = SH_CLK_MSTP32(&p_clk, SMSTPCR8, 13, 0), /* Ether */
>  	[MSTP721] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 21, 0), /* SCIF0 */
>  	[MSTP720] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 20, 0), /* SCIF1 */
> @@ -261,6 +267,10 @@ static struct clk_lookup lookups[] = {
>  	CLKDEV_DEV_ID("sh-sci.7", &mstp_clks[MSTP720]),
>  	CLKDEV_DEV_ID("sh-sci.8", &mstp_clks[MSTP717]),
>  	CLKDEV_DEV_ID("sh-sci.9", &mstp_clks[MSTP716]),
> +	CLKDEV_DEV_ID("e6508000.i2c", &mstp_clks[MSTP931]),
> +	CLKDEV_DEV_ID("e6518000.i2c", &mstp_clks[MSTP930]),
> +	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
> +	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
>  	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
>  	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
>  	CLKDEV_DEV_ID("ee200000.mmcif", &mstp_clks[MSTP315]),
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
