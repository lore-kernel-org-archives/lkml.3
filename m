Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaGKBsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:48:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:17168 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGKBr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:47:59 -0400
Message-ID: <53BF4246.2070706@atmel.com>
Date: Fri, 11 Jul 2014 09:47:50 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        "Pawel Moll" <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] ARM: at91/dt: describe rgmii ethernet phy connected
 to sama5d3xek boards
References: <1405022394-8311-1-git-send-email-boris.brezillon@free-electrons.com> <1405022394-8311-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1405022394-8311-2-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 07/11/2014 03:59 AM, Boris BREZILLON wrote:
> Add ethernet-phy nodes and specify phy interrupt (connected to pin PB25)
> and board specific timing configs.
>
> Atmel has two different HW designs for its CPU modules: the first one
> (produced by Embest) is connecting PHYAD[0-2] pins to pull up resistors
> and the other one (produced by Ronetix) is connecting PHYAD0 to a pull up
> resistor and PHYAD[1-2] to pull down resistors.
> As a result, Ronetix design will have its PHY available at address 0x1 and
> Embest design at 0x7.
> By defining both phys we're letting the phy core detect the one actually
> available on the MDIO bus.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

For this patch series, test OK on both Embest (sama5d34ek) and Ronetix 
(sama5d33ek).

Tested-by: Bo Shen <voice.shen@atmel.com>

> ---
>
> Florian, I dropped your Reviewed-by tag because this patch has slightly
> changed.
>
>
>   arch/arm/boot/dts/sama5d3xcm.dtsi | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index b0b1331..755369e 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -34,6 +34,36 @@
>
>   			macb0: ethernet@f0028000 {
>   				phy-mode = "rgmii";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				ethernet-phy@1 {
> +					reg = <0x1>;
> +					interrupt-parent = <&pioB>;
> +					interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
> +					txen-skew-ps = <800>;
> +					txc-skew-ps = <3000>;
> +					rxdv-skew-ps = <400>;
> +					rxc-skew-ps = <3000>;
> +					rxd0-skew-ps = <400>;
> +					rxd1-skew-ps = <400>;
> +					rxd2-skew-ps = <400>;
> +					rxd3-skew-ps = <400>;
> +				};
> +
> +				ethernet-phy@7 {
> +					reg = <0x7>;
> +					interrupt-parent = <&pioB>;
> +					interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
> +					txen-skew-ps = <800>;
> +					txc-skew-ps = <3000>;
> +					rxdv-skew-ps = <400>;
> +					rxc-skew-ps = <3000>;
> +					rxd0-skew-ps = <400>;
> +					rxd1-skew-ps = <400>;
> +					rxd2-skew-ps = <400>;
> +					rxd3-skew-ps = <400>;
> +				};
>   			};
>
>   			pmc: pmc@fffffc00 {
>

Best Regards,
Bo Shen

