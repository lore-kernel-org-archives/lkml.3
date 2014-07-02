Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaGBIvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:51:11 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34105 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaGBIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:51:08 -0400
Date: Wed, 2 Jul 2014 09:51:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: STi: STiH407: Add reset controller support.
Message-ID: <20140702085102.GF10311@lee--X1>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
 <1404225047-9495-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404225047-9495-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2014, Peter Griffin wrote:

> This patch adds the reset controller DT nodes for the powerdown,
>  softreset and picophy controllers.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stih407.dtsi | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
> index 4f9024f..e8fbb88 100644
> --- a/arch/arm/boot/dts/stih407.dtsi
> +++ b/arch/arm/boot/dts/stih407.dtsi
> @@ -8,6 +8,7 @@
>   */
>  #include "stih407-clock.dtsi"
>  #include "stih407-pinctrl.dtsi"
> +#include <dt-bindings/reset-controller/stih407-resets.h>
>  / {
>  	#address-cells = <1>;
>  	#size-cells = <1>;
> @@ -63,6 +64,21 @@
>  		ranges;
>  		compatible = "simple-bus";
>  
> +		powerdown: powerdown-controller {
> +			#reset-cells = <1>;
> +			compatible = "st,stih407-powerdown";
> +		};
> +
> +		softreset: softreset-controller {
> +			#reset-cells = <1>;
> +			compatible = "st,stih407-softreset";
> +		};
> +
> +		picophyreset: picophyreset-controller {
> +			#reset-cells = <1>;
> +			compatible = "st,stih407-picophyreset";
> +		};
> +

I'd always put the compatible string at the very top of the node.

>  		syscfg_sbc: sbc-syscfg@9620000 {
>  			compatible = "st,stih407-sbc-syscfg", "syscon";
>  			reg = <0x9620000 0x1000>;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
