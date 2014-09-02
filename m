Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaIBNxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:53:30 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:1899
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbaIBNx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:53:28 -0400
Date: Tue, 2 Sep 2014 21:53:05 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Philippe Reynes <tremyfr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <kernel@pengutronix.de>,
        <shc_work@mail.ru>
Subject: Re: [PATCH v4] apf27dev: add max1027 in the dts
Message-ID: <20140902135303.GK3135@dragon>
References: <1409597072-29196-1-git-send-email-tremyfr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409597072-29196-1-git-send-email-tremyfr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(24454002)(189002)(54534003)(51704005)(84676001)(110136001)(46102001)(106466001)(33656002)(76482001)(64706001)(107046002)(76176999)(46406003)(97756001)(74662001)(77982001)(104016003)(54356999)(81542001)(47776003)(50986999)(80022001)(23726002)(99396002)(74502001)(85306004)(20776003)(50466002)(81342001)(1411001)(92566001)(105606002)(87936001)(4396001)(26826002)(6806004)(44976005)(31966008)(90102001)(95666004)(68736004)(92726001)(33716001)(19580395003)(83506001)(102836001)(21056001)(97736001)(85852003)(86362001)(83072002)(57986006)(19580405001)(79102001)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB572;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:44:32PM +0200, Philippe Reynes wrote:
> 
> Signed-off-by: Philippe Reynes <tremyfr@gmail.com>

Added "ARM: dts: " as the patch subject prefix, and applied the patch.

Shawn

> ---
>  arch/arm/boot/dts/imx27-apf27dev.dts |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> Changelog:
> v4: (thanks Shawn Guo for the feedback)
> - put max1027 pinctl in the right place
> - use 0x0 instead of 0
> 
> v3: (thanks Alexander Shiyan for the feedback)
> - add datasheet pin name as comment
> 
> v2: (thanks Alexander Shiyan for the feedback)
> - spi mode 0 is the default so no need to explicitly define it
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
> index b982309..bba3f41 100644
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
> @@ -210,6 +220,13 @@
>  			>;
>  		};
>  
> +		pinctrl_max1027: max1027 {
> +			 fsl,pins = <
> +				 MX27_PAD_UART1_CTS__GPIO5_14 0x0 /* CNVST */
> +				 MX27_PAD_UART1_RTS__GPIO5_15 0x0 /* EOC */
> +			>;
> +		};
> +
>  		pinctrl_pwm: pwmgrp {
>  			fsl,pins = <
>  				MX27_PAD_PWMO__PWMO 0x0
> -- 
> 1.7.4.4
> 
