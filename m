Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaBRDon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 22:44:43 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:52973
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736AbaBRDol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 22:44:41 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 18 Feb 2014 11:45:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingchang Lu <b35083@freescale.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <arnd@arndb.de>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [PATCH RESEND v11 1/2] ARM: dts: vf610: Add eDMA node
Message-ID: <20140218034546.GE15716@S2101-09.ap.freescale.net>
References: <1392689832-17011-1-git-send-email-b35083@freescale.com>
 <1392689832-17011-2-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392689832-17011-2-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:17:11AM +0800, Jingchang Lu wrote:
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.

Shawn

> ---
> no changes in v10 ~ v11.
> 
> changes in v9:
>  remove include/dt-bindings/dma/vf610-edma.h, the request source ID
>  is the same as SoC's reference manual.
> 
> changes in v8:
>  describe dmamux info in edma node to avoid confusion.
>  change eDMA requst source macro definitions.
> 
>  changes in v7:
>  fix dmamux2 and dmamux3 register number.
> 
>  no changes in v2 ~ v6.
> 
>  arch/arm/boot/dts/vf610.dtsi | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 48dbfe5..8febb29f 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -88,6 +88,21 @@
>  				arm,tag-latency = <2 2 2>;
>  			};
>  
> +			edma0: dma-controller@40018000 {
> +				#dma-cells = <2>;
> +				compatible = "fsl,vf610-edma";
> +				reg = <0x40018000 0x2000>,
> +					<0x40024000 0x1000>,
> +					<0x40025000 0x1000>;
> +				interrupts = <0 8 IRQ_TYPE_LEVEL_HIGH>,
> +						<0 9 IRQ_TYPE_LEVEL_HIGH>;
> +				interrupt-names = "edma-tx", "edma-err";
> +				dma-channels = <32>;
> +				clock-names = "dmamux0", "dmamux1";
> +				clocks = <&clks VF610_CLK_DMAMUX0>,
> +					<&clks VF610_CLK_DMAMUX1>;
> +			};
> +
>  			uart0: serial@40027000 {
>  				compatible = "fsl,vf610-lpuart";
>  				reg = <0x40027000 0x1000>;
> @@ -263,6 +278,21 @@
>  			reg = <0x40080000 0x80000>;
>  			ranges;
>  
> +			edma1: dma-controller@40098000 {
> +				#dma-cells = <2>;
> +				compatible = "fsl,vf610-edma";
> +				reg = <0x40098000 0x2000>,
> +					<0x400a1000 0x1000>,
> +					<0x400a2000 0x1000>;
> +				interrupts = <0 10 IRQ_TYPE_LEVEL_HIGH>,
> +						<0 11 IRQ_TYPE_LEVEL_HIGH>;
> +				interrupt-names = "edma-tx", "edma-err";
> +				dma-channels = <32>;
> +				clock-names = "dmamux0", "dmamux1";
> +				clocks = <&clks VF610_CLK_DMAMUX2>,
> +					<&clks VF610_CLK_DMAMUX3>;
> +			};
> +
>  			uart4: serial@400a9000 {
>  				compatible = "fsl,vf610-lpuart";
>  				reg = <0x400a9000 0x1000>;
> -- 
> 1.8.0
> 
> 

