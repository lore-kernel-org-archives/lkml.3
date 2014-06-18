Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146AbaFRIhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:37:25 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63624 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998AbaFRIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:37:21 -0400
Message-ID: <53A14FAC.3050700@gmail.com>
Date: Wed, 18 Jun 2014 10:37:00 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, t.figa@samsung.com, kgene.kim@samsung.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 4/4] ARM: dts: Fix wrong compatible string for Exynos3250
 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com> <1403058061-24271-5-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1403058061-24271-5-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 18.06.2014 04:21, Chanwoo Choi wrote:
> This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
> need to control only special clock for ADC. Exynos SoC except for Exynos3250
> has not included special clock for ADC. The exynos ADC driver can control
> special clock if compatible string is 'exynos3250-adc-v2'.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 6c1fb67..107dc44 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -414,10 +414,10 @@
>  		};
>  
>  		adc: adc@126C0000 {
> -			compatible = "samsung,exynos-adc-v3";
> +			compatible = "samsung,exynos3250-adc-v2";
>  			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>  			interrupts = <0 137 0>;
> -			clock-names = "adc", "sclk_tsadc";
> +			clock-names = "adc", "sclk_adc";

So, is it "sclk_adc" or "sclk_tsadc"? The code uses the former, while
the documentation mentions the latter. Please fix this.

Best regards,
Tomasz
