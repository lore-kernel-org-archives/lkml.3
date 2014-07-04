Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaGDIG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:06:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46381 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaGDIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:06:19 -0400
Message-ID: <53B66066.4030202@gmail.com>
Date: Fri, 04 Jul 2014 10:05:58 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux@arm.linux.org.uk,
        kgene.kim@samsung.com, t.figa@samsung.com
CC: kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
References: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 03.07.2014 09:52, Chanwoo Choi wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
> (1 channels) IIS-bus for audio interface with DMA-based operation.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Tested-by: Inha Song <ideal.song@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 1f8384f..e9017ef 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -644,6 +644,19 @@
>  			status = "disabled";
>  		};
>  
> +		i2s: i2s@13970000 {

Shouldn't the label be rather called "i2s2" as the pinctrl entry below
suggests?

> +			compatible = "samsung,s3c6410-i2s";
> +			reg = <0x13970000 0x100>;
> +			interrupts = <0 126 0>;
> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
> +			clock-names = "iis", "i2s_opclk0";
> +			dmas = <&pdma0 14>, <&pdma0 13>;
> +			dma-names = "tx", "rx";
> +			pinctrl-0 = <&i2s2_bus>;
> +			pinctrl-name = "default";

"pinctrl-name" is not a valid property. I suppose it should be
"pinctrl-names".

Best regards,
Tomasz
