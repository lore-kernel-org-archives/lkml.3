Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3BEU3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:29:40 -0500
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:58860 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755108Ab3BEU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:29:37 -0500
Date: Tue, 5 Feb 2013 20:50:08 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        linux@arm.linux.org.uk
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [v4 PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
Message-ID: <20130205195008.GA30595@game.jcrosoft.org>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <1358148877-18679-13-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358148877-18679-13-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7129198210394663813
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:34 Mon 14 Jan     , Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> [wenyou.yang@atmel.com: added spi nodes for the sam9263ek, sam9g20ek, sam9m10g45ek and sam9n12ek boards]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: linux@arm.linux.org.uk
> ---
>  arch/arm/boot/dts/at91sam9263ek.dts         |   14 ++++++++++++++
>  arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   14 ++++++++++++++
>  arch/arm/boot/dts/at91sam9m10g45ek.dts      |   14 ++++++++++++++
>  arch/arm/boot/dts/at91sam9n12ek.dts         |   14 ++++++++++++++
>  arch/arm/boot/dts/at91sam9x5ek.dtsi         |   14 ++++++++++++++
>  5 files changed, 70 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
> index 1eb0872..63ba57b 100644
> --- a/arch/arm/boot/dts/at91sam9263ek.dts
> +++ b/arch/arm/boot/dts/at91sam9263ek.dts
> @@ -79,6 +79,20 @@
>  					};
>  				};
>  			};
> +
> +			spi0: spi@fffa4000 {
> +				status = "okay";
> +				cs-gpios = <&pioA 5 0
> +					    &pioA 3 0
> +					    &pioA 4 0
> +					    &pioB 11 0
NACK

we no use that much as cs-gpios on this hw
> +					   >;
> +				mtd_dataflash@0 {
> +					compatible = "atmel,at45", "atmel,dataflash";
> +					spi-max-frequency = <50000000>;
> +					reg = <0>;
> +				};
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> index da15e83..49ad49e 100644
> --- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> @@ -96,6 +96,20 @@
>  				status = "okay";
>  				pinctrl-0 = <&pinctrl_ssc0_tx>;
>  			};
> +
> +			spi0: spi@fffc8000 {
> +				status = "okay";
> +				cs-gpios = <&pioA 3 0
> +					    &pioC 11 0
> +					    &pioC 16 0
> +					    &pioC 17 0
ditto and so on

you must only provife the gpio use by the hw
> +					   >;
> +				mtd_dataflash@0 {
> +					compatible = "atmel,at45", "atmel,dataflash";
> +					spi-max-frequency = <50000000>;
> +					reg = <1>;
> +				};
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> index 20c3191..275f22d 100644
> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> @@ -102,6 +102,20 @@
>  					};
>  				};
>  			};
> +
> +			spi0: spi@fffa4000{
> +				status = "okay";
> +				cs-gpios = <&pioB 3 0
> +					    &pioB 18 0
> +					    &pioB 19 0
> +					    &pioD 27 0
> +					   >;
> +				mtd_dataflash@0 {
> +					compatible = "atmel,at45", "atmel,dataflash";
> +					spi-max-frequency = <13000000>;
> +					reg = <0>;
> +				};
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
> index 0376bf4..4eeca7b 100644
> --- a/arch/arm/boot/dts/at91sam9n12ek.dts
> +++ b/arch/arm/boot/dts/at91sam9n12ek.dts
> @@ -67,6 +67,20 @@
>  					};
>  				};
>  			};
> +
> +			spi0: spi@f0000000 {
> +				status = "okay";
> +				cs-gpios = <&pioA 14 0
> +					    &pioA 7 0
> +					    &pioA 1 0
> +					    &pioB 3 0
> +					   >;
> +				m25p80@0 {
> +					compatible = "atmel,at25df321a";
> +					spi-max-frequency = <50000000>;
> +					reg = <0>;
> +				};
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> index 8a7cf1d..ca0a056 100644
> --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> @@ -84,6 +84,20 @@
>  					};
>  				};
>  			};
> +
> +			spi0: spi@f0000000 {
> +				status = "okay";
> +				cs-gpios = <&pioA 14 0
> +					    &pioA 7 0
> +					    &pioA 1 0
> +					    &pioB 3 0
> +					   >;
> +				m25p80@0 {
> +					compatible = "atmel,at25df321a";
> +					spi-max-frequency = <50000000>;
> +					reg = <0>;
> +				};
> +			};
>  		};
>  
>  		usb0: ohci@00600000 {
> -- 
> 1.7.9.5
> 
