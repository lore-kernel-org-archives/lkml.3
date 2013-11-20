Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3KTPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:04:42 -0500
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:33528 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461Ab3KTPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:04:37 -0500
Date: Wed, 20 Nov 2013 15:59:26 +0100
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
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek
 board
Message-ID: <20131120145926.GE14627@ns203013.ovh.net>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
 <1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 14839642247866723193
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

On 13:06 Wed 28 Aug     , Boris BREZILLON wrote:
> Add slot0 of mmc0 pinctrl pins definitions:
>  - detect pin
>  - write protect pin
>  - enable slot0 pin: this pin is connected to an external switch which
>    enable mmc0 slot0 or spi dataflash connected to cs3
> 
> The mmc0 device is not enabled, as it depends on the choosen functionnality
> (spi cs3 or mmc0 slot0).
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/at91rm9200ek.dts |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
> index f2d6d79..2bad423 100644
> --- a/arch/arm/boot/dts/at91rm9200ek.dts
> +++ b/arch/arm/boot/dts/at91rm9200ek.dts
> @@ -39,6 +39,23 @@
>  						atmel,pins = <AT91_PIOD 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;
>  					};
>  				};
> +
> +				mmc0 {
> +					pinctrl_mmc0_slot0_detect: mmc0_slot0_detect-0 {
> +						atmel,pins =
> +							<AT91_PIOB 27 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> +					};
> +
> +					pinctrl_mmc0_slot0_write_protect: mmc0_slot0_write_protect-0 {
> +						atmel,pins =
> +							<AT91_PIOA 17 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
> +					};
> +
> +					pinctrl_mmc0_slot0_switch: mmc0_slot0_switch-0 {
> +						atmel,pins =
> +							<AT91_PIOB 22 AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
> +					};
nack this is a regulator the pinctrl API is not done for gpio default value
> +				};
>  			};
>  
>  			dbgu: serial@fffff200 {
> @@ -84,6 +101,24 @@
>  					reg = <0>;
>  				};
>  			};
> +
> +			mmc0: mmc@fffb4000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				pinctrl-0 = <&pinctrl_mmc0_clk
> +					     &pinctrl_mmc0_slot0_cmd_dat0
> +					     &pinctrl_mmc0_slot0_dat1_3
> +					     &pinctrl_mmc0_slot0_detect
> +					     &pinctrl_mmc0_slot0_write_protect
> +					     &pinctrl_mmc0_slot0_switch>;
> +
> +				slot0: slot@0 {
> +					reg = <0>;
> +					bus-width = <4>;
> +					cd-gpios = <&pioB 27 GPIO_ACTIVE_HIGH>;
> +					wp-gpios = <&pioA 17 GPIO_ACTIVE_HIGH>;
> +				};
> +			};
>  		};
>  
>  		usb0: ohci@00300000 {
> -- 
> 1.7.9.5
> 
