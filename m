Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaJNMDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:03:38 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43516 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaJNMDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <1413000976-2038-1-git-send-email-dianders@chromium.org>
References: <1413000976-2038-1-git-send-email-dianders@chromium.org>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Tue, 14 Oct 2014 17:32:56 +0530
Message-ID: <CAGOxZ51vPf7wR8FccbCjv=08Zjs_mNCj7CiWBE_j6qr7ZHSD9Q@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Change signal voltage error to dev_dbg()
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Sat, Oct 11, 2014 at 9:46 AM, Doug Anderson <dianders@chromium.org> wrote:
> In (28f92b5 mmc: core: Try other signal levels during power up) we can
> see that there are times when it's valid to try several signal
> voltages.  Don't print an ugly error in the logs when that happens.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..c4afbdd 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1075,7 +1075,7 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>                 ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
>
>                 if (ret) {
> -                       dev_err(&mmc->class_dev,
> +                       dev_dbg(&mmc->class_dev,
>                                          "Regulator set error %d: %d - %d\n",
>                                          ret, min_uv, max_uv);
>                         return ret;
Well, I am ok with this but this info is very useful, what if PMIC
failed to actually set the voltage? may be because of some PMIC driver
bug or i2c driver bug? Ofcourse this can be found by turning MMC_DEBUG
ON, but is that worth in this case. Or is there a way to print that,
this failure is because of a regulator re-try?
your thoughts?
> --
> 2.1.0.rc2.206.gedb03e5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
