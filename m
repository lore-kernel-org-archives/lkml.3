Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaDVI2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:28:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58388 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaDVI2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
References: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
Date: Tue, 22 Apr 2014 10:28:35 +0200
Message-ID: <CAPDyKFoMOJ_Eb3O5B-Sy-fF0Yx7Mp==3-Wyff=rTVNCO3YxCFg@mail.gmail.com>
Subject: Re: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Fariya Fatima <fariyaf@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 08:57, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> As commit 3957848(mmc: drop the speed mode of card's state) applies,
> this change should be followed.
>
> drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use in this function)
> drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
> drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>

Hi Seungwon,

Thanks for responding quickly!

> ---
>  drivers/net/wireless/rsi/rsi_91x_sdio.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> index 2e39d38..46e7af4 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> @@ -285,7 +285,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
>                 if (err) {
>                         rsi_dbg(ERR_ZONE, "%s: CCCR speed reg read failed: %d\n",
>                                 __func__, err);
> -                       card->state &= ~MMC_STATE_HIGHSPEED;
>                 } else {
>                         err = rsi_cmd52writebyte(card,
>                                                  SDIO_CCCR_SPEED,
> @@ -296,14 +295,13 @@ static void rsi_reset_card(struct sdio_func *pfunction)
>                                         __func__, err);
>                                 return;
>                         }
> -                       mmc_card_set_highspeed(card);
>                         host->ios.timing = MMC_TIMING_SD_HS;
>                         host->ops->set_ios(host, &host->ios);
>                 }
>         }
>
>         /* Set clock */
> -       if (mmc_card_highspeed(card))
> +       if (mmc_card_hs(card))
>                 clock = 50000000;
>         else
>                 clock = card->cis.max_dtr;
> --
> 1.7.0.4
>
>

I am not sure it's safe to carry this patch through Chris' mmc tree
due to merge conflicts with John's wireless tree.

Though, since you have changed the mmc_card_highspeed() function to be
named to mmc_card_hs(), we need to work out the dependency.

We have some options to handle this, I suggest the following.

Re-spin this patch to keep using mmc_card_highspeed() and let John
take it through his wireless tree. Thus  you also need to keep the
name mmc_card_highspeed() function from the patches to the mmc core -
could you please re-spin and post new version of those patches as
well!?

Kind regards
Ulf Hansson
