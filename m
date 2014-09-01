Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaIAIYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:24:32 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:55753
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752254AbaIAIYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:24:30 -0400
Date: Mon, 1 Sep 2014 16:24:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Philippe Reynes <tremyfr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <kernel@pengutronix.de>,
        <shc_work@mail.ru>
Subject: Re: [PATCH v3] apf27dev: add max1027 in the dts
Message-ID: <20140901082413.GE3135@dragon>
References: <1409517629-5918-1-git-send-email-tremyfr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409517629-5918-1-git-send-email-tremyfr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(51704005)(24454002)(199003)(54534003)(85852003)(4396001)(87936001)(46102001)(90102001)(92726001)(92566001)(81542001)(33716001)(77982001)(84676001)(50466002)(83072002)(83506001)(81342001)(104016003)(76482001)(79102001)(99396002)(1411001)(86362001)(85306004)(95666004)(106466001)(31966008)(102836001)(44976005)(19580395003)(57986006)(74502001)(33656002)(26826002)(97736001)(64706001)(107046002)(69596002)(76176999)(74662001)(19580405001)(21056001)(47776003)(23726002)(83322001)(50986999)(81156004)(20776003)(54356999)(105606002)(110136001)(80022001)(68736004)(6806004)(97756001)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB571;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 10:40:29PM +0200, Philippe Reynes wrote:
> 
> Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
> ---
>  arch/arm/boot/dts/imx27-apf27dev.dts |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> Changelog:
> v3: (thanks Alexander Shiyan for the feedback)
> - add datasheet pin name as comment
> 
> v2: (thanks Alexander Shiyan for the feedback)
> - spi mode 0 is the default so no need to explicitly define it
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
> index b982309..0c08fbb 100644
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

The pinctrl entries are alphabetically sorted in there.  Can you also do
that for your addition?

> +			 fsl,pins = <
> +				 MX27_PAD_UART1_CTS__GPIO5_14 0 /* CNVST */
> +				 MX27_PAD_UART1_RTS__GPIO5_15 0 /* EOC */

Can you follow the convention to use hex value for the config cell,
i.e. s/0/0x0?

Shawn

> +			>;
> +		};
>  	};
>  };
>  
> -- 
> 1.7.4.4
> 
