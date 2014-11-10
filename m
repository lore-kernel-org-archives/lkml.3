Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaKJLnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:43:32 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:52077 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKJLna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <1415321293-17521-1-git-send-email-wenyou.yang@atmel.com>
References: <1415321293-17521-1-git-send-email-wenyou.yang@atmel.com>
Date: Mon, 10 Nov 2014 12:43:29 +0100
Message-ID: <CAPDyKFp6wXqP1x0uO12=mgrCsjvx4vfkr9cCJVAtjkFQ7s=q2A@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: atmel-mci: adopt pinctrl support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: Chris Ball <chris@printf.net>, Kevin Hilman <khilman@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 01:48, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> Amend the atmel mci pin controller to optionally take a pin control
> handle and set the state of the pins to:
> - "default" on boot, resume and before performing an transfer.
> - "sleep" on suspend().
>
> This should make it possible to optimize energy usage for the pins
> both for the suspend/resume cycle.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
> Hi Ulf,
>
> Thanks a lot.
>
> According to your advice, remove pinctrl_pm_select_default_state(&pdev->dev) from the _probe function.
>
> Best Regards,
> Wenyou Yang
>
>  drivers/mmc/host/atmel-mci.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 4df1599..a7b59ba 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -39,6 +39,7 @@
>  #include <linux/atmel_pdc.h>
>  #include <linux/pm.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/io.h>
> @@ -2568,6 +2569,8 @@ static int atmci_runtime_suspend(struct device *dev)
>
>         clk_disable_unprepare(host->mck);
>
> +       pinctrl_pm_select_sleep_state(dev);
> +
>         return 0;
>  }
>
> @@ -2575,6 +2578,8 @@ static int atmci_runtime_resume(struct device *dev)
>  {
>         struct atmel_mci *host = dev_get_drvdata(dev);
>
> +       pinctrl_pm_select_default_state(dev);
> +
>         return clk_prepare_enable(host->mck);
>  }
>  #endif
> --
> 1.7.9.5
>
