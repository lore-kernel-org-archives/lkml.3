Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbbA0L4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:56:04 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58907 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbbA0L4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
Date: Tue, 27 Jan 2015 12:55:59 +0100
Message-ID: <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:48 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> It's an interesting detail, so inform the user about it.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  drivers/mmc/core/bus.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index 8a1f124..4a60028 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -347,6 +347,10 @@ int mmc_add_card(struct mmc_card *card)
>                         uhs_bus_speed_mode, type, card->rca);
>         }
>
> +       if (mmc_can_secure_erase_trim(card))
> +               pr_info("%s: card supports secure erase/trim\n",
> +                       mmc_hostname(card->host));
> +

Please make this a sysfs attribute.
Exposing such properties as log messages is horrible.

-- 
Thanks,
//richard
