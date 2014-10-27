Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaJ0OPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:15:45 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50730 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaJ0OPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:15:42 -0400
MIME-Version: 1.0
In-Reply-To: <1413000976-2038-1-git-send-email-dianders@chromium.org>
References: <1413000976-2038-1-git-send-email-dianders@chromium.org>
Date: Mon, 27 Oct 2014 15:15:41 +0100
Message-ID: <CAPDyKFr1DVqgNXzV4z5pJVr2Kn_Szzv+TU+95CScxS-L_bxh_A@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Change signal voltage error to dev_dbg()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <chris@printf.net>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 October 2014 06:16, Doug Anderson <dianders@chromium.org> wrote:
> In (28f92b5 mmc: core: Try other signal levels during power up) we can
> see that there are times when it's valid to try several signal
> voltages.  Don't print an ugly error in the logs when that happens.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Thanks! Applied for next!

Kind regards
Uffe

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
> --
> 2.1.0.rc2.206.gedb03e5
>
