Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaGKIYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:24:33 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34847 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaGKIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:24:31 -0400
Date: Fri, 11 Jul 2014 09:24:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: host: st-hcd: Add st-hcd devicetree bindings
 documentation.
Message-ID: <20140711082425.GJ11948@lee--X1>
References: <1405005486-26355-1-git-send-email-peter.griffin@linaro.org>
 <1405005486-26355-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405005486-26355-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Peter Griffin wrote:

> This patch documents the device tree documentation required for
> the ST HCD controller found in STMicroelectronics SoCs.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  Documentation/devicetree/bindings/usb/st-hcd.txt | 51 ++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/st-hcd.txt

Just some nits:

> +Example:
> +
> +usb0: usb@fe100000 {
> +	compatible	= "st,usb-300x";
> +	reg		= <0xfe1ffc00 0x100>,
> +			  <0xfe1ffe00 0x100>;
> +	reg-names	= "ohci", "ehci";
> +
> +	interrupts	=  <GIC_SPI 148 IRQ_TYPE_NONE>,
> +			   <GIC_SPI 149 IRQ_TYPE_NONE>;
> +	interrupt-names	= "ehci","ohci";

s/","/", "

> +	pinctrl-names	= "default";
> +	pinctrl-0	= <&pinctrl_usb0>;
> +	clocks		= <&clk_s_a1_ls CLK_ICN_IF_2>,
> +			  <&clockgen_b0 0>;
> +	clock-names	= "ic", "ohci";
> +
> +	resets		= <&powerdown STIH416_USB0_POWERDOWN>,
> +			  <&softreset STIH416_USB0_SOFTRESET>;
> +	reset-names	= "power", "softreset";
> +
> +	phys = <&usb2_phy>;
> +	phy-names = "usb2-phy";

Tabbing of the '='s not consistent.

> +};
> +
> +

Too many '\n' at EOF.

Nothing controversial here, so once this nits are rectified:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
