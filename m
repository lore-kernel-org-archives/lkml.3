Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaIRONA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:13:00 -0400
Received: from mail-by2on0139.outbound.protection.outlook.com ([207.46.100.139]:62432
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbaIROM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:12:59 -0400
Date: Thu, 18 Sep 2014 22:12:49 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: vf610-colibri: Add PWM support
Message-ID: <20140918141248.GL4796@dragon>
References: <cover.1410930820.git.bhuvanchandra.dv@toradex.com>
 <819bd3bc9541ca53f005b7cf95bc890f1a9215e5.1410930820.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <819bd3bc9541ca53f005b7cf95bc890f1a9215e5.1410930820.git.bhuvanchandra.dv@toradex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(199003)(97756001)(46406003)(76482002)(86362001)(110136001)(575784001)(85852003)(83072002)(80022003)(79102003)(74502003)(81542003)(77982003)(81342003)(46102003)(90102001)(33716001)(74662003)(6806004)(99396002)(85306004)(23726002)(102836001)(47776003)(54356999)(20776003)(76176999)(97736003)(64706001)(44976005)(26826002)(19580405001)(68736004)(19580395003)(83322001)(87936001)(50986999)(50466002)(57986006)(33656002)(95666004)(104016003)(21056001)(4396001)(105606002)(31966008)(83506001)(107046002)(84676001)(92566001)(106466001)(92726001)(414714003)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0635;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:46:29PM +0530, Bhuvanchandra DV wrote:
>  The Colibri standard defines four pins as PWM outputs, two of them (PWM
>  A and C) are routed to FTM instance 0 and the other two (PWM B and D)
>  are routed to FTM instance 1. Hence enable both FTM instances for the
>  Colibri module and mux the four pins accordingly.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 ++++++++
>  arch/arm/boot/dts/vf610-colibri.dtsi        |   25 +++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> index 7fb3066..ba98039 100644
> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> @@ -44,3 +44,11 @@
>  &uart2 {
>  	status = "okay";
>  };
> +
> +&pwm0 {
> +	status = "okay";
> +};
> +
> +&pwm1 {
> +	status = "okay";
> +};

Please sort the node alphabetically, so that we can locate them more
easily.

> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..9bd1415 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -69,6 +69,16 @@
>  	status = "okay";
>  };
>  
> +&pwm0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_pwm0>;
> +};
> +
> +&pwm1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_pwm1>;
> +};
> +

Ditto

>  &iomuxc {
>  	vf610-colibri {
>  		pinctrl_esdhc1: esdhc1grp {
> @@ -119,5 +129,20 @@
>  				VF610_PAD_PTD3__UART2_CTS		0x21a1
>  			>;
>  		};
> +
> +		pinctrl_pwm0: pwm0grp {

We also maintain the alphabetic order of pinctrl_* entries under iomuxc
node.

Shawn

> +			fsl,pins = <
> +				VF610_PAD_PTB0__FTM0_CH0		0x1182
> +				VF610_PAD_PTB1__FTM0_CH1		0x1182
> +			>;
> +		};
> +
> +		pinctrl_pwm1: pwm1grp {
> +			fsl,pins = <
> +				VF610_PAD_PTB8__FTM1_CH0		0x1182
> +				VF610_PAD_PTB9__FTM1_CH1		0x1182
> +			>;
> +		};
> +
>  	};
>  };
> -- 
> 1.7.9.5
> 
