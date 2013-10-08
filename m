Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3JHDFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:05:44 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62954 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JHDFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <1380207292-16968-4-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
	<1380207292-16968-4-git-send-email-ulf.hansson@linaro.org>
Date: Tue, 8 Oct 2013 11:05:40 +0800
Message-ID: <CAJxxZ0MjV+6TkfQbWTg+crpux=XRFYWGmdc73ouruNGWVZkeLQ@mail.gmail.com>
Subject: Re: [PATCH 03/27] mmc: bfin_sdh: Move away from using deprecated APIs
From: Sonic Zhang <sonic.adi@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Sonic Zhang <sonic.zhang@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

On Thu, Sep 26, 2013 at 10:54 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> Suspend and resume of cards are being handled from the protocol layer
> and consequently the mmc_suspend|resume_host APIs are deprecated.
>
> This means we can simplify the suspend|resume callbacks by removing the
> use of the deprecated APIs.
>
> Cc: Sonic Zhang <sonic.zhang@analog.com>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/bfin_sdh.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
> index 94fae2f..bc9110f 100644
> --- a/drivers/mmc/host/bfin_sdh.c
> +++ b/drivers/mmc/host/bfin_sdh.c
> @@ -640,21 +640,15 @@ static int sdh_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  static int sdh_suspend(struct platform_device *dev, pm_message_t state)
>  {
> -       struct mmc_host *mmc = platform_get_drvdata(dev);
>         struct bfin_sd_host *drv_data = get_sdh_data(dev);
> -       int ret = 0;
> -
> -       if (mmc)
> -               ret = mmc_suspend_host(mmc);
>
>         peripheral_free_list(drv_data->pin_req);
>
> -       return ret;
> +       return 0;
>  }
>
>  static int sdh_resume(struct platform_device *dev)
>  {
> -       struct mmc_host *mmc = platform_get_drvdata(dev);
>         struct bfin_sd_host *drv_data = get_sdh_data(dev);
>         int ret = 0;
>
> @@ -665,10 +659,6 @@ static int sdh_resume(struct platform_device *dev)
>         }
>
>         sdh_reset();
> -
> -       if (mmc)
> -               ret = mmc_resume_host(mmc);
> -
>         return ret;
>  }
>  #else
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
