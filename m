Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbbA0MXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:23:47 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:27554 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbbA0MUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:07 -0500
X-IronPort-AV: E=Sophos;i="5.09,474,1418112000"; 
   d="scan'208";a="55800223"
Message-ID: <54C78273.7090700@broadcom.com>
Date: Tue, 27 Jan 2015 13:20:03 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/15 12:48, Alexander Holler wrote:
> It's an interesting detail, so inform the user about it.
>
> Signed-off-by: Alexander Holler<holler@ahsoftware.de>
> ---
>   drivers/mmc/core/bus.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index 8a1f124..4a60028 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -347,6 +347,10 @@ int mmc_add_card(struct mmc_card *card)
>   			uhs_bus_speed_mode, type, card->rca);
>   	}
>
> +	if (mmc_can_secure_erase_trim(card))
> +		pr_info("%s: card supports secure erase/trim\n",
> +			mmc_hostname(card->host));
> +

If you want to expose this info you could also consider doing it in the 
debugfs folder that is created below.

>   #ifdef CONFIG_DEBUG_FS
>   	mmc_add_card_debugfs(card);
>   #endif

Regards,
Arend

[1] http://lxr.free-electrons.com/ident?i=mmc_add_card_debugfs
