Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3C1Cyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:54:44 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:36146
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744Ab3C1Cym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:54:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 28 Mar 2013 10:54:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v9 RESEND 4/4] ARM: dts: add sram for imx53 and imx6q
Message-ID: <20130328025422.GH5429@S2101-09.ap.freescale.net>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
 <1363776767-2635-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363776767-2635-5-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:52:47AM +0100, Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> Changes since v8:
>  - Changed device tree compatible string to "mmio-sram"
> ---
>  arch/arm/boot/dts/imx53.dtsi |    5 +++++
>  arch/arm/boot/dts/imx6q.dtsi |    6 ++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> index edc3f1e..69d0680 100644
> --- a/arch/arm/boot/dts/imx53.dtsi
> +++ b/arch/arm/boot/dts/imx53.dtsi
> @@ -664,5 +664,10 @@
>  				status = "disabled";
>  			};
>  		};
> +
> +		ocram: ocram@f8000000 {
> +			compatible = "fsl,imx-ocram", "mmio-sram";

We should probably just drop "fsl,imx-ocram".

Shawn

> +			reg = <0xf8000000 0x20000>;
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index ff1205e..73302db 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -124,6 +124,12 @@
>  			status = "disabled";
>  		};
>  
> +		ocram: ocram@00900000 {
> +			compatible = "fsl,imx-ocram", "mmio-sram";
> +			reg = <0x00900000 0x3f000>;
> +			clocks = <&clks 142>;
> +		};
> +
>  		timer@00a00600 {
>  			compatible = "arm,cortex-a9-twd-timer";
>  			reg = <0x00a00600 0x20>;
> -- 
> 1.7.10.4
> 

