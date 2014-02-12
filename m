Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBLLqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:46:51 -0500
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:57552 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbaBLLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:46:50 -0500
Message-ID: <52FB5B3E.4020401@overkiz.com>
Date: Wed, 12 Feb 2014 12:30:06 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91/DT: add NAND + DMA property
References: <1392203183-9851-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1392203183-9851-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6572722181775194220
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 12:06, Nicolas Ferre wrote:
> Add the "atmel,nand-has-dma" property to NAND node for SoC that
> can use the DMA to perform NAND accesses.
> Use of this property was added in 1b7192658a08f70df0f290634fd7cd2ecb629fc9
> (mtd: atmel_nand: add a new dt binding item for nand dma support).
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/boot/dts/at91sam9g45.dtsi | 1 +
>   arch/arm/boot/dts/at91sam9n12.dtsi | 1 +
>   arch/arm/boot/dts/at91sam9x5.dtsi  | 1 +
>   arch/arm/boot/dts/sama5d3.dtsi     | 1 +
>   4 files changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index cbcc058b26b4..9b6683f252cf 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -817,6 +817,7 @@
>   			      >;
>   			atmel,nand-addr-offset = <21>;
>   			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&pinctrl_nand>;
>   			gpios = <&pioC 8 GPIO_ACTIVE_HIGH
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> index 394e6ce2afb7..9f04808fc697 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -570,6 +570,7 @@
>   			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
>   			atmel,nand-addr-offset = <21>;
>   			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&pinctrl_nand>;
>   			gpios = <&pioD 5 GPIO_ACTIVE_HIGH
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 174219de92fa..67e32067eb25 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -790,6 +790,7 @@
>   			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
>   			atmel,nand-addr-offset = <21>;
>   			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&pinctrl_nand>;
>   			gpios = <&pioD 5 GPIO_ACTIVE_HIGH
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 3d5faf85f51b..d075c5326ce7 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -1256,6 +1256,7 @@
>   			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
>   			atmel,nand-addr-offset = <21>;
>   			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
>   			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;

