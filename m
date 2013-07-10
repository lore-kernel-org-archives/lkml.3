Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3GJOy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:54:56 -0400
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:45253 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752571Ab3GJOyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:54:54 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 10:54:54 EDT
Date: Wed, 10 Jul 2013 16:39:23 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, ludovic.desroches@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] arm: atmel: at91sam9n12: add pinctrl of TWI
Message-ID: <20130710143923.GH18012@ns203013.ovh.net>
References: <1373449869-5083-1-git-send-email-voice.shen@atmel.com>
 <1373449869-5083-2-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373449869-5083-2-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 8236802243958647603
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
> add pinctrl of TWI for at91sam9n12 SoC
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  arch/arm/boot/dts/at91sam9n12.dtsi |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> index bb7f564..3db62f6 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -291,6 +291,22 @@
>  					};
>  				};
>  
> +				i2c0 {
> +					pinctrl_i2c0: i2c0-0 {
> +						atmel,pins =
> +							<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA30 periph A I2C0 data */
> +							 AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA31 periph A I2C0 clock */
> +					};
> +				};
> +
> +				i2c1 {
> +					pinctrl_i2c1: i2c1-0 {
> +						atmel,pins =
> +							<AT91_PIOC 0 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC0 periph C I2C1 data */
> +							 AT91_PIOC 1 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC1 periph C I2C1 clock */
drop  the comment as we use macro
> +					};
> +				};
> +
>  				tcb0 {
>  					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
>  						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> @@ -471,6 +487,8 @@
>  				dma-names = "tx", "rx";
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_i2c0>;
>  				status = "disabled";
>  			};
>  
> @@ -483,6 +501,8 @@
>  				dma-names = "tx", "rx";
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_i2c1>;
>  				status = "disabled";
>  			};
>  
> -- 
> 1.7.9.5
> 
