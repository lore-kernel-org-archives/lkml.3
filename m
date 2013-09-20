Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3ITHfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:35:12 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:56740 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3ITHfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <1379640096-32383-1-git-send-email-grundler@chromium.org>
References: <1379640096-32383-1-git-send-email-grundler@chromium.org>
Date: Fri, 20 Sep 2013 09:35:09 +0200
Message-ID: <CAPDyKFrLpVGp4qmObJ1w2pufDTPQ0ssLRxFpRYHUtMq9Vu9KMA@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: remove dead function mmc_try_claim_host
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 03:21, Grant Grundler <grundler@chromium.org> wrote:
> cscsope says there are no callers for mmc_try_claim_host in the kernel.
> No reason to keep it.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/core/core.c  | 25 -------------------------
>  include/linux/mmc/core.h |  1 -
>  2 files changed, 26 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index bf18b6b..006ead2 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -918,31 +918,6 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
>  EXPORT_SYMBOL(__mmc_claim_host);
>
>  /**
> - *     mmc_try_claim_host - try exclusively to claim a host
> - *     @host: mmc host to claim
> - *
> - *     Returns %1 if the host is claimed, %0 otherwise.
> - */
> -int mmc_try_claim_host(struct mmc_host *host)
> -{
> -       int claimed_host = 0;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&host->lock, flags);
> -       if (!host->claimed || host->claimer == current) {
> -               host->claimed = 1;
> -               host->claimer = current;
> -               host->claim_cnt += 1;
> -               claimed_host = 1;
> -       }
> -       spin_unlock_irqrestore(&host->lock, flags);
> -       if (host->ops->enable && claimed_host && host->claim_cnt == 1)
> -               host->ops->enable(host);
> -       return claimed_host;
> -}
> -EXPORT_SYMBOL(mmc_try_claim_host);
> -
> -/**
>   *     mmc_release_host - release a host
>   *     @host: mmc host to release
>   *
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index da51bec..a00fc49 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -188,7 +188,6 @@ extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
>
>  extern int __mmc_claim_host(struct mmc_host *host, atomic_t *abort);
>  extern void mmc_release_host(struct mmc_host *host);
> -extern int mmc_try_claim_host(struct mmc_host *host);
>
>  extern void mmc_get_card(struct mmc_card *card);
>  extern void mmc_put_card(struct mmc_card *card);
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
