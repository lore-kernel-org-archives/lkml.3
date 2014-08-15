Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaHOOrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:47:21 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57278 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:47:20 -0400
Message-ID: <53EE1D73.6030006@cogentembedded.com>
Date: Fri, 15 Aug 2014 18:47:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
CC: lee.jones@linaro.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 3/5] usb: host: ehci-st: Add ehci-st devicetree bindings
 documentation
References: <1408111410-14375-1-git-send-email-peter.griffin@linaro.org> <1408111410-14375-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1408111410-14375-4-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/15/2014 06:03 PM, Peter Griffin wrote:

> This patch documents the device tree bindings required for the
> ehci on-chip controller found in ST consumer electronics SoC's.

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>   Documentation/devicetree/bindings/usb/ehci-st.txt | 39 +++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/usb/ehci-st.txt

> diff --git a/Documentation/devicetree/bindings/usb/ehci-st.txt b/Documentation/devicetree/bindings/usb/ehci-st.txt
> new file mode 100644
> index 0000000..fb45fa5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ehci-st.txt
> @@ -0,0 +1,39 @@
> +ST USB EHCI controller
> +
> +Required properties:
> + - compatible		: must be "st,st-ehci-300x"
> + - reg			: physical base addresses of the controller and length of memory mapped
> +			  region
> + - interrupts		: one EHCI interrupt should be described here
> + - pinctrl-names	: a pinctrl state named "default" must be defined
> + - pinctrl-0		: phandle referencing pin configuration of the USB controller
> +See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> + - clocks		: phandle list of usb clocks
> + - clock-names		: should be "ic" for interconnect clock and "clk48"

    This sentence seems unfinished?

> +See: Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> + - phys			: phandle for the PHY device
> + - phy-names		: should be "usb"
> + - resets		: phandle + reset specifier pairs to the powerdown and softreset lines
> +			  of the USB IP
> + - reset-names		: should be "power" and "softreset"
> +See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
> +See: Documentation/devicetree/bindings/reset/reset.txt
> +
> +Example:
> +
> +	ehci1: usb@0xfe203e00 {
> +		compatible = "st,st-ehci-300x";
> +		reg = <0xfe203e00 0x100>;
> +		interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_usb1>;
> +		clocks = <&clk_s_a1_ls 0>;

    You said that "clock-names" is a required prop but you didn't specify it.

> +		phys = <&usb2_phy>;
> +		phy-names = "usb";
> +		status = "okay";

    Not necessary.

> +
> +		resets = <&powerdown STIH416_USB1_POWERDOWN>,
> +			 <&softreset STIH416_USB1_SOFTRESET>;
> +		reset-names = "power", "softreset";
> +	};

WBR, Sergei

