Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3EJPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:15:14 -0400
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:42893 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753430Ab3EJPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:15:12 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 11:15:12 EDT
Date: Fri, 10 May 2013 16:34:04 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91: dts: request only spi cs-gpios used on
 sama5d3x cpu module
Message-ID: <20130510143404.GB22508@game.jcrosoft.org>
References: <1368181807-15182-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368181807-15182-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 459367162953837420
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:30 Fri 10 May     , Nicolas Ferre wrote:
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> Instead of requesting all available spi cs-gpios, request only the ones used on
> the board, in our case on the cpu module.
> 
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> ---
>  arch/arm/boot/dts/sama5d3.dtsi    | 10 ----------
>  arch/arm/boot/dts/sama5d3xcm.dtsi |  4 ++++
>  2 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 2e643ea..dee5e2f 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -75,11 +75,6 @@
>  				compatible = "atmel,at91sam9x5-spi";
>  				reg = <0xf0004000 0x100>;
>  				interrupts = <24 4 3>;
> -				cs-gpios = <&pioD 13 0
> -					    &pioD 14 0 /* conflicts with SCK0 and CANRX0 */
> -					    &pioD 15 0 /* conflicts with CTS0 and CANTX0 */
> -					    &pioD 16 0 /* conflicts with RTS0 and PWMFI3 */
> -					   >;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
> @@ -203,11 +198,6 @@
>  				compatible = "atmel,at91sam9x5-spi";
>  				reg = <0xf8008000 0x100>;
>  				interrupts = <25 4 3>;
> -				cs-gpios = <&pioC 25 0
> -					    &pioC 26 0 /* conflitcs with TWD1 and ISI_D11 */
> -					    &pioC 27 0 /* conflitcs with TWCK1 and ISI_D10 */
> -					    &pioC 28 0 /* conflitcs with PWMFI0 and ISI_D9 */
> -					   >;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index 1f8ed40..b336e77 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -32,6 +32,10 @@
>  
>  	ahb {
>  		apb {
> +			spi0: spi@f0004000 {
> +				cs-gpios = <&pioD 13 0>, <0>, <0>, <0>;
> +			};
> +
>  			macb0: ethernet@f0028000 {
>  				phy-mode = "rgmii";
>  			};
> -- 
> 1.8.0
> 
