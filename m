Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaIQBrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:47:43 -0400
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:55019
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753167AbaIQBrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:47:41 -0400
Date: Wed, 17 Sep 2014 09:47:24 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917014723.GB4796@dragon>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410511739-31122-2-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(92726001)(46406003)(83072002)(97756001)(46102003)(105606002)(80022003)(4396001)(47776003)(90102001)(99396002)(68736004)(79102003)(97736003)(85852003)(81542003)(74502003)(81342003)(83322001)(77982003)(87936001)(95666004)(57986006)(26826002)(50466002)(102836001)(110136001)(19580395003)(86362001)(33656002)(107046002)(21056001)(6806004)(44976005)(50986999)(20776003)(74662003)(19580405001)(85306004)(106466001)(64706001)(31966008)(104016003)(33716001)(76482002)(76176999)(83506001)(23726002)(92566001)(54356999)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB036;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:48:57PM +0800, Robin Gong wrote:
> All chips of i.mx6 can be powered off by programming SNVS.
> For example :
> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> pmic ON/OFF pin, that will cause the whole PMIC powered off
> except VSNVS. And system can restart once PMIC_ON_REQ goes
> high by push POWRER key.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  .../bindings/power_supply/imx-snvs-poweroff.txt     | 21 +++++++++++++++++++++

Binding docs should be generally a separate patch or in the driver
patch, which uses the bindings.

Shawn

>  arch/arm/boot/dts/imx6qdl.dtsi                      |  5 +++++
>  arch/arm/boot/dts/imx6sl.dtsi                       |  5 +++++
>  arch/arm/boot/dts/imx6sx.dtsi                       |  5 +++++
>  4 files changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> new file mode 100644
> index 0000000..1a3ab9a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> @@ -0,0 +1,21 @@
> +i.mx6 Poweroff Driver
> +
> +SNVS_LPCR in SNVS module can power off the whole system by pull
> +PMIC_ON_REQ low.
> +
> +Required Properties:
> +-compatible: "fsl,sec-v4.0-poweroff"
> +-reg: Specifies the physical address of the SNVS_LPCR register
> +
> +Example:
> +	snvs@020cc000 {
> +		compatible = "fsl,sec-v4.0-mon", "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x020cc000 0x4000>;
> +		.....
> +		snvs-poweroff@38 {
> +			compatible = "fsl,sec-v4.0-poweroff";
> +			reg = <0x38 0x4>;
> +		};
> +	}
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index 70d7207..d2d7563 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -650,6 +650,11 @@
>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +				};
>  			};
>  
>  			epit1: epit@020d0000 { /* EPIT1 */
> diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
> index ba67714..6e1d8f6 100644
> --- a/arch/arm/boot/dts/imx6sl.dtsi
> +++ b/arch/arm/boot/dts/imx6sl.dtsi
> @@ -568,6 +568,11 @@
>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +				};
>  			};
>  
>  			epit1: epit@020d0000 {
> diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
> index d137caca..c1f937e 100644
> --- a/arch/arm/boot/dts/imx6sx.dtsi
> +++ b/arch/arm/boot/dts/imx6sx.dtsi
> @@ -671,6 +671,11 @@
>  					reg = <0x34 0x58>;
>  					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +				};
>  			};
>  
>  			epit1: epit@020d0000 {
> -- 
> 1.9.1
> 
