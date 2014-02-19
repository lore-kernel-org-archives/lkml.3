Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaBSHGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:06:53 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:45236
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbaBSHGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:06:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579eh551biz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 19 Feb 2014 15:06:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: dts: Enable SAI ALSA SoC DAI device for Vybrid
 VF610 TOWER board.
Message-ID: <20140219070630.GE3010@S2101-09.ap.freescale.net>
References: <1392788323-6092-1-git-send-email-Li.Xiubo@freescale.com>
 <1392788323-6092-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392788323-6092-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:38:41PM +0800, Xiubo Li wrote:
> This patch adds and enables the SAI device.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/boot/dts/vf610-twr.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
> index e3a3805..8217854 100644
> --- a/arch/arm/boot/dts/vf610-twr.dts
> +++ b/arch/arm/boot/dts/vf610-twr.dts
> @@ -127,9 +127,27 @@
>  				VF610_PAD_PTB5__UART1_RX		0x21a1
>  			>;
>  		};
> +
> +		pinctrl_sai2: sai2grp {

To sort it alphabetically, the entry should be added before
pinctrl_uart1.

> +		      fsl,pins = <
> +			      VF610_PAD_PTA16__SAI2_TX_BCLK   0x02ed
> +			      VF610_PAD_PTA18__SAI2_TX_DATA   0x02ee
> +			      VF610_PAD_PTA19__SAI2_TX_SYNC   0x02ed
> +			      VF610_PAD_PTA21__SAI2_RX_BCLK   0x02ed
> +			      VF610_PAD_PTA22__SAI2_RX_DATA   0x02ed
> +			      VF610_PAD_PTA23__SAI2_RX_SYNC   0x02ed
> +			      VF610_PAD_PTB18__EXT_AUDIO_MCLK 0x02ed

Use tabs instead of spaces.

Shawn

> +			>;
> +		};
>  	};
>  };
>  
> +&sai2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_sai2>;
> +	status = "okay";
> +};
> +
>  &uart1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_uart1>;
> -- 
> 1.8.4
> 
> 

