Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaDPJAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:00:12 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:25887
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbaDPJAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:00:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 16 Apr 2014 16:59:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <b35083@freescale.com>,
        <r64188@freescale.com>, <b40534@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module
 timer node.
Message-ID: <20140416085953.GC11602@dragon>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:19:45AM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Jingchang Lu <b35083@freescale.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 107e2c0..c3a276f 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -153,6 +153,19 @@
>  				clock-names = "pit";
>  			};
>  
> +			ftm0: ftm@40038000 {
> +				compatible = "fsl,vf610-ftm-timer";
> +				reg = <0x40038000 0x2000>;
> +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "ftm0", "ftm1",
> +					"ftm0_counter_en", "ftm1_counter_en";
> +				clocks = <&clks VF610_CLK_FTM0>,
> +					<&clks VF610_CLK_FTM1>,
> +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> +				status = "disabled";

For such completely internal block which has no pins route out on board,
we should probably just not have this "disabled" status line.

Shawn

> +			};
> +
>  			wdog@4003e000 {
>  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
>  				reg = <0x4003e000 0x1000>;
> -- 
> 1.8.4
> 
> 

