Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaBJK0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:26:42 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44131 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaBJK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:26:38 -0500
MIME-Version: 1.0
In-Reply-To: <1392026911-21308-2-git-send-email-t.dakhran@samsung.com>
References: <1392026911-21308-1-git-send-email-t.dakhran@samsung.com>
	<1392026911-21308-2-git-send-email-t.dakhran@samsung.com>
Date: Mon, 10 Feb 2014 15:56:37 +0530
Message-ID: <CAK9yfHzLfVi2S_Qfb_bFE199g0G6J2-y4_9z9m5_jg7+FEzZzQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tarek Dakhran <t.dakhran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

Nothing in specific about the patch, but to just make you aware that
some clean up
patches haves been proposed which might cause conflicts with this patch. Please
see inline for details.

On 10 February 2014 15:38, Tarek Dakhran <t.dakhran@samsung.com> wrote:
> EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
> Add initial support for this SoC.
>
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig                 |   10 ++++++++++
>  arch/arm/mach-exynos/common.c                |   18 ++++++++++++++++++
>  arch/arm/mach-exynos/include/mach/map.h      |    1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c       |    1 +
>  arch/arm/mach-exynos/platsmp.c               |    2 ++
>  arch/arm/plat-samsung/include/plat/cpu.h     |    8 ++++++++
>  arch/arm/plat-samsung/include/plat/map-s5p.h |    3 +++
>  7 files changed, 43 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 4c414af..97a06c3 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -91,6 +91,16 @@ config SOC_EXYNOS5250
>         help
>           Enable EXYNOS5250 SoC support
>
> +config SOC_EXYNOS5410
> +       bool "SAMSUNG EXYNOS5410"
> +       default y
> +       depends on ARCH_EXYNOS5
> +       select PM_GENERIC_DOMAINS if PM
> +       select S5P_PM if PM_SLEEP
> +       select S5P_SLEEP if PM_SLEEP
> +       help
> +         Enable EXYNOS5410 SoC support
> +

Per SoC Kconfig entries are proposed to be removed. Please see [1].

>  config SOC_EXYNOS5420
>         bool "SAMSUNG EXYNOS5420"
>         default y
> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index f18be40..f1483bd 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -52,6 +52,7 @@ static const char name_exynos4210[] = "EXYNOS4210";
>  static const char name_exynos4212[] = "EXYNOS4212";
>  static const char name_exynos4412[] = "EXYNOS4412";
>  static const char name_exynos5250[] = "EXYNOS5250";
> +static const char name_exynos5410[] = "EXYNOS5410";
>  static const char name_exynos5420[] = "EXYNOS5420";
>  static const char name_exynos5440[] = "EXYNOS5440";
>
> @@ -85,6 +86,12 @@ static struct cpu_table cpu_ids[] __initdata = {
>                 .init           = exynos_init,
>                 .name           = name_exynos5250,
>         }, {
> +               .idcode         = EXYNOS5410_SOC_ID,
> +               .idmask         = EXYNOS5_SOC_MASK,
> +               .map_io         = exynos5_map_io,
> +               .init           = exynos_init,
> +               .name           = name_exynos5410,
> +       }, {

This is also proposed to be removed. Please see [2].

[1] http://comments.gmane.org/gmane.linux.kernel.samsung-soc/26800
[2] http://comments.gmane.org/gmane.linux.kernel.samsung-soc/26560

-- 
With warm regards,
Sachin
