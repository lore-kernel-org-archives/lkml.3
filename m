Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaHAUd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:33:27 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50490 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaHAUdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-6-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-6-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 13:33:23 -0700
X-Google-Sender-Auth: 2j8iuo4QzTxhPDxYe9LupQmV4JM
Message-ID: <CAD=FV=WhocoyQ=rU7dU1EPM-PAQq06gg9HhamSOm+BgMDeM8NA@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] ARM: dts: Move dp_hpd from exynos5250 into
 smdk5250 and snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> Spring uses a different GPIO, so this is not a generic SoC piece.
>
> Suggested-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v5: New (Tomasz Figa)
>  Frees dp_hpd for Spring.
>
>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 7 -------
>  arch/arm/boot/dts/exynos5250-smdk5250.dts | 9 +++++++++
>  arch/arm/boot/dts/exynos5250-snow.dts     | 7 +++++++
>  3 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> index 886cfca044ac..ed0e5230514b 100644
> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> @@ -581,13 +581,6 @@
>                         samsung,pin-pud = <0>;
>                         samsung,pin-drv = <0>;
>                 };
> -
> -               dp_hpd: dp_hpd {
> -                       samsung,pins = "gpx0-7";
> -                       samsung,pin-function = <3>;
> -                       samsung,pin-pud = <0>;
> -                       samsung,pin-drv = <0>;
> -               };
>         };
>
>         pinctrl@13400000 {
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index aaa055ac0fe3..5d30fe1dcda4 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -414,3 +414,12 @@
>                 };
>         };
>  };
> +
> +&pinctrl_0 {
> +       dp_hpd: dp_hpd {
> +               samsung,pins = "gpx0-7";
> +               samsung,pin-function = <3>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +};
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index c4b0c73c736d..a9a2f2743794 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -547,6 +547,13 @@
>  };
>
>  &pinctrl_0 {
> +       dp_hpd: dp_hpd {
> +               samsung,pins = "gpx0-7";
> +               samsung,pin-function = <3>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +

NAK.  dp_hpd is a generic SoC piece.  Pin function 0 and 1 are GPIOs.
Pin function 3 is special function.  This pin _is_ the hot plug detect
pin for display port.  When it's set as special function 3 it goes
straight into the hot plug logic of the display port controller.

Spring may have had its reasons to detect hot plug events on a GPIO
instead of using this pin, but that doesn't make this pin any less the
"hot plug pin".

-Doug
