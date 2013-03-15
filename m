Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3COKYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:24:47 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62011 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COKYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <1363207202-10858-5-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-5-git-send-email-dianders@chromium.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 15 Mar 2013 15:54:25 +0530
Message-ID: <CAHfPSqDmu52D42qiGM4rT3qeYWu0b5jxOOCNOXLa=1JZH4j9rw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: dts: Add adc and thermistors for exynos5250-snow
To: Doug Anderson <dianders@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On 14 March 2013 02:10, Doug Anderson <dianders@chromium.org> wrote:
> Hook up the exynos5250-snow thermistors via the device tree now that
> there's a driver available to use them.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Match 'uV' -> 'uv' change in Naveen's bindings.
>
>  arch/arm/boot/dts/cros5250-common.dtsi |  4 ++++
>  arch/arm/boot/dts/exynos5250-snow.dts  | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
> index 46c0980..f7cc835 100644
> --- a/arch/arm/boot/dts/cros5250-common.dtsi
> +++ b/arch/arm/boot/dts/cros5250-common.dtsi
> @@ -167,6 +167,10 @@
>                 status = "disabled";
>         };
>
> +       adc@12D10000 {
> +               vdd-supply = <&buck5_reg>;
> +       };
> +
>         hdmi {
>                 hpd-gpio = <&gpx3 7 0xf 1 3>;
>         };
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index 17dd951..b78da7c 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -40,4 +40,35 @@
>                                 <&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
>                 };
>         };
> +
> +       adc@12D10000 {
> +               ncp15wb473@3 {
> +                       compatible = "ntc,ncp15wb473";
> +                       pullup-uv = <1800000>;
> +                       pullup-ohm = <47000>;
> +                       pulldown-ohm = <0>;
> +                       io-channels = <&adc 3>;
> +               };
> +               ncp15wb473@4 {
> +                       compatible = "ntc,ncp15wb473";
> +                       pullup-uv = <1800000>;
> +                       pullup-ohm = <47000>;
> +                       pulldown-ohm = <0>;
> +                       io-channels = <&adc 4>;
> +               };
> +               ncp15wb473@5 {
> +                       compatible = "ntc,ncp15wb473";
> +                       pullup-uv = <1800000>;
> +                       pullup-ohm = <47000>;
> +                       pulldown-ohm = <0>;
> +                       io-channels = <&adc 5>;
> +               };
> +               ncp15wb473@6 {
> +                       compatible = "ntc,ncp15wb473";
> +                       pullup-uv = <1800000>;
> +                       pullup-ohm = <47000>;
> +                       pulldown-ohm = <0>;
> +                       io-channels = <&adc 6>;
> +               };
> +       };
>  };
Thanks for the upload, i've tested with a similar changes.
> --
> 1.8.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Shine bright,
(: Nav :)
