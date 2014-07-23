Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaGWU5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:57:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:35225 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189AbaGWU5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:57:15 -0400
Message-ID: <53D02238.40001@kernel.org>
Date: Wed, 23 Jul 2014 21:59:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv8 4/4] ARM: dts: Fix wrong compatible string for Exynos3250
 ADC
References: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com> <1405994696-3117-5-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1405994696-3117-5-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 03:04, Chanwoo Choi wrote:
> This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
> need to control only special clock for ADC. Exynos SoC except for Exynos3250
> has not included special clock for ADC. The exynos ADC driver can control
> special clock if compatible string is 'exynos3250-adc-v2'.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
Applied to the togreg branch of iio.git - initially pushed out as testing.

Thanks

Jonathan
> ---
>   arch/arm/boot/dts/exynos3250.dtsi | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 15c9c87..767189a 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -407,10 +407,11 @@
>   		};
>
>   		adc: adc@126C0000 {
> -			compatible = "samsung,exynos-adc-v3";
> +			compatible = "samsung,exynos3250-adc",
> +				     "samsung,exynos-adc-v2";
>   			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>   			interrupts = <0 137 0>;
> -			clock-names = "adc", "sclk_tsadc";
> +			clock-names = "adc", "sclk";
>   			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>   			#io-channel-cells = <1>;
>   			io-channel-ranges;
>

