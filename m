Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaGGLBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:01:04 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58989 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGGLBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:01:01 -0400
Date: Mon, 7 Jul 2014 12:00:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: Re: [PATCH v2 2/3] ARM: dts: sti: Add st-dwc3 devicetree bindings
 documentation
Message-ID: <20140707110055.GF6407@lee--X1>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404541530-27856-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject is wrong, this has nothing to do with ARM.  Should be USB.

On Sat, 05 Jul 2014, Peter Griffin wrote:
> This patch documents the device tree documentation required for
> the ST usb3 controller glue layer found in STiH407 devices.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  Documentation/devicetree/bindings/usb/dwc3-st.txt | 58 +++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/dwc3-st.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/dwc3-st.txt b/Documentation/devicetree/bindings/usb/dwc3-st.txt
> new file mode 100644
> index 0000000..befd964
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/dwc3-st.txt
> @@ -0,0 +1,58 @@
> +ST DWC3 glue logic
> +
> +This file documents the parameters for the dwc3-st driver.

Does this line really add anything to do the document, considering the
name and location of the file and the title above?

> +This driver provides the glue logic to use the dwc3 on STiH407 based platforms.

s/This driver/The DWC2 driver/

> +Required properties:
> + - compatible	: must be "st,stih407-dwc3"
> + - reg		: glue logic base address and USB syscfg ctrl register offset
> + - reg-names	: should be "reg-glue" and "syscfg-reg"

Any reason why you have reg-* and *-reg?  If  you have to put 'reg' in
the name, it's usually appended, rather than prefixed.

> + - st,syscon	: should be phandle to system configuration node which
> +		  encompasses the glue registers
> + - resets	: phandle pointing to the system powerdown controller
> +See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
> +See: Documentation/devicetree/bindings/reset/reset.txt
> +
> + - #address-cells, #size-cells : should be '1' if the device has sub-nodes
> +                                 with 'reg' property
> +
> + - pinctl-names	: A pinctrl state named "default" must be defined
> +See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> +
> + - pinctrl-0	: Pin control group
> +See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> +
> + - ranges	: allows valid 1:1 translation between child's address space and
> +		  parent's address space
> +
> +Optional properties:
> + - st,dwc3-drd-device: to program the HC as "device" (static setup)

This will require a DT Ack.

> +Sub-nodes:
> +The dwc3 core should be added as subnode to ST DWC3 glue as shown in the
> +example below. The DT binding details of dwc3 can be found in:
> +Documentation/devicetree/bindings/usb/dwc3.txt
> +
> +Example:
> +
> +st_dwc3: dwc3@8f94000 {
> +	status		= "disabled";

Probably not good to disable the node in the example.

> +	compatible	= "st,stih407-dwc3";
> +	reg		= <0x08f94000 0x1000>, <0x110 0x4>;
> +	reg-names	= "reg-glue", "syscfg-reg";
> +	st,syscfg	= <&syscfg_core>;
> +	resets          = <&powerdown STIH407_USB3_POWERDOWN>;
> +	#address-cells	= <1>;
> +	#size-cells	= <1>;
> +	pinctrl-names	= "default";
> +	pinctrl-0	= <&pinctrl_usb3>;
> +	ranges;
> +
> +	dwc3: dwc3@9900000 {
> +		compatible	= "synopsys,dwc3";
> +		reg		= <0x09900000 0x100000>;
> +		interrupts	=  <GIC_SPI 155 IRQ_TYPE_NONE>;
> +
> +		usb-phy = <&usb2_phy>, <&usb3_phy>;
> +	};
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
