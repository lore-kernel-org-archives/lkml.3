Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaFBHMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:12:23 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55926 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBHMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
Date: Mon, 2 Jun 2014 00:12:20 -0700
Message-ID: <CAD7vxxKT+Wq2ArH9iYLm2OUeBSqKvzORKZ1NnoyPcdcDH6wOKw@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
From: Tim Kryger <tim.kryger@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 11:27 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/bcm590xx-regulator.c |   16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index 57544e2..fb8c6f7 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -326,10 +326,8 @@ static struct bcm590xx_board *bcm590xx_parse_dt_reg_data(
>         }
>
>         data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> -       if (!data) {
> -               dev_err(&pdev->dev, "failed to allocate regulator board data\n");
> +       if (!data)
>                 return NULL;
> -       }
>
>         np = of_node_get(np);
>         regulators = of_get_child_by_name(np, "regulators");
> @@ -374,10 +372,8 @@ static int bcm590xx_probe(struct platform_device *pdev)
>                                               &bcm590xx_reg_matches);
>
>         pmu = devm_kzalloc(&pdev->dev, sizeof(*pmu), GFP_KERNEL);
> -       if (!pmu) {
> -               dev_err(&pdev->dev, "Memory allocation failed for pmu\n");
> +       if (!pmu)
>                 return -ENOMEM;
> -       }
>
>         pmu->mfd = bcm590xx;
>
> @@ -385,17 +381,13 @@ static int bcm590xx_probe(struct platform_device *pdev)
>
>         pmu->desc = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
>                         sizeof(struct regulator_desc), GFP_KERNEL);
> -       if (!pmu->desc) {
> -               dev_err(&pdev->dev, "Memory alloc fails for desc\n");
> +       if (!pmu->desc)
>                 return -ENOMEM;
> -       }
>
>         pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
>                         sizeof(struct bcm590xx_info *), GFP_KERNEL);
> -       if (!pmu->info) {
> -               dev_err(&pdev->dev, "Memory alloc fails for info\n");
> +       if (!pmu->info)
>                 return -ENOMEM;
> -       }
>
>         info = bcm590xx_regs;
>

For the other two drivers touched by this patch series, the probe
methods only include a single dynamic memory allocation.  As such, the
stack trace provided by the generic memory code is sufficient to
quickly identify where the failure occurred.

The probe method of this driver, on the other hand, performs several
allocations and the error messages you intend to remove conveniently
pinpoint which one failed.  While the offsets in the trace could be
used to derive the same information, I am skeptical that is enough to
justify removing the messages.

Thanks,
Tim Kryger
