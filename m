Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3GJOoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:44:55 -0400
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:36446 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487Ab3GJOoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:44:54 -0400
Date: Wed, 10 Jul 2013 16:38:35 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, ludovic.desroches@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 2/3] arm: atmel: at91sam9n12: add qt1070 support
Message-ID: <20130710143835.GG18012@ns203013.ovh.net>
References: <1373449869-5083-1-git-send-email-voice.shen@atmel.com>
 <1373449869-5083-3-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373449869-5083-3-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 8223291444863806259
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:51 Wed 10 Jul     , Bo Shen wrote:
> add qt1070 support on at91sam9n12ek board
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  arch/arm/boot/dts/at91sam9n12ek.dts |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
> index d59b70c..3acac62 100644
> --- a/arch/arm/boot/dts/at91sam9n12ek.dts
> +++ b/arch/arm/boot/dts/at91sam9n12ek.dts
> @@ -40,6 +40,15 @@
>  
>  			i2c0: i2c@f8010000 {
>  				status = "okay";
> +
> +				qt1070: keyboard@1b {
> +					compatible = "qt1070";
> +					reg = <0x1b>;
> +					interrupt-parent = <&pioA>;
> +					interrupts = <2 0x0>;
use the macro
> +					pinctrl-names = "default";
> +					pinctrl-0 = <&pinctrl_qt1070_irq>;
> +				};
>  			};
>  
>  			i2c1: i2c@f8014000 {
> @@ -66,6 +75,13 @@
>  							<AT91_PIOA 7 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;	/* PA7 gpio CD pin pull up and deglitch */
>  					};
>  				};
> +
> +				qt1070 {
> +					pinctrl_qt1070_irq: qt1070_irq {
> +						atmel,pins =
> +							<AT91_PIOA 2 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PA2 GPIO with pull up deglith */
drop the comment as we use macro
> +					};
> +				};
>  			};
>  
>  			spi0: spi@f0000000 {
> -- 

Best Regards,
J.
