Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbAULmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:42:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25207 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbAULmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:42:07 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-94-54bf908a383f
Message-id: <54BF9083.5090708@samsung.com>
Date: Wed, 21 Jan 2015 12:41:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inha Song <ideal.song@samsung.com>
Cc: kgene@kernel.org, linux-samsung-soc@vger.kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: exynos5422-odroidxu3: add sound nodes
References: <1421819923-27575-1-git-send-email-ideal.song@samsung.com>
In-reply-to: <1421819923-27575-1-git-send-email-ideal.song@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xa7pdE/aHGExZa24x/8g5Vov+NwtZ
	LXb9vc9oce7VSkaL/sevmS02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYtO49wu7A
	47Fm3hpGj5bmHjaPy329TB4rl39h89i0qpPNY/OSeo++LasYPT5vkgvgiOKySUnNySxLLdK3
	S+DKaHj1jKngEF/FszdHWBoYb3J3MXJySAiYSKw9N5kJwhaTuHBvPVsXIxeHkMBSRol1D96w
	QDifGCU23DwGlOHg4BXQklizMBCkgUVAVaJ54nEWEJtNwFCi92gfI4gtKhAhcfLuHnYQm1dA
	UOLH5HtgNSICahIz7vQygcxkFljBJDFn9xywBmEBF4meZ1fZQGwhATeJzytXgDVwCrhLTNnU
	yQqyl1lAT+L+RS2QMLOAvMTmNW+ZJzAKzEKyYhZC1SwkVQsYmVcxiqaWJhcUJ6XnGuoVJ+YW
	l+al6yXn525ihMTLlx2Mi49ZHWIU4GBU4uGtCN0fIsSaWFZcmXuIUYKDWUmE90kBUIg3JbGy
	KrUoP76oNCe1+BAjEwenVAMj8151O0+Z1Wd0FMzOv7A6JGi/9ePEqsTZzd1qwsZ+dSfY122x
	E8qeu8f008W707YcV5zx1rbDeFLTcs0r2prmEjFX1D1rHtitmKSqn7X6edm73k9/unnNr3bU
	NRdvDsrgX9LPWun3c0uS3bJpy22/p/1oSHl+UU/R3u/KYZ8zM0Q6Px7+fsZdiaU4I9FQi7mo
	OBEAl90DlHUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/01/15 06:58, Inha Song wrote:
> Add MAX98090 audio codec, I2S interface and the sound nodes to support
> audio on Odroid-XU3 board.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 34 ++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> index 7874da2..79493d1 100644
> --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> @@ -310,6 +310,40 @@
>  	rtc@101E0000 {
>  		status = "okay";
>  	};
> +
> +	sound: sound {
> +		compatible = "samsung,odroidu3-audio";

How about using simple-card instead ? I've been trying to switch
Odroid X2/U3 to simple card. Here a corresponding dts patch:
http://www.spinics.net/lists/linux-samsung-soc/msg41083.html
For that recent patches for the I2S driver which area already in -next
might be needed.

> +		samsung,model = "Odroid-XU3";
> +		samsung,i2s-controller = <&i2s0>;
> +		samsung,audio-codec = <&max98090>;
> +		assigned-clocks = <&clock_audss EXYNOS_MOUT_AUDSS>,
> +				  <&clock_audss EXYNOS_MOUT_I2S>;
> +		assigned-clock-parents = <&clock CLK_FIN_PLL>,
> +				<&clock_audss EXYNOS_MOUT_AUDSS>;
> +		samsung,audio-routing =
> +			"Headphone Jack", "HPL",
> +			"Headphone Jack", "HPR",
> +			"Headphone Jack", "MICBIAS",
> +			"IN1", "Headphone Jack",
> +			"Speakers", "SPKL",
> +			"Speakers", "SPKR";
> +	};
> +};
> +
> +&hsi2c_5 {
> +	status = "okay";
> +	max98090: max98090@10 {
> +		compatible = "maxim,max98090";
> +		reg = <0x10>;
> +		interrupt-parent = <&gpx3>;
> +		interrupts = <2 0>;
> +		clocks = <&clock_audss EXYNOS_DOUT_AUD_BUS>;
> +		clock-names = "mclk";
> +	};
> +};

-- 
Thanks,
Sylwester
