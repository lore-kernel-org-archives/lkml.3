Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaDWIRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:17:35 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:59407 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaDWIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <1398210681-22976-1-git-send-email-dianders@chromium.org>
References: <1398210681-22976-1-git-send-email-dianders@chromium.org>
Date: Wed, 23 Apr 2014 10:17:30 +0200
Message-ID: <CAPDyKFpzPCi2Yb_33akh5dg1NjudydLkJrdGnQ_xJtsEGGcQ3g@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Don't print data errors
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, yuvaraj.cd@samsung.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-samsung-soc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 01:51, Doug Anderson <dianders@chromium.org> wrote:
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

The "status" here could be useful information about the status
register, which is not considered while printing errors by the "higher
levels". An option could be to print the error, but not when you
perform tuning.

No big deal though, just a thought.

>                 /*
>                  * After an error, there may be data lingering
> --
> 1.9.1.423.g4596e3a
>

Kind regards
Ulf Hansson
