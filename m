Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaEVP67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:58:59 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52915 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaEVP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:58:57 -0400
Date: Thu, 22 May 2014 16:58:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 4/8] ARM: STi: DT: Add sdhci controller for stih416
Message-ID: <20140522155850.GG19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-5-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-5-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Peter Griffin wrote:

> This patch adds device tree config for both sdhci controllers
> on the stih416 SoC.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  arch/arm/boot/dts/stih416.dtsi | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 06473c5..a035df0 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -236,5 +236,29 @@
>  			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
>  				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
>  		};
> +
> +		mmc0: sdhci@fe81e000 {
> +			compatible = "st,sdhci";
> +			status = "disabled";
> +			reg = <0xfe81e000 0x1000>;
> +			interrupts = <GIC_SPI 127 IRQ_TYPE_NONE>;
> +			interrupt-names = "mmcirq";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_mmc0>;
> +			clock-names     = "mmc";
> +			clocks = <&clk_s_a1_ls 1>;
> +		};
> +
> +		mmc1: sdhci@fe81f000 {
> +			compatible = "st,sdhci";
> +			status = "disabled";
> +			reg = <0xfe81f000 0x1000>;
> +			interrupts = <GIC_SPI 128 IRQ_TYPE_NONE>;
> +			interrupt-names = "mmcirq";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_mmc1>;
> +			clock-names     = "mmc";
> +			clocks = <&clk_s_a1_ls 8>;
> +		};

Line these up and make them look pretty too.

After that:

  Acked-by: Lee Jones <lee.jones@linaro.org>

>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
