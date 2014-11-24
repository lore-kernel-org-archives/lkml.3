Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaKXTgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:36:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaKXTgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:36:14 -0500
Date: Mon, 24 Nov 2014 11:36:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH]  tty: serial: msm_serial: document DT alias
Message-ID: <20141124193613.GA10106@kroah.com>
References: <54667D13.2070105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54667D13.2070105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 02:07:15PM -0800, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> Update devicetree binding for msm_serial to reflect msm_serial_probe()
> getting line id (port number) from the serialN alias.
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
>  Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt |   15 +++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> Index: linux/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
> ===================================================================
> --- linux.orig/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
> +++ linux/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
> @@ -27,27 +27,52 @@ Optional properties:
>  - dmas: Should contain dma specifiers for transmit and receive channels
>  - dma-names: Should contain "tx" for transmit and "rx" for receive channels
>  
> +Note: Aliases may be defined to ensure the correct ordering of the UARTs.
> +The alias serialN will result in the UART being assigned port N.  If any
> +serialN alias exists, then an alias must exist for each enabled UART.  The
> +serialN aliases should be in a .dts file instead of in a .dtsi file.
> +
>  Examples:
>  
> -A uartdm v1.4 device with dma capabilities.
> +- A uartdm v1.4 device with dma capabilities.
> +
> +	serial@f991e000 {
> +		compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
> +		reg = <0xf991e000 0x1000>;
> +		interrupts = <0 108 0x0>;
> +		clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
> +		clock-names = "core", "iface";
> +		dmas = <&dma0 0>, <&dma0 1>;
> +		dma-names = "tx", "rx";
> +	};
> +
> +- A uartdm v1.3 device without dma capabilities and part of a GSBI complex.
> +
> +	serial@19c40000 {
> +		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
> +		reg = <0x19c40000 0x1000>,
> +		<0x19c00000 0x1000>;
> +		interrupts = <0 195 0x0>;
> +		clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
> +		clock-names = "core", "iface";
> +	};
> +
> +- serialN alias.
> +
> +	aliases {
> +		serial0 = &uarta;
> +		serial1 = &uartc;
> +		serial2 = &uartb;
> +	};
> +
> +	uarta: serial@12490000 {
> +		status = "ok";
> +	};
> +
> +	uartb: serial@16340000 {
> +		status = "ok";
> +	};
>  
> -serial@f991e000 {
> -	compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
> -	reg = <0xf991e000 0x1000>;
> -	interrupts = <0 108 0x0>;
> -	clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
> -	clock-names = "core", "iface";
> -	dmas = <&dma0 0>, <&dma0 1>;
> -	dma-names = "tx", "rx";
> -};
> -
> -A uartdm v1.3 device without dma capabilities and part of a GSBI complex.
> -
> -serial@19c40000 {
> -	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
> -	reg = <0x19c40000 0x1000>,
> -	      <0x19c00000 0x1000>;
> -	interrupts = <0 195 0x0>;
> -	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
> -	clock-names = "core", "iface";
> -};
> +	uartc: serial@1a240000 {
> +		status = "ok";
> +	};

Git complained about a whitespace issue in this patch, which I fixed up
by hand.  Please be more careful...

thanks,

greg k-h
