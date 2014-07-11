Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaGKV6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:58:16 -0400
Received: from mout.gmx.net ([212.227.15.18]:53644 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaGKV6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:58:14 -0400
Message-ID: <53C05DD8.9050500@gmx.de>
Date: Fri, 11 Jul 2014 23:57:44 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Jonathan Cameron <jic23@kernel.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?B?ImVkZGllKOiUoeaeqyki?= <cf@rock-chips.com>,
        huangtao@rock-chips.com
Subject: Re: [PATCH 2/2] dt-bindings: document Rockchip saradc
References: <2959154.xc8BQActsn@diego> <3591595.sBj6Zqo42A@diego>
In-Reply-To: <3591595.sBj6Zqo42A@diego>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:jcKCIOPJtf1LmUk3JBzUBnHx1e1l9YwSgpKGNNeSA7RZnFCIHRR
 RYy/8C1De+9BnKD3qUmpufJRnMUrjoCoihFmPdrG63n+g0ub+u6I6DP/As8aH23lUqvykN8
 57IXXPt8xsmwA+S0SejtTs1cbpltn3i92xNnJEmrKhjFaFhJ58jiW9X/vrPa11+X/7Ewslw
 MHWcRAMmXS+OEaWdC5C1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Stübner schrieb:
> This add the necessary binding documentation for the saradc found in all recent
> processors from Rockchip.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
Spotted some typos, see inline.
>  .../bindings/iio/adc/rockchip-saradc.txt           | 28 ++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
>
> diff --git a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> new file mode 100644
> index 0000000..603ac9c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> @@ -0,0 +1,28 @@
> +Rockhip Successive Approximation Register (SAR) A/D Converter bindings
Should be "Rockchip".
> +
> +Required properties:
> +- compatible: Should be "rockchip,saradc"
> +- reg: physical base address of the controller and length of memory mapped
> +       region.
> +- interrupts: The interrupt number to the cpu. The interrupt specifier format
> +              depends on the interrupt controller.
> +- clocks: Must contain an entry for each entry in clock-names.
> +- clock-names: Shall be "saradc" for the converter-clock, and "apb_pclk" for
> +               the peripheral clock.
> +- vref-supply: The regulator supply ADC refrence voltage.
... reference voltage.
> +- #io-channel-cells: Should be 1, see ../iio-bindings.txt
> +
> +Optional properties :
> +- clock-frequency : converter frequency in Hz. If omitted, 1MHz is used.
> +
> +Example:
> +	saradc: saradc@2006c000 {
> +		compatible = "rockchip,saradc";
> +		reg = <0x2006c000 0x100>;
> +		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru SCLK_SARADC>, <&cru PCLK_SARADC>;
> +		clock-names = "saradc", "apb_pclk";
> +		#io-channel-cells = <1>;
> +		vref-supply = <&vcc18>;
> +		clock-frequency = <1000000>;
> +	};

