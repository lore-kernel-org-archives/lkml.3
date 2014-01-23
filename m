Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaAWKUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:20:38 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35228 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAWKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com> <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 Jan 2014 15:50:15 +0530
Message-ID: <CAHfPSqBToWsPTTdU8KzxCkO6xpcHLQpDeaVZBfn=nxLe2NiRhg@mail.gmail.com>
Subject: Re: [PATCH 5/8 v4] clk: samsung: exynos5250/5420: Add gate clock for
 SSS module
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 15 January 2014 14:46, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250/5420.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> TO: Tomasz Figa <t.figa@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
> 2. Added new ID for SSS clock on Exynos5250, with Documentation and
> 3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250
>
>  .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
>  drivers/clk/samsung/clk-exynos5250.c               |    1 +
>  drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
>  include/dt-bindings/clock/exynos5250.h             |    1 +
>  4 files changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> index 492ed09..a845fc6 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> @@ -162,6 +162,7 @@ clock which they consume.
>    g2d                  345
>    mdma0                        346
>    smmu_mdma0           347
> +  sss                  348
>
>
>     [Clock Muxes]
> diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
> index ff4beeb..2c52fe1 100644
> --- a/drivers/clk/samsung/clk-exynos5250.c
> +++ b/drivers/clk/samsung/clk-exynos5250.c
> @@ -387,6 +387,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>          * CMU_ACP
>          */
>         GATE(CLK_MDMA0, "mdma0", "div_aclk266", GATE_IP_ACP, 1, 0, 0),
> +       GATE(CLK_SSS, "sss", "div_aclk266", GATE_IP_ACP, 2, 0, 0),
>         GATE(CLK_G2D, "g2d", "div_aclk200", GATE_IP_ACP, 3, 0, 0),
>         GATE(CLK_SMMU_MDMA0, "smmu_mdma0", "div_aclk266", GATE_IP_ACP, 5, 0, 0),
>
> diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
> index ab4f2f7..94915bb 100644
> --- a/drivers/clk/samsung/clk-exynos5420.c
> +++ b/drivers/clk/samsung/clk-exynos5420.c
> @@ -26,6 +26,7 @@
>  #define DIV_CPU1               0x504
>  #define GATE_BUS_CPU           0x700
>  #define GATE_SCLK_CPU          0x800
> +#define GATE_BUS_G2D           0x8700
>  #define CPLL_LOCK              0x10020
>  #define DPLL_LOCK              0x10030
>  #define EPLL_LOCK              0x10040
> @@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
>                 0),
>         GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
>                 0),
> +
> +       /* SSS */
> +       GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_BUS_G2D, 2, 0, 0),
>  };
>
>  static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
> diff --git a/include/dt-bindings/clock/exynos5250.h b/include/dt-bindings/clock/exynos5250.h
> index 922f2dc..f9b452b 100644
> --- a/include/dt-bindings/clock/exynos5250.h
> +++ b/include/dt-bindings/clock/exynos5250.h
> @@ -150,6 +150,7 @@
>  #define CLK_G2D                        345
>  #define CLK_MDMA0              346
>  #define CLK_SMMU_MDMA0         347
> +#define CLK_SSS                        348
>
>  /* mux clocks */
>  #define CLK_MOUT_HDMI          1024
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
