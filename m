Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaCVGu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:50:58 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:32199
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbaCVGuy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:50:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh2a8h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Date: Sat, 22 Mar 2014 14:50:40 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] ARM: dts: tx53: Add IPU DI ports and endpoints
Message-ID: <20140322065038.GE5938@dragon>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
 <1395235721-13847-5-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1395235721-13847-5-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 02:28:41PM +0100, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  arch/arm/boot/dts/imx53-tx53-x03x.dts |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx53-tx53-x03x.dts b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> index 0217dde3..43b4b7b 100644
> --- a/arch/arm/boot/dts/imx53-tx53-x03x.dts
> +++ b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> @@ -25,12 +25,17 @@
>  	soc {
>  		display: display@di0 {
>  			compatible = "fsl,imx-parallel-display";
> -			crtcs = <&ipu 0>;
>  			interface-pix-fmt = "rgb24";
>  			pinctrl-names = "default";
>  			pinctrl-0 = <&pinctrl_rgb24_vga1>;
>  			status = "okay";
>  
> +			port {
> +				display0_in: endpoint {
> +					remote-endpoint = <&ipu_di0_disp0>;
> +				};
> +			};
> +

I shouldn't apply this until I rebase my branch on 3.15-rc1 where
Philipp's OF graph is to be seen, right?

Shawn

>  			display-timings {
>  				VGA {
>  					clock-frequency = <25200000>;
> -- 
> 1.7.10.4
> 
> 
> 

