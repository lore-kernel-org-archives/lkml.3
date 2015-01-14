Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbbANIxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:53:36 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:52393 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbbANIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:34 -0500
MIME-Version: 1.0
In-Reply-To: <1421216652-348-1-git-send-email-tim.kryger@gmail.com>
References: <1421216652-348-1-git-send-email-tim.kryger@gmail.com>
Date: Wed, 14 Jan 2015 09:53:33 +0100
Message-ID: <CAPDyKFpM_iqteu5pP03-iD2pji6ypeZJ1TA=LON1FVjJWrJk-g@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: Set SDHCI_POWER_ON with external vmmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Chris Ball <chris@printf.net>, Alexandre Courbot <gnurou@gmail.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Linux MMC List <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-mmc

On 14 January 2015 at 07:24, Tim Kryger <tim.kryger@gmail.com> wrote:
> Host controllers lacking the required internal vmmc regulator may still
> follow the spec with regard to the LSB of SDHCI_POWER_CONTROL.  Set the
> SDHCI_POWER_ON bit when vmmc is enabled to encourage the controller to
> to drive CMD, DAT, SDCLK.
>
> This fixes a regression observed on some Qualcomm and Nvidia boards
> caused by 5222161 mmc: sdhci: Improve external VDD regulator support.
>
> Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
> Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Thanks! Applied for fixes.

I noticed this wasn't posted to linux-mmc. I am anyway picking it up
as this change has already been discussed and tested, see:
https://lkml.org/lkml/2014/11/3/1029

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ada1a3e..59a328a 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1239,6 +1239,12 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
>                 spin_unlock_irq(&host->lock);
>                 mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
>                 spin_lock_irq(&host->lock);
> +
> +               if (mode != MMC_POWER_OFF)
> +                       sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
> +               else
> +                       sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
> +
>                 return;
>         }
>
> --
> 1.9.1
>
