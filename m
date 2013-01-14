Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3ANO0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:26:44 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:48988 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3ANO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:26:43 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
References: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
Date: Mon, 14 Jan 2013 23:26:41 +0900
X-Google-Sender-Auth: aC1lrRYTPNqo96z6UuSVg8vQ8O0
Message-ID: <CAJ0PZbRG4OVckLo=rNy+nxBjQJ1Lz6=obKMECEVbhvEk0w9OJg@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: EXYNOS5: Add PPMU device tree support
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 9:06 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> PPMU is required by the devfreq driver. Add a device tree
> node for it.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Jonghwan Choi <jhbird.choi@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  .../bindings/arm/exynos/ppmu-exynos5.txt           |   28 ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250.dtsi                  |    9 ++++++
>  2 files changed, 37 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt b/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt
> new file mode 100644
> index 0000000..a424dfa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt
> @@ -0,0 +1,28 @@
> +Exynos5 PPMU driver
> +-------------------
> +
> +Performance events are primitive values used to get performance data. These
> +events provide information about the behavior of the SoC that can be used
> +when analyzing system performance. These events are made visible using the
> +PPMU logic.
> +Exynos5 PPMU driver is used by the exynos5 devfreq driver to control the bus
> +frequency/voltage.
> +
> +Required properties:
> +- compatible: should be one of the following.
> +       * samsung,exynos5-ppmu - for exynos5250 type ppmu.
> +- reg:
> +       * physical base address of the PPMUs (DDR, Right Bus and CPU) and
> +       length of memory mapped region.
> +
> +Example:
> +--------
> +
> +       ppmu {
> +               compatible = "samsung,exynos5250-ppmu";
> +               reg = <0x10C40000 0x2000
> +                      0x10C50000 0x2000
> +                      0x10C60000 0x2000
> +                      0x10CB0000 0x2000
> +                      0x13660000 0x2000>;
> +       };
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 30485de..d504cba 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -732,4 +732,13 @@
>                 interrupt-parent = <&combiner>;
>                 interrupts = <24 1>;
>         };
> +
> +       ppmu {
> +               compatible = "samsung,exynos5250-ppmu";
> +               reg = <0x10C40000 0x2000        /* PPMU_DDR_C */
> +                      0x10C50000 0x2000        /* PPMU_DDR_R1 */
> +                      0x10CB0000 0x2000        /* PPMU_DDR_L */
> +                      0x13660000 0x2000        /* PPMU_DDR_RIGHT */
> +                      0x10C60000 0x2000>;      /* PPMU_DDR_CPU */
> +       };
>  };
> --
> 1.7.8.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
