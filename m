Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaKJKLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:11:39 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36417 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaKJKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:11:37 -0500
Date: Mon, 10 Nov 2014 10:11:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 07/13] ARM: STi: DT: STiH407: Add usb2 picophy dt nodes
Message-ID: <20141110101131.GP21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-8-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-8-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> This patch adds the dt nodes for the usb2 picophy found on the stih407
> family of devices. It is used on stih410 and later devices with the ehci/ohci usb
> controller, and is also used as the usb2 phy with the dwc3 usb3 controller.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stih407.dtsi | 46 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
> index 50637f5..967ec39 100644
> --- a/arch/arm/boot/dts/stih407.dtsi
> +++ b/arch/arm/boot/dts/stih407.dtsi
> @@ -275,5 +275,51 @@
>  
>  			status = "disabled";
>  		};
> +
> +		/* Generic picoPHY */
> +		usb2_picophy0: usbpicophy@0 {
> +			compatible = "st,stih407-usb2-phy";
> +			reg =	<0xf8 0x04>,	/* syscfg 5062 */
> +				<0xf4 0x04>;    /* syscfg 5061 */

Are there really only 2 32bit registers to control this h/w?

> +			reg-names =	"param",
> +					"ctrl";

Superflous indentation after 'reg = ' and 'reg-names = '.

> +			#phy-cells = <0>;
> +
> +			st,syscfg = <&syscfg_core>;
> +			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> +				 <&picophyreset STIH407_PICOPHY0_RESET>;
> +			reset-names = "global",
> +				      "port";

May as well put these on the same line.

> +		};
> +
> +		usb2_picophy1: usbpicophy@1 {
> +			compatible = "st,stih407-usb2-phy";
> +			#phy-cells = <0>;
> +			reg =	<0xfc 0x04>,	/* syscfg 5063 */
> +				<0xf4 0x04>;    /* syscfg 5061 */
> +			reg-names =	"param",
> +					"ctrl";
> +
> +			st,syscfg = <&syscfg_core>;
> +			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> +				 <&picophyreset STIH407_PICOPHY1_RESET>;
> +			reset-names = "global",
> +				      "port";
> +		};
> +
> +		usb2_picophy2: usbpicophy@2 {
> +			compatible = "st,stih407-usb2-phy";
> +			#phy-cells = <0>;
> +			reg =	<0x100 0x04>,	/* syscfg 5064 */
> +				<0xf4 0x04>;    /* syscfg 5061 */
> +			reg-names =	"param",
> +					"ctrl";
> +
> +			st,syscfg = <&syscfg_core>;
> +			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> +				 <&picophyreset STIH407_PICOPHY2_RESET>;
> +			reset-names = "global",
> +				      "port";
> +		};
>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
