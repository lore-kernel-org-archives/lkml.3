Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbaFKP67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:58:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58911 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbaFKP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:58:57 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.57.59]
In-Reply-To: <1402464739-19044-3-git-send-email-tushar.b@samsung.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-3-git-send-email-tushar.b@samsung.com>
Date: Wed, 11 Jun 2014 17:58:55 +0200
Message-ID: <CABxcv=kX07pNCd-YPYp6J8S5hHzG1rsoer1YRfdPE0g-xFqZnQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        mturquette@linaro.org, t.figa@samsung.com,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, dianders@google.com,
        trblinux@gmail.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 7:32 AM, Tushar Behera <tushar.b@samsung.com> wrote:
> Currently CLK_FOUT_EPLL was set as one of the parents of AUDSS mux.
> As per the user manual, it should be CLK_MAU_EPLL.
>
> The problem surfaced when the bootloader in Peach-pit board set
> the EPLL clock as the parent of AUDSS mux. While booting the kernel,
> we used to get a system hang during late boot if CLK_MAU_EPLL was
> disabled.
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Reported-by: Kevin Hilman <khilman@linaro.org>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index e385322..79e9119 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -167,7 +167,7 @@
>                 compatible = "samsung,exynos5420-audss-clock";
>                 reg = <0x03810000 0x0C>;
>                 #clock-cells = <1>;
> -               clocks = <&clock CLK_FIN_PLL>, <&clock CLK_FOUT_EPLL>,
> +               clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MAU_EPLL>,
>                          <&clock CLK_SCLK_MAUDIO0>, <&clock CLK_SCLK_MAUPCM0>;
>                 clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
>         };
> --
> 1.7.9.5
>
> --

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
