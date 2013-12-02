Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3LBSyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:54:16 -0500
Received: from 6.mo4.mail-out.ovh.net ([188.165.36.253]:49561 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266Ab3LBSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:54:13 -0500
X-Greylist: delayed 21493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 13:54:13 EST
Message-ID: <529CD751.3020704@overkiz.com>
Date: Mon, 02 Dec 2013 19:54:09 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: add i2c2 pinctrl speficifation to sama5d3
 DT
References: <1386001128-29147-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1386001128-29147-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15515463667742046316
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 17:18, Nicolas Ferre wrote:


Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/boot/dts/sama5d3.dtsi | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index f520b0236671..f5fd111b5ee6 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -304,6 +304,8 @@
>   				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(11)>,
>   				       <&dma1 2 AT91_DMA_CFG_PER_ID(12)>;
>   				dma-names = "tx", "rx";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_i2c2>;
>   				#address-cells = <1>;
>   				#size-cells = <0>;
>   				clocks = <&twi2_clk>;
> @@ -494,6 +496,14 @@
>   					};
>   				};
>   
> +				i2c2 {
> +					pinctrl_i2c2: i2c2-0 {
> +						atmel,pins =
> +							<AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* TWD2 pin, conflicts with LCDDAT18, ISI_D2 */
> +							 AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* TWCK2 pin, conflicts with LCDDAT19, ISI_D3 */
> +					};
> +				};
> +
>   				isi {
>   					pinctrl_isi: isi-0 {
>   						atmel,pins =

