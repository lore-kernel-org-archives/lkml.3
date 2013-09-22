Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3IVHBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 03:01:55 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:14639
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466Ab3IVHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 03:01:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068h8275dhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 22 Sep 2013 15:01:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Porter <matt.porter@linaro.org>
CC: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH] ARM: dts: add initial VF610 Cosmic/Cosmic+ board support
Message-ID: <20130922070138.GC31787@S2101-09.ap.freescale.net>
References: <1379594444-11268-1-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1379594444-11268-1-git-send-email-matt.porter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 08:40:44AM -0400, Matt Porter wrote:
> Add initial PHYTEC VF610 Cosmic/Cosmic+ board support with
> UART and FEC enabled.
> 
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>  arch/arm/boot/dts/Makefile         |  1 +
>  arch/arm/boot/dts/vf610-cosmic.dts | 46 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
>  create mode 100644 arch/arm/boot/dts/vf610-cosmic.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index cc0f1fb..b0d6156 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -142,6 +142,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
>  	imx6q-sbc6x.dtb \
>  	imx6q-wandboard.dtb \
>  	imx6sl-evk.dtb \
> +	vf610-cosmic.dtb \
>  	vf610-twr.dtb
>  dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
>  	imx23-olinuxino.dtb \
> diff --git a/arch/arm/boot/dts/vf610-cosmic.dts b/arch/arm/boot/dts/vf610-cosmic.dts
> new file mode 100644
> index 0000000..c3bd4d4f
> --- /dev/null
> +++ b/arch/arm/boot/dts/vf610-cosmic.dts
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright 2013 Freescale Semiconductor, Inc.
> + * Copyright 2013 Linaro Limited
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +/dts-v1/;
> +#include "vf610.dtsi"
> +
> +/ {
> +	model = "PHYTEC Cosmic/Cosmic+ Board";
> +	compatible = "phytec,vf610-cosmic", "fsl,vf610";
> +
> +	chosen {
> +		bootargs = "console=ttyLP1,115200";
> +	};
> +
> +	memory {
> +		reg = <0x80000000 0x10000000>;
> +	};
> +
> +	clocks {
> +		enet_ext {
> +			compatible = "fixed-clock";
> +			clock-frequency = <50000000>;
> +		};

This is probably copied from vf610-twr.dts.  But per
Documentation/devicetree/bindings/clock/fixed-clock.txt, #clock-cells is
a required property.

> +	};
> +
> +};
> +
> +&uart1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_uart1_1>;
> +	status = "okay";
> +};
> +
> +&fec1 {

Please sort the nodes alphabetically in label name.

Shawn

> +	phy-mode = "rmii";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_fec1_1>;
> +	status = "okay";
> +};
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

