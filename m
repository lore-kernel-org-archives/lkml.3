Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaDWEJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:09:19 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:44601 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaDWEJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <1398210681-22976-1-git-send-email-dianders@chromium.org>
References: <1398210681-22976-1-git-send-email-dianders@chromium.org>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 23 Apr 2014 09:32:36 +0530
Message-ID: <CAGOxZ52ChD+KExT75Zz5e4j7=fN5bt1py6C04V+czHOfv0tYNQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Don't print data errors
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        chris@printf.net, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Wed, Apr 23, 2014 at 5:21 AM, Doug Anderson <dianders@chromium.org> wrote:
> Data errors are completely expected during tuning.  Printing them out
> is confusing people looking at the kernel logs.  They see things like:
>
>  [    3.613296] dwmmc_exynos 12200000.dwmmc0: data error, status 0x00000088
>
> ...and they think something is wrong with their hardware.
>
> Remove the printouts.  We'll leave it up to a higher level to report
> about errors.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

This looks reasonable
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
>  drivers/mmc/host/dw_mmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index cced599..4c8d423 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1248,7 +1248,7 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>                         data->error = -EIO;
>                 }
>
> -               dev_err(host->dev, "data error, status 0x%08x\n", status);
> +               dev_dbg(host->dev, "data error, status 0x%08x\n", status);
>
>                 /*
>                  * After an error, there may be data lingering
> --
> 1.9.1.423.g4596e3a
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
