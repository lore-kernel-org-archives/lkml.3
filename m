Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab3ARGKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:10:45 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:62566 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3ARGKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <1358486792.14373.14.camel@dhruva>
References: <1358486792.14373.14.camel@dhruva>
Date: Fri, 18 Jan 2013 01:10:40 -0500
Message-ID: <CAHdPZaPqAHcM8BsApRUm8mqtum67RSUA+gDWgjuhwc6VXNozwA@mail.gmail.com>
Subject: Re: [patch v1 4/5] rtc: da9055 change irq state to default
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:26 AM, Ashish Jangam
<ashish.jangam@kpitcummins.com> wrote:
> This patch changes the irq state from high to the now default low
> state.
>

will you please provide more info on why do we need to set it to low state?


> This patch is dependent on the DA9055 MFD.
>
> This patch is tested on smdk6410 board.
>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/rtc/rtc-da9055.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
> index 8f0dcfe..918b16b 100644
> --- a/drivers/rtc/rtc-da9055.c
> +++ b/drivers/rtc/rtc-da9055.c
> @@ -305,7 +305,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
>         alm_irq = regmap_irq_get_virq(rtc->da9055->irq_data, alm_irq);
>         ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
>                                         da9055_rtc_alm_irq,
> -                                       IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +                                       IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>                                         "ALM", rtc);
>         if (ret != 0)
>                 dev_err(rtc->da9055->dev, "irq registration failed: %d\n", ret);
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
