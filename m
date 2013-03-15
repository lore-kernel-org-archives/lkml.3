Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3COPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:45:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3COPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <1363207202-10858-4-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-4-git-send-email-dianders@chromium.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 15 Mar 2013 21:15:34 +0530
Message-ID: <CAHfPSqAy5RytMO-jGC9+veNuPw+Qj0K7sV+zQv01xKEm0M9=pg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: Add adc to exynos5250 device tree file
To: Doug Anderson <dianders@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2013 02:10, Doug Anderson <dianders@chromium.org> wrote:
> Add the device tree entry for the device-tree enabled ADC driver that
> recently landed in the iio tree.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I've not used the "clock" binding yet, Will test with that and give a tag.
> ---
> Changes in v2: None
>
>  arch/arm/boot/dts/exynos5250.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 3acf594..1642062 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -69,6 +69,17 @@
>                              <0 28 0>, <0 29 0>, <0 30 0>, <0 31 0>;
>         };
>
> +       adc: adc@12D10000 {
> +               compatible = "samsung,exynos-adc-v1";
> +               reg = <0x12D10000 0x100>, <0x10040718 0x4>;
> +               interrupts = <0 106 0>;
> +               #io-channel-cells = <1>;
> +               io-channel-ranges;
> +
> +               clocks = <&clock 303>;
> +               clock-names = "adc";
> +       };
> +
>         watchdog {
>                 compatible = "samsung,s3c2410-wdt";
>                 reg = <0x101D0000 0x100>;
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
