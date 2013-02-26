Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3BZOCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:02:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14997 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3BZOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:02:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Feb 2013 05:56:55 -0800
Message-ID: <512CC021.4060201@nvidia.com>
Date: Tue, 26 Feb 2013 19:31:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: is_palmas_charger needed by multiple drivers
References: <1361884572-27606-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361884572-27606-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2013 06:46 PM, Ian Lartey wrote:
> is_palmas_charger checks for the presence of charging
> functionality in the device
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
>   include/linux/mfd/palmas.h |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 3129f9a..98c0567 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -26,6 +26,11 @@
>   /* The ID_REVISION NUMBERS */
>   #define PALMAS_CHIP_OLD_ID		0x0000
>   #define PALMAS_CHIP_ID			0xC035
> +#define PALMAS_CHIP_CHARGER_ID		0xC036
> +
> +#define is_palmas(a)	(((a) == PALMAS_CHIP_OLD_ID) || \
> +			((a) == PALMAS_CHIP_ID))
> +#define is_palmas_charger(a) ((a) == PALMAS_CHIP_CHARGER_ID)
>   

TI says this as TPS80036 and original palma as TPS65913/TPS65914. Not 
sure whether palma_charger is correct or not here.

But above change looks good.

Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
