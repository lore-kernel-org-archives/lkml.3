Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3HBFxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:53:23 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50669 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3HBFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <000601ce8f44$299805e0$7cc811a0$@samsung.com>
References: <000601ce8f44$299805e0$7cc811a0$@samsung.com>
Date: Fri, 2 Aug 2013 11:23:20 +0530
Message-ID: <CAK9yfHyiM=jq7MmJoyBd0sn2ESSGZ4T4YvYLU899tOpU2=AZ+A@mail.gmail.com>
Subject: Re: [PATCH] mfd: menelaus: use NULL instead of 0
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2013 11:20, Jingoo Han <jg1.han@samsung.com> wrote:
> 'mmc_callback_data' and 'vtg' are pointers.
> Fix the following sparse warning:
>
> drivers/mfd/menelaus.c:445:43: warning: Using plain integer as NULL pointer
> drivers/mfd/menelaus.c:469:20: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/menelaus.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index 998ce8c..0f62ecd 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -442,7 +442,7 @@ void menelaus_unregister_mmc_callback(void)
>         menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
>
>         the_menelaus->mmc_callback = NULL;
> -       the_menelaus->mmc_callback_data = 0;
> +       the_menelaus->mmc_callback_data = NULL;
>  }
>  EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
>
> @@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
>         struct i2c_client *c = the_menelaus->client;
>
>         mutex_lock(&the_menelaus->lock);
> -       if (vtg == 0)
> +       if (vtg == NULL)

Instead you could just make this:
            if (!vtg)
>                 goto set_voltage;
>


-- 
With warm regards,
Sachin
