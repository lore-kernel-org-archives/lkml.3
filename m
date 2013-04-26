Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab3DZHtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:49:11 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:56821 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758837Ab3DZHtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:49:10 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Subject: RE: linux-next: manual merge of the arm-soc tree with the spi-mb
 tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the spi-mb
 tree
Thread-Index: AQHOQkyzY6YjkCkP2EirMRgj8TJ/XJjoIE+A
Date: Fri, 26 Apr 2013 07:48:51 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364154234E9D@penmbx02>
References: <20130426170649.d21c2d7a74e56d836ff6f04f@canb.auug.org.au>
In-Reply-To: <20130426170649.d21c2d7a74e56d836ff6f04f@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3Q7nHLv001439

Hi,

It is OK for spi

Thanks

Best Regards,
Wenyou Yang

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: 2013Äê4ÔÂ26ÈÕ 15:07
> To: Olof Johansson; Arnd Bergmann; linux-arm-kernel@lists.infradead.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Yang, Wenyou;
> Richard Genoud; Mark Brown; Ferre, Nicolas
> Subject: linux-next: manual merge of the arm-soc tree with the spi-mb tree
> 
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/at91sam9x5.dtsi between commits d50f88a0c304 ("ARM:
> dts: add spi nodes for atmel SoC") and a68b728f7a21 ("ARM: dts: add pinctrl
> property for spi node for atmel SoC") from the spi-mb tree and commits
> e9a72ee81d58 ("ARM: at91: dt: at91sam9x5: add i2c pinctrl"),
> 463c9c7bf1f3 ("ARM: at91: dt: at91sam9x5: add i2c-gpio pinctrl") and
> b909c6c94462 ("ARM: at91/at91sam9x5: add RTC node") from the arm-soc
> tree.
> 
> I fixed it up (hopefully - see below) and can carry the fix as necessary (no action
> is required).
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/boot/dts/at91sam9x5.dtsi index 347b438,284bf24..0000000
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@@ -343,23 -343,53 +343,70 @@@
>   					};
>   				};
> 
>  +				spi0 {
>  +					pinctrl_spi0: spi0-0 {
>  +						atmel,pins =
>  +							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO
> pin */
>  +							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI
> pin */
>  +							 0 13 0x1 0x0>;	/* PA13 periph A
> SPI0_SPCK pin */
>  +					};
>  +				};
>  +
>  +				spi1 {
>  +					pinctrl_spi1: spi1-0 {
>  +						atmel,pins =
>  +							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO
> pin */
>  +							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI
> pin */
>  +							 0 23 0x2 0x0>;	/* PA23 periph B
> SPI1_SPCK pin */
>  +					};
>  +				};
> + 				i2c0 {
> + 					pinctrl_i2c0: i2c0-0 {
> + 						atmel,pins =
> + 							<0 30 0x1 0x0	/* PA30 periph A I2C0 data */
> + 							 0 31 0x1 0x0>;	/* PA31 periph A I2C0
> clock */
> + 					};
> + 				};
> +
> + 				i2c1 {
> + 					pinctrl_i2c1: i2c1-0 {
> + 						atmel,pins =
> + 							<2 0 0x3 0x0	/* PC0 periph C I2C1 data */
> + 							 2 1 0x3 0x0>;	/* PC1 periph C I2C1 clock */
> + 					};
> + 				};
> +
> + 				i2c2 {
> + 					pinctrl_i2c2: i2c2-0 {
> + 						atmel,pins =
> + 							<1 4 0x2 0x0	/* PB4 periph B I2C2 data */
> + 							 1 5 0x2 0x0>;	/* PB5 periph B I2C2 clock */
> + 					};
> + 				};
> +
> + 				i2c_gpio0 {
> + 					pinctrl_i2c_gpio0: i2c_gpio0-0 {
> + 						atmel,pins =
> + 							<0 30 0x0 0x2	/* PA30 gpio multidrive I2C0
> data */
> + 							 0 31 0x0 0x2>;	/* PA31 gpio multidrive
> I2C0 clock */
> + 					};
> + 				};
> +
> + 				i2c_gpio1 {
> + 					pinctrl_i2c_gpio1: i2c_gpio1-0 {
> + 						atmel,pins =
> + 							<2 0 0x0 0x2	/* PC0 gpio multidrive I2C1
> data */
> + 							 2 1 0x0 0x2>;	/* PC1 gpio multidrive I2C1
> clock */
> + 					};
> + 				};
> +
> + 				i2c_gpio2 {
> + 					pinctrl_i2c_gpio2: i2c_gpio2-0 {
> + 						atmel,pins =
> + 							<1 4 0x0 0x2	/* PB4 gpio multidrive I2C2
> data */
> + 							 1 5 0x0 0x2>;	/* PB5 gpio multidrive I2C2
> clock */
> + 					};
> + 				};
> 
>   				pioA: gpio@fffff400 {
>   					compatible = "atmel,at91sam9x5-gpio",
> "atmel,at91rm9200-gpio"; @@@ -548,27 -587,12 +604,33 @@@
>   				};
>   			};
> 
>  +			spi0: spi@f0000000 {
>  +				#address-cells = <1>;
>  +				#size-cells = <0>;
>  +				compatible = "atmel,at91rm9200-spi";
>  +				reg = <0xf0000000 0x100>;
>  +				interrupts = <13 4 3>;
>  +				pinctrl-names = "default";
>  +				pinctrl-0 = <&pinctrl_spi0>;
>  +				status = "disabled";
>  +			};
>  +
>  +			spi1: spi@f0004000 {
>  +				#address-cells = <1>;
>  +				#size-cells = <0>;
>  +				compatible = "atmel,at91rm9200-spi";
>  +				reg = <0xf0004000 0x100>;
>  +				interrupts = <14 4 3>;
>  +				pinctrl-names = "default";
>  +				pinctrl-0 = <&pinctrl_spi1>;
>  +				status = "disabled";
>  +			};
> + 			rtc@fffffeb0 {
> + 				compatible = "atmel,at91rm9200-rtc";
> + 				reg = <0xfffffeb0 0x40>;
> + 				interrupts = <1 4 7>;
> + 				status = "disabled";
> + 			};
>   		};
> 
>   		nand0: nand@40000000 {
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
