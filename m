Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab3DHMsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:48:07 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:21686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935075Ab3DHMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:48:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 8 Apr 2013 20:48:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Hector Palacios <hector.palacios@digi.com>
CC: <linux-kernel@vger.kernel.org>, <maxime.ripard@free-electrons.com>,
        <marex@denx.de>, <fabio.estevam@freescale.com>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc
 pins config
Message-ID: <20130408124810.GC5044@S2101-09.ap.freescale.net>
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1365415940-11609-1-git-send-email-hector.palacios@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
> MicroSD card sockets don't usually have card detect line. This pin
> is actually not needed for the MMC to work and it is more of a
> platform design decission to have it.
> The card detect pin already has a configuration entry of its own:
> 'mmc0_cd_cfg' so we complete the iomux configuration here and let
> platforms to include it or not depending on whether the card detect
> line is routed to the SD socket.
> 
Sounds sensible.

> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
> 
> Hello,
> 
> All imx28 based platforms except 'bluegiga,apx4devkit' and 
> 'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc configuration
> so please check whether this patch would break these platforms.
> 
I just tested the patch on imx28-evk and card-detection still works.  So
patches applied, thanks.

Shawn

>  arch/arm/boot/dts/imx28.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index 9b18e81..4222e4e 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -449,7 +449,6 @@
>  						0x2060 /* MX28_PAD_SSP0_DATA6__SSP0_D6 */
>  						0x2070 /* MX28_PAD_SSP0_DATA7__SSP0_D7 */
>  						0x2080 /* MX28_PAD_SSP0_CMD__SSP0_CMD */
> -						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
>  						0x20a0 /* MX28_PAD_SSP0_SCK__SSP0_SCK */
>  					>;
>  					fsl,drive-strength = <1>;
> @@ -465,7 +464,6 @@
>  						0x2020 /* MX28_PAD_SSP0_DATA2__SSP0_D2 */
>  						0x2030 /* MX28_PAD_SSP0_DATA3__SSP0_D3 */
>  						0x2080 /* MX28_PAD_SSP0_CMD__SSP0_CMD */
> -						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
>  						0x20a0 /* MX28_PAD_SSP0_SCK__SSP0_SCK */
>  					>;
>  					fsl,drive-strength = <1>;
> @@ -477,6 +475,8 @@
>  					fsl,pinmux-ids = <
>  						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
>  					>;
> +					fsl,drive-strength = <1>;
> +					fsl,voltage = <1>;
>  					fsl,pull-up = <0>;
>  				};
>  
> -- 
> 1.8.2
> 

