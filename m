Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbbA1UdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:33:09 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57238 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760101AbbA1UdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:04 -0500
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="55735301"
Message-ID: <54C8EC38.6010702@broadcom.com>
Date: Wed, 28 Jan 2015 15:03:36 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Ulf Hansson <ulf.hansson@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        "Doug Anderson" <dianders@chromium.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: dts: exynos5250-snow: Enable wifi power-on
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-6-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1422439819-29854-6-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/15 11:10, Javier Martinez Canillas wrote:
> The Snow board has a MMC/SDIO wifi chip that is always powered but it
> needs a power sequence involving a reset (active low) and an enable
> (active high) pins. Both pins are marked as active low since the MMC
> simple power sequence driver asserts the pins prior to the card power
> up procedure and de-asserts the pins after the card has been powered.
>
> So the reset line will be left de-asserted and the enable pin will be
> left asserted.
>
> The chip also needs an external 32kHz reference clock to be operational
> that is by the MAX77686 PMIC clock.
>
> Add a simple MMC power sequence provider for the wifi MMC/SDIO slot.
>
> Signed-off-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
> ---
>   arch/arm/boot/dts/exynos5250-snow.dts | 25 ++++++++++++++++++++++++-
>   1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index b9aeec430527..0f7971ba8238 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -229,6 +229,13 @@
>   		power-supply =<&fet6>;
>   		backlight =<&backlight>;
>   	};
> +
> +	mmc3_pwrseq: mmc3_pwrseq {
> +		reset-gpios =<&gpx0 2 GPIO_ACTIVE_LOW>, /* WIFI_RSTn */
> +			<&gpx0 1 GPIO_ACTIVE_LOW>; /* WIFI_EN */
> +		clocks =<&max77686 MAX77686_CLK_PMIC>;
> +		clock-names = "ext_clock";
> +	};
>   };
>
>   &dp {
> @@ -531,17 +538,33 @@
>   	status = "okay";
>   	num-slots =<1>;
>   	broken-cd;
> +	cap-sdio-irq;

This seems like an unrelated change, right?

Regards,
Arend

>   	card-detect-delay =<200>;
>   	samsung,dw-mshc-ciu-div =<3>;
>   	samsung,dw-mshc-sdr-timing =<2 3>;
>   	samsung,dw-mshc-ddr-timing =<1 2>;
>   	pinctrl-names = "default";
> -	pinctrl-0 =<&sd3_clk&sd3_cmd&sd3_bus4>;
> +	pinctrl-0 =<&sd3_clk&sd3_cmd&sd3_bus4&wifi_en&wifi_rst>;
>   	bus-width =<4>;
>   	cap-sd-highspeed;
> +	mmc-pwrseq =<&mmc3_pwrseq>;
>   };
>
>   &pinctrl_0 {
> +	wifi_en: wifi-en {
> +		samsung,pins = "gpx0-1";
> +		samsung,pin-function =<1>;
> +		samsung,pin-pud =<0>;
> +		samsung,pin-drv =<0>;
> +	};
> +
> +	wifi_rst: wifi-rst {
> +		samsung,pins = "gpx0-2";
> +		samsung,pin-function =<1>;
> +		samsung,pin-pud =<0>;
> +		samsung,pin-drv =<0>;
> +	};
> +
>   	power_key_irq: power-key-irq {
>   		samsung,pins = "gpx1-3";
>   		samsung,pin-function =<0xf>;

