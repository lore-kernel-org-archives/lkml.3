Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaIZBVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:21:54 -0400
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:15556
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753179AbaIZBVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:21:53 -0400
Date: Fri, 26 Sep 2014 09:21:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>,
        <l.stach@pengutronix.de>
Subject: Re: [PATCH v3 4/5] ARM: dts: vf610: use new GPIO support
Message-ID: <20140926012126.GC21077@dragon>
References: <cover.1411662961.git.stefan@agner.ch>
 <590a5fbc4f8b552355a93c1002041765352cd1c3.1411662961.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <590a5fbc4f8b552355a93c1002041765352cd1c3.1411662961.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(24454002)(110136001)(81542003)(87936001)(104016003)(44976005)(4396001)(83322001)(6806004)(68736004)(81342003)(74502003)(81156004)(107046002)(50986999)(97736003)(46102003)(33716001)(102836001)(74662003)(97756001)(50466002)(79102003)(19580395003)(106466001)(105606002)(19580405001)(10300001)(83072002)(90102001)(85852003)(86362001)(21056001)(69596002)(83506001)(31966008)(80022003)(64706001)(23726002)(57986006)(76176999)(84676001)(47776003)(95666004)(20776003)(92566001)(33656002)(76482002)(92726001)(85306004)(46406003)(77982003)(99396003)(120916001)(54356999)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:37:08PM +0200, Stefan Agner wrote:
> Use GPIO support by adding SD card detection configuration and
> GPIO pinmux for Colibri's standard GPIO pins. Attach the GPIO
> pins to the iomuxc node to get the GPIO pin settings applied.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/boot/dts/vf610-colibri.dtsi | 9 +++++++++
>  arch/arm/boot/dts/vf610-twr.dts      | 1 +
>  arch/arm/boot/dts/vf610.dtsi         | 1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..efd4322 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -31,6 +31,7 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_esdhc1>;
>  	bus-width = <4>;
> +	cd-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
>  };
>  
>  &fec1 {
> @@ -71,6 +72,14 @@
>  
>  &iomuxc {
>  	vf610-colibri {
> +		pinctrl_gpio_ext: gpio_ext {
> +			fsl,pins = <
> +				VF610_PAD_PTD10__GPIO_89	0x22ed /* EXT_IO_0 */
> +				VF610_PAD_PTD9__GPIO_88		0x22ed /* EXT_IO_1 */
> +				VF610_PAD_PTD26__GPIO_68	0x22ed /* EXT_IO_2 */
> +			>;
> +		};
> +

I'm not sure these GPIOs will be set up at anywhere.  To set them up,
you need to either have pinctrl_gpio_ext referenced by some client
device in its pinctrl-* property or put these pins into hog group (see
example in arch/arm/boot/dts/vf610-twr.dts).

Shawn

>  		pinctrl_esdhc1: esdhc1grp {
>  			fsl,pins = <
>  				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
> index 189b697..3fe8a8f 100644
> --- a/arch/arm/boot/dts/vf610-twr.dts
> +++ b/arch/arm/boot/dts/vf610-twr.dts
> @@ -116,6 +116,7 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_esdhc1>;
>  	bus-width = <4>;
> +	cd-gpios = <&gpio5 6 GPIO_ACTIVE_LOW>;
>  	status = "okay";
>  };
>  
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 4d2ec32..467c97e 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -11,6 +11,7 @@
>  #include "vf610-pinfunc.h"
>  #include <dt-bindings/clock/vf610-clock.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/gpio/gpio.h>
>  
>  / {
>  	aliases {
> -- 
> 2.1.0
> 
