Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaJ1Ql3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:41:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33989 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaJ1Ql1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <1411997137-13034-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1411997137-13034-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 28 Oct 2014 22:11:24 +0530
Message-ID: <CAMf-jSn7=AkQqWCHuNyXg7aEUq6WAE6S+Vr-s8+ye0TQqFbxfw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: Fix Sparse warning of duplicate
 set_uhs_signaling entry
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

Is this good to go?

On Mon, Sep 29, 2014 at 6:55 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> This fixes below sparse warning:
> drivers/mmc/host/sdhci-pxav3.c:227:10: warning: Initializer entry defined twice
> drivers/mmc/host/sdhci-pxav3.c:232:10:   also defined here
>
> by removing duplicate initialization of .set_uhs_signaling in
> struct sdhci_ops. Also does away with duplcated function.
>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Chris Ball <chris@printf.net>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/mmc/host/sdhci-pxav3.c |   37 -------------------------------------
>  1 file changed, 37 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 6f842fb..fd93e60 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -186,45 +186,8 @@ static void pxav3_gen_init_74_clocks(struct sdhci_host *host, u8 power_mode)
>         pxa->power_mode = power_mode;
>  }
>
> -static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
> -{
> -       u16 ctrl_2;
> -
> -       /*
> -        * Set V18_EN -- UHS modes do not work without this.
> -        * does not change signaling voltage
> -        */
> -       ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
> -
> -       /* Select Bus Speed Mode for host */
> -       ctrl_2 &= ~SDHCI_CTRL_UHS_MASK;
> -       switch (uhs) {
> -       case MMC_TIMING_UHS_SDR12:
> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
> -               break;
> -       case MMC_TIMING_UHS_SDR25:
> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
> -               break;
> -       case MMC_TIMING_UHS_SDR50:
> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR50 | SDHCI_CTRL_VDD_180;
> -               break;
> -       case MMC_TIMING_UHS_SDR104:
> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR104 | SDHCI_CTRL_VDD_180;
> -               break;
> -       case MMC_TIMING_UHS_DDR50:
> -               ctrl_2 |= SDHCI_CTRL_UHS_DDR50 | SDHCI_CTRL_VDD_180;
> -               break;
> -       }
> -
> -       sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
> -       dev_dbg(mmc_dev(host->mmc),
> -               "%s uhs = %d, ctrl_2 = %04X\n",
> -               __func__, uhs, ctrl_2);
> -}
> -
>  static const struct sdhci_ops pxav3_sdhci_ops = {
>         .set_clock = sdhci_set_clock,
> -       .set_uhs_signaling = pxav3_set_uhs_signaling,
>         .platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
>         .get_max_clock = sdhci_pltfm_clk_get_max_clock,
>         .set_bus_width = sdhci_set_bus_width,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
