Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaCXCpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:45:34 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:37149
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbaCXCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:45:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Mon, 24 Mar 2014 10:45:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: vf610: Add Freescale FTM PWM node.
Message-ID: <20140324023900.GA4002@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1395292325-8497-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 01:12:03PM +0800, Xiubo Li wrote:
> This adds devicetree node for VF610, and there are 8 channels
> supported.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Yuan Yao <yao.yuan@freescale.com>

Please copy list linux-arm-kernel instead of linux-kernel on arch/arm/
changes, and also be noted that my email and git addresses just got
updated [1].

> ---
>  arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index acf544e..ccc6d35 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -192,6 +192,19 @@
>  				status = "disabled";
>  			};
>  
> +			pwm0: pwm@40038000 {

The node should be sorted in unit-address.  So shouldn't it be put right
after pit node?

Shawn

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f1c12837220c54c8d7138a4ee4a08c1ec67b68a2

> +				compatible = "fsl,vf610-ftm-pwm";
> +				#pwm-cells = <3>;
> +				reg = <0x40038000 0x1000>;
> +				clock-names = "ftm_sys", "ftm_ext",
> +					      "ftm_fix", "ftm_cnt_clk_en";
> +				clocks = <&clks VF610_CLK_FTM0>,
> +					<&clks VF610_CLK_FTM0_EXT_SEL>,
> +					<&clks VF610_CLK_FTM0_FIX_SEL>,
> +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>;
> +				status = "disabled";
> +			};
> +
>  			wdog@4003e000 {
>  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
>  				reg = <0x4003e000 0x1000>;
> -- 
> 1.8.4
> 
> 

