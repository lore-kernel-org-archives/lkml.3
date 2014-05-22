Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaEVP7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:59:53 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41333 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaEVP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:59:50 -0400
Date: Thu, 22 May 2014 16:59:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 3/8] ARM: STi: DT: Add sdhci pins for stih416
Message-ID: <20140522155943.GH19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Peter Griffin wrote:

> This adds the required pin config for both SDHCI controllers on
> the stih416 SoC.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  arch/arm/boot/dts/stih416-pinctrl.dtsi | 39 ++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> index 6252188..140af6b 100644
> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> @@ -467,6 +467,45 @@
>  					};
>  				};
>  			};
> +
> +			mmc0 {
> +				pinctrl_mmc0: mmc0 {
> +					st,pins {
> +						mmcclk = <&PIO13 4 ALT4 BIDIR_PU NICLK 0 CLK_B>;
> +						data0 = <&PIO14 4 ALT4 BIDIR_PU BYPASS 0>;
> +						data1 = <&PIO14 5 ALT4 BIDIR_PU BYPASS 0>;
> +						data2 = <&PIO14 6 ALT4 BIDIR_PU BYPASS 0>;
> +						data3 = <&PIO14 7 ALT4 BIDIR_PU BYPASS 0>;
> +						cmd = <&PIO15 1 ALT4 BIDIR_PU BYPASS 0>;
> +						wp = <&PIO15 3 ALT4 IN>;
> +						data4 = <&PIO16 4 ALT4 BIDIR_PU BYPASS 0>;
> +						data5 = <&PIO16 5 ALT4 BIDIR_PU BYPASS 0>;
> +						data6 = <&PIO16 6 ALT4 BIDIR_PU BYPASS 0>;
> +						data7 = <&PIO16 7 ALT4 BIDIR_PU BYPASS 0>;
> +						pwr = <&PIO17 1 ALT4 OUT>;
> +						cd = <&PIO17 2 ALT4 IN>;
> +						led = <&PIO17 3 ALT4 OUT>;
> +					};
> +				};
> +			};
> +			mmc1 {
> +				pinctrl_mmc1: mmc1 {
> +					st,pins {
> +						mmcclk = <&PIO15 0 ALT3 BIDIR_PU NICLK 0 CLK_B>;
> +						data0 = <&PIO13 7 ALT3 BIDIR_PU BYPASS 0>;
> +						data1 = <&PIO14 1 ALT3 BIDIR_PU BYPASS 0>;
> +						data2 = <&PIO14 2 ALT3 BIDIR_PU BYPASS 0>;
> +						data3 = <&PIO14 3 ALT3 BIDIR_PU BYPASS 0>;
> +						cmd = <&PIO15 4 ALT3 BIDIR_PU BYPASS 0>;
> +						data4 = <&PIO15 6 ALT3 BIDIR_PU BYPASS 0>;
> +						data5 = <&PIO15 7 ALT3 BIDIR_PU BYPASS 0>;
> +						data6 = <&PIO16 0 ALT3 BIDIR_PU BYPASS 0>;
> +						data7 = <&PIO16 1 ALT3 BIDIR_PU BYPASS 0>;
> +						pwr = <&PIO16 2 ALT3 OUT>;
> +						nreset = <&PIO13 6 ALT3 OUT>;
> +					};
> +				};
> +			};
>  		};
>  
>  		pin-controller-fvdp-fe {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
