Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3KTO6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:58:52 -0500
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:41793 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3KTO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:58:49 -0500
Date: Wed, 20 Nov 2013 16:00:36 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/9] ARM: at91/dt: add spi0 support to at91rm9200ek board
Message-ID: <20131120150036.GF14627@ns203013.ovh.net>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
 <1377688052-10794-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377688052-10794-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 14859626971450485625
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:07 Wed 28 Aug     , Boris BREZILLON wrote:
> Add spi0 cs3 switch pinctrl pin definitions: this pin is used to select
> between mmc0 slot0 and spi dataflash connected to cs3.
> 
> Enable spi0 controller and define the mtd_dataflash connected to cs0.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/at91rm9200ek.dts |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
> index 2bad423..b3e7425 100644
> --- a/arch/arm/boot/dts/at91rm9200ek.dts
> +++ b/arch/arm/boot/dts/at91rm9200ek.dts
> @@ -56,6 +56,13 @@
>  							<AT91_PIOB 22 AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
>  					};
>  				};
> +
> +				spi0 {
> +					pinctrl_spi0_cs3_switch: spi0_cs3_switch-0 {
> +						atmel,pins =
> +							<AT91_PIOB 22 AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(0))>;
> +					};
same as mmc nack pinctrl is not for gpio default value

this is regulator
> +				};
>  			};
>  
>  			dbgu: serial@fffff200 {
> @@ -119,6 +126,19 @@
>  					wp-gpios = <&pioA 17 GPIO_ACTIVE_HIGH>;
>  				};
>  			};
> +
> +			spi0: spi@fffe0000 {
> +				pinctrl-0 = <&pinctrl_spi0 &pinctrl_spi0_cs0>;
> +				cs-gpios = <&pioA 3 GPIO_ACTIVE_HIGH>, <0>,
> +					   <0>, <0>;
> +				status = "okay";
> +
> +				mtd_dataflash@0 {
> +					compatible = "atmel,at45", "atmel,dataflash";
> +					spi-max-frequency = <15000000>;
> +					reg = <0>;
> +				};
> +			};
>  		};
>  
>  		usb0: ohci@00300000 {
> -- 
> 1.7.9.5
> 
