Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaEWHEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:04:15 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35424 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaEWHEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:04:13 -0400
MIME-Version: 1.0
In-Reply-To: <1400774136-12396-2-git-send-email-abrestic@chromium.org>
References: <1400774136-12396-1-git-send-email-abrestic@chromium.org>
	<1400774136-12396-2-git-send-email-abrestic@chromium.org>
Date: Fri, 23 May 2014 09:04:12 +0200
Message-ID: <CAPDyKFqBcp7PZQ-04s02Jrqscna0UVex2DEbVPYghmRR8g9HnA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mmc: tegra: fix reporting of base clock frequency
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Chris Ball <chris@printf.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 17:55, Andrew Bresticker <abrestic@chromium.org> wrote:
> Tegra SDHCI controllers, by default, report a base clock frequency
> of 208Mhz in SDHCI_CAPABILTIES which may or may not be equal to the
> actual base clock frequency.  This is because the clock rate is
> configured by the clock controller, which is external to the SD/MMC
> controller.  Since the SD/MMC controller has no knowledge of how this
> clock is configured, it will simply report the maximum frequency.
> While the reported value can be overridden by setting BASE_CLK_FREQ in
> VENDOR_CLOCK_CTRL on Tegra30 and later SoCs, just set CAP_CLOCK_BASE_BROKEN
> and supply sdhci_pltfm_clk_get_max_clock(), which simply does a
> clk_get_rate(), as the get_max_clock() callback.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks Andrew!

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Chris, can you pick this up?

Kind regards
Ulf Hansson

> ---
> Changes from v2:
>  - rebased on mmc-next
> Changes from v1:
>  - fixed up commit message per Stephen's suggestions
> ---
>  drivers/mmc/host/sdhci-tegra.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 4375cd4..d93a063 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -154,13 +154,15 @@ static const struct sdhci_ops tegra_sdhci_ops = {
>         .set_bus_width = tegra_sdhci_set_bus_width,
>         .reset      = tegra_sdhci_reset,
>         .set_uhs_signaling = sdhci_set_uhs_signaling,
> +       .get_max_clock = sdhci_pltfm_clk_get_max_clock,
>  };
>
>  static const struct sdhci_pltfm_data sdhci_tegra20_pdata = {
>         .quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
>                   SDHCI_QUIRK_SINGLE_POWER_WRITE |
>                   SDHCI_QUIRK_NO_HISPD_BIT |
> -                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
> +                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
> +                 SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>         .ops  = &tegra_sdhci_ops,
>  };
>
> @@ -175,7 +177,8 @@ static const struct sdhci_pltfm_data sdhci_tegra30_pdata = {
>                   SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
>                   SDHCI_QUIRK_SINGLE_POWER_WRITE |
>                   SDHCI_QUIRK_NO_HISPD_BIT |
> -                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
> +                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
> +                 SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>         .ops  = &tegra_sdhci_ops,
>  };
>
> @@ -191,7 +194,8 @@ static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
>                   SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
>                   SDHCI_QUIRK_SINGLE_POWER_WRITE |
>                   SDHCI_QUIRK_NO_HISPD_BIT |
> -                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC,
> +                 SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
> +                 SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>         .ops  = &tegra_sdhci_ops,
>  };
>
> --
> 1.9.1.423.g4596e3a
>
