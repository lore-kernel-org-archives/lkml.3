Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaEVP5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:57:12 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:39852 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaEVP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:57:10 -0400
Date: Thu, 22 May 2014 16:57:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 5/8] ARM: STi: DT: Add sdhci pin configuration for stih415
Message-ID: <20140522155703.GF19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-6-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-6-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds the required pin config for the sdhci controller
> present in the stih415 SoC.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

Switch these round - same with all the other patches.

> ---
>  arch/arm/boot/dts/stih415-pinctrl.dtsi | 21 +++++++++++++++++++++
>  arch/arm/boot/dts/stih415.dtsi         | 12 ++++++++++++
>  2 files changed, 33 insertions(+)

[...]

> diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
> index d6f254f..6579b1d 100644
> --- a/arch/arm/boot/dts/stih415.dtsi
> +++ b/arch/arm/boot/dts/stih415.dtsi
> @@ -218,5 +218,17 @@
>  			resets	= <&powerdown STIH415_KEYSCAN_POWERDOWN>,
>  				  <&softreset STIH415_KEYSCAN_SOFTRESET>;
>  		};
> +
> +		mmc0: sdhci@fe81e000 {
> +			compatible = "st,sdhci";
> +			status = "disabled";
> +			reg = <0xfe81e000 0x1000>;
> +			interrupts = <GIC_SPI 145 IRQ_TYPE_NONE>;
> +			interrupt-names = "mmcirq";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_mmc0>;
> +			clock-names = "mmc";
> +			clocks = <&clk_s_a1_ls 1>;

Nit: These would be easier to read if the '='s were lined up (using tabs).

> +		};
>  	};
>  };

Apart from that:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
