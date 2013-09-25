Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3IYWKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:10:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3IYWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:10:37 -0400
Date: Thu, 26 Sep 2013 00:10:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/4] ARM: shmobile: r8a7790: add I2C support in Device
 Tree mode
In-Reply-To: <1681594.NCMRR5Vty1@avalon>
Message-ID: <Pine.LNX.4.64.1309260004450.7439@axis700.grange>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
 <1378742636-11215-3-git-send-email-g.liakhovetski@gmx.de> <1681594.NCMRR5Vty1@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wG56VnPOcsBmdIxzxjxP6/nyGL0MDy8LjYqwcmn5jc8
 hRlWLV3jF26mv+rXEe0nbXZ4uD0He7DQAkMbXluHHGQH2VL7hm
 Bvdv62JsiKPXioj7W8VNWlfnc0XYeZxlN0irumsjdi8bqHPYhH
 0M6wpENZ9sCff193CiaZp5LG5hliA59T5Fbtk/+2aimhjMllxU
 eDd0xBOALOsmKHMUw/GmJZ5M+lvToFdSN1mwNYhSXAeDSzxJPp
 /545HuW7uIlYKoVce8Z0mC/kP5h1FtVLNncZguVzNYl/NAOVK0
 H3s/m4xmq85pJmJ95azgKSPObpE2ESx5XWK+v9PsGCnD1siv8S
 EqoX5t7wfa9Vd53yr0O5o/fcsf4AYytc1La6cxGJUaKtGdfZQ3
 DQ5RMn28u7UCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent

On Wed, 25 Sep 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Monday 09 September 2013 18:03:54 Guennadi Liakhovetski wrote:
> > This patch adds clocks and clock lookup entries for the four I2C
> > controllers on r8a7790 and respective Device Tree nodes.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> >  arch/arm/boot/dts/r8a7790.dtsi         |   36 +++++++++++++++++++++++++++++
> >  arch/arm/mach-shmobile/clock-r8a7790.c |   10 ++++++++
> >  2 files changed, 46 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> > index 885f9f4..a5021112 100644
> > --- a/arch/arm/boot/dts/r8a7790.dtsi
> > +++ b/arch/arm/boot/dts/r8a7790.dtsi
> > @@ -127,6 +127,42 @@
> >  		interrupts = <0 0 4>, <0 1 4>, <0 2 4>,	<0 3 4>;
> >  	};
> > 
> > +	i2c0: i2c@e6508000 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "renesas,i2c-rcar-h2";
> > +		reg = <0 0xe6508000 0 0x40>;
> > +		interrupt-parent = <&gic>;
> > +		interrupts = <0 287 0x4>;
> 
> Shouldn't you add state = "disabled" to all I2C controllers in order not to 
> enable the unused controllers by default ?

It would be logical, yes, and I seem to remember having discussed this 
earlier with someone (with Magnus, IIRC), and the outcome was, that all 
Renesas .dtsi files so far define all I2C directly in enabled mode and 
that it's intentional, so, I just followed this pattern here. You can 
indeed check in other .dtsi files - all seem to do exactly the same.

Thanks
Guennadi

> 
> > +	};
> > +
> > +	i2c1: i2c@e6518000 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "renesas,i2c-rcar-h2";
> > +		reg = <0 0xe6518000 0 0x40>;
> > +		interrupt-parent = <&gic>;
> > +		interrupts = <0 288 0x4>;
> > +	};
> > +
> > +	i2c2: i2c@e6530000 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "renesas,i2c-rcar-h2";
> > +		reg = <0 0xe6530000 0 0x40>;
> > +		interrupt-parent = <&gic>;
> > +		interrupts = <0 286 0x4>;
> > +	};
> > +
> > +	i2c3: i2c@e6540000 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "renesas,i2c-rcar-h2";
> > +		reg = <0 0xe6540000 0 0x40>;
> > +		interrupt-parent = <&gic>;
> > +		interrupts = <0 290 0x4>;
> > +	};
> > +
> >  	mmcif0: mmcif@ee200000 {
> >  		compatible = "renesas,sh-mmcif";
> >  		reg = <0 0xee200000 0 0x80>;
> > diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c
> > b/arch/arm/mach-shmobile/clock-r8a7790.c index fc36d3d..8e5e90b 100644
> > --- a/arch/arm/mach-shmobile/clock-r8a7790.c
> > +++ b/arch/arm/mach-shmobile/clock-r8a7790.c
> > @@ -52,6 +52,7 @@
> >  #define SMSTPCR5 0xe6150144
> >  #define SMSTPCR7 0xe615014c
> >  #define SMSTPCR8 0xe6150990
> > +#define SMSTPCR9 0xe6150994
> > 
> >  #define SDCKCR		0xE6150074
> >  #define SD2CKCR		0xE6150078
> > @@ -181,6 +182,7 @@ static struct clk div6_clks[DIV6_NR] = {
> > 
> >  /* MSTP */
> >  enum {
> > +	MSTP931, MSTP930, MSTP929, MSTP928,
> >  	MSTP813,
> >  	MSTP721, MSTP720,
> >  	MSTP717, MSTP716,
> > @@ -192,6 +194,10 @@ enum {
> >  };
> > 
> >  static struct clk mstp_clks[MSTP_NR] = {
> > +	[MSTP931] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 31, 0), /* I2C0 */
> > +	[MSTP930] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 30, 0), /* I2C1 */
> > +	[MSTP929] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 29, 0), /* I2C2 */
> > +	[MSTP928] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 28, 0), /* I2C3 */
> >  	[MSTP813] = SH_CLK_MSTP32(&p_clk, SMSTPCR8, 13, 0), /* Ether */
> >  	[MSTP721] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 21, 0), /* SCIF0 */
> >  	[MSTP720] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 20, 0), /* SCIF1 */
> > @@ -261,6 +267,10 @@ static struct clk_lookup lookups[] = {
> >  	CLKDEV_DEV_ID("sh-sci.7", &mstp_clks[MSTP720]),
> >  	CLKDEV_DEV_ID("sh-sci.8", &mstp_clks[MSTP717]),
> >  	CLKDEV_DEV_ID("sh-sci.9", &mstp_clks[MSTP716]),
> > +	CLKDEV_DEV_ID("e6508000.i2c", &mstp_clks[MSTP931]),
> > +	CLKDEV_DEV_ID("e6518000.i2c", &mstp_clks[MSTP930]),
> > +	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
> > +	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
> >  	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
> >  	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
> >  	CLKDEV_DEV_ID("ee200000.mmcif", &mstp_clks[MSTP315]),
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
