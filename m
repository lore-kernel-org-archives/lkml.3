Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaHaGra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 02:47:30 -0400
Received: from fallback5.mail.ru ([94.100.181.253]:47802 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHaGr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 02:47:26 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGhpbGlwcGUgUmV5bmVz?= <tremyfr@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gYXBmMjdkZXY6IGFkZCBtYXgxMDI3IGluIHRoZSBk?=
 =?UTF-8?B?dHM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Sun, 31 Aug 2014 10:46:54 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1409467614.685837886@f430.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1409436057-29729-1-git-send-email-tremyfr@gmail.com>
References: <1409436057-29729-1-git-send-email-tremyfr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7V6lqEJ031974


Sun, 31 Aug 2014 00:00:57 +0200 Ğ¾Ñ‚ Philippe Reynes <tremyfr@gmail.com>:
> 
> Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
> ---
>  arch/arm/boot/dts/imx27-apf27dev.dts |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> Changelog:
> v2: (thanks Alexander Shiyan for the feedback)
> - spi mode 0 is the default so no need to explicitly define it
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
> index b982309..f2bab73 100644
> --- a/arch/arm/boot/dts/imx27-apf27dev.dts
> +++ b/arch/arm/boot/dts/imx27-apf27dev.dts
> @@ -82,6 +82,16 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_cspi1 &pinctrl_cspi1_cs>;
>  	status = "okay";
> +
> +	adc@0 {
> +		compatible = "maxim,max1027";
> +		reg = <0>;
> +		interrupt-parent = <&gpio5>;
> +		interrupts = <15 IRQ_TYPE_EDGE_FALLING>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_max1027>;
> +		spi-max-frequency = <10000000>;
> +	};
>  };
>  
>  &cspi2 {
> @@ -230,6 +240,13 @@
>  		pinctrl_sdhc2_cd: sdhc2cdgrp {
>  			fsl,pins = <MX27_PAD_TOUT__GPIO3_14 0x0>;
>  		};
> +
> +		pinctrl_max1027: max1027 {
> +			 fsl,pins = <
> +				 MX27_PAD_UART1_CTS__GPIO5_14 0
> +				 MX27_PAD_UART1_RTS__GPIO5_15 0
> +			>;
> +		};
>  	};
>  };

Only one remark.
Function of GPIO5.14 is unclear. Can you add a comment for this?

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
