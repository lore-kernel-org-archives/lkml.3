Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaIXJYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:24:00 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:34826 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIXJXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <1411549634-28683-2-git-send-email-rogerable@realtek.com>
References: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
	<1411549634-28683-2-git-send-email-rogerable@realtek.com>
Date: Wed, 24 Sep 2014 11:23:54 +0200
Message-ID: <CAPDyKFqO-FCD1CMy4KitjWUtNg=__Vvmv4JmC6S0182iB-ONsQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: Add new power_mode MMC_POWER_UNDEFINED
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei WANG <wei_wang@realsil.com.cn>, micky <micky_ching@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 11:07, Roger Tseng <rogerable@realtek.com> wrote:
> Define new macro MMC_POWER_UNDEFINED for power_mode in struct mmc_ios.
> It will also be set as the initial value of host->ios.power_mode in
> mmc_start_host().
>
> For hosts with MMC_CAP2_NO_PRESCAN_POWERUP, this makes the later
> mmc_power_off() do real power-off things instead of NOP, and further
> prevents state messed up in cards that was already initialized(eg. by
> BIOS of UEFI driver).
>
> Signed-off-by: Roger Tseng <rogerable@realtek.com>

Thanks! Applied for next!

I changes some minor parts of the commit message and set the author of
the patch to "Roger Tseng <rogerable@realtek.com>" instead of
"<rogerable@realtek.com>". Please fix that in for future patches.

Kind regards
Uffe

> ---
>  drivers/mmc/core/core.c  |    1 +
>  include/linux/mmc/host.h |    1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d03a080fb9cd..7dad1a1adf18 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2489,6 +2489,7 @@ void mmc_start_host(struct mmc_host *host)
>  {
>         host->f_init = max(freqs[0], host->f_min);
>         host->rescan_disable = 0;
> +       host->ios.power_mode = MMC_POWER_UNDEFINED;
>         if (host->caps2 & MMC_CAP2_NO_PRESCAN_POWERUP)
>                 mmc_power_off(host);
>         else
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 7960424d0bc0..b3bfa609816a 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -42,6 +42,7 @@ struct mmc_ios {
>  #define MMC_POWER_OFF          0
>  #define MMC_POWER_UP           1
>  #define MMC_POWER_ON           2
> +#define MMC_POWER_UNDEFINED    3
>
>         unsigned char   bus_width;              /* data bus width */
>
> --
> 1.7.10.4
>
