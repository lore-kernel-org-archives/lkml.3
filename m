Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIZCXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:23:00 -0400
Received: from mail-bl2on0110.outbound.protection.outlook.com ([65.55.169.110]:5024
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753195AbaIZCW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:22:58 -0400
Date: Fri, 26 Sep 2014 10:22:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ARM: dts: vf610-colibri: Add PWM support
Message-ID: <20140926022232.GI21077@dragon>
References: <cover.1411378369.git.bhuvanchandra.dv@toradex.com>
 <d508a6ad39e07d5489c4b5110784902ab0241c44.1411378369.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d508a6ad39e07d5489c4b5110784902ab0241c44.1411378369.git.bhuvanchandra.dv@toradex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(54356999)(50986999)(76176999)(57986006)(90102001)(83506001)(104016003)(23726002)(33656002)(50466002)(99396003)(97736003)(83072002)(68736004)(110136001)(97756001)(102836001)(21056001)(46406003)(107046002)(86362001)(6806004)(575784001)(31966008)(19580405001)(4396001)(83322001)(19580395003)(44976005)(81156004)(92566001)(92726001)(106466001)(84676001)(85852003)(105606002)(47776003)(64706001)(20776003)(95666004)(33716001)(120916001)(79102003)(74662003)(46102003)(69596002)(74502003)(80022003)(10300001)(85306004)(77982003)(81342003)(87936001)(76482002)(81542003)(473944003)(414714003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0632;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:38:11PM +0530, Bhuvanchandra DV wrote:
> The Colibri standard defines four pins as PWM outputs, two of them (PWM
> A and C) are routed to FTM instance 0 and the other two (PWM B and D)
> are routed to FTM instance 1. Hence enable both FTM instances for the
> Colibri module and mux the four pins accordingly.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>

You should add Stefan's ACK tag.

> ---
>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 ++++++++
>  arch/arm/boot/dts/vf610-colibri.dtsi        |   24 ++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> index 7fb3066..00f63d9 100644
> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> @@ -33,6 +33,14 @@
>  	status = "okay";
>  };
>  
> +&pwm0 {
> +	status = "okay";
> +};
> +
> +&pwm1 {
> +	status = "okay";
> +};
> +

I was trying to apply the patches, but found pwm1 is not available in
vf610.dtsi at all.  What tree is your patch generated against?  Or did I
miss any prerequisite patches?

Shawn

>  &uart0 {
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..1f73c1c 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -44,6 +44,16 @@
>  	arm,tag-latency = <3 2 3>;
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
>  &uart0 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_uart0>;
> @@ -97,6 +107,20 @@
>  			>;
>  		};
>  
> +		pinctrl_pwm0: pwm0grp {
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
>  		pinctrl_uart0: uart0grp {
>  			fsl,pins = <
>  				VF610_PAD_PTB10__UART0_TX		0x21a2
> -- 
> 1.7.9.5
> 
