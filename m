Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaGWIUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:20:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41159 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbaGWIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:20:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-f0-53cf705d74ae
Content-transfer-encoding: 8BIT
Message-id: <1406103647.5322.1.camel@AMDC1943>
Subject: Re: [PATCH] extcon: Add missing REGMAP_I2C/REGMAP_IRQ dependency on
 extcon driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com,
        gg@slimlogic.co.uk, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Date: Wed, 23 Jul 2014 10:20:47 +0200
In-reply-to: <1406079640-28069-1-git-send-email-cw00.choi@samsung.com>
References: <y@samsung.com>
 <1406079640-28069-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xy7qxBeeDDf7NYbH4N+UGu8X1L89Z
	Lfq3uFicbXrDbnF51xw2i9uNK9gc2DxeTvzN5tG3ZRWjx9Qpfxk9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqYd2oBc0EXf8XeORcZGxhvc3cxcnJICJhI7Fl8ngnCFpO4cG89WxcjF4eQwFJGia7e
	52wgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJ2UdmsUDU60lc2XkCrFdY
	IEZiRcNnZhCbTcBYYvPyJWBxEQENiZl/rzCCNDMLTGCU6Du9hhEkwSKgKtHx6yDYIE4BN4lj
	nefBbCGBcIkjrWdZIC5Vlpi3/xjTBEaBWUjum4Vw3ywk9y1gZF7FKJpamlxQnJSea6hXnJhb
	XJqXrpecn7uJERLOX3YwLj5mdYhRgINRiYeX4eGpYCHWxLLiytxDjBIczEoivE2B54OFeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MJou2zrbPrkzoUDBWWKncW5svLfOhANPVynOMnjq7v7RQybn
	i6ZaQ47wuuXd37cfiJ7Pdf3aWQHb7FApwW2aEdNcQiqk3VZ7hH66Z5d46Pfbsn08T3W/yKyK
	6Rdcb7hqZc2Kq3GO6f4FG5yXf99RN9/W7+/tpIsPy+ZO+1nrdvRXqeMq54/mfEosxRmJhlrM
	RcWJAEyGTCBFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-07-23 at 10:40 +0900, Chanwoo Choi wrote:
> This patch add missing REGMAP_I2C/REGMAP_IRQ dependency on extcon provider
> driver to protect build break.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6f2f472..77577db 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -23,6 +23,7 @@ config EXTCON_ADC_JACK
>  config EXTCON_ARIZONA
>  	tristate "Wolfson Arizona EXTCON support"
>  	depends on MFD_ARIZONA && INPUT && SND_SOC
> +	select REGMAP_I2C
>  	help
>  	  Say Y here to enable support for external accessory detection
>  	  with Wolfson Arizona devices. These are audio CODECs with
> @@ -40,6 +41,7 @@ config EXTCON_MAX14577
>  	depends on MFD_MAX14577
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
> +	select REGMAP_IRQ

Hi,

Is a build break possible here? I think not because this depends on
MFD_MAX14577 which selects both REGMAP_I2C and REGMAP_IRQ.

This change seems not needed then.

>  	help
>  	  If you say yes here you get support for the MUIC device of
>  	  Maxim MAX14577/77836. The MAX14577/77836 MUIC is a USB port accessory
> @@ -50,6 +52,7 @@ config EXTCON_MAX77693
>  	depends on MFD_MAX77693 && INPUT
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
> +	select REGMAP_IRQ

The same applies here.

>  	help
>  	  If you say yes here you get support for the MUIC device of
>  	  Maxim MAX77693 PMIC. The MAX77693 MUIC is a USB port accessory
> @@ -66,6 +69,7 @@ config EXTCON_MAX8997
>  config EXTCON_PALMAS
>  	tristate "Palmas USB EXTCON support"
>  	depends on MFD_PALMAS
> +	select REGMAP_IRQ

The same applies here.

Best regards,
Krzysztof

>  	help
>  	  Say Y here to enable support for USB peripheral and USB host
>  	  detection by palmas usb.

