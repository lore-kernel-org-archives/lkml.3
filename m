Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaJ0FAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:00:45 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59507 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaJ0FAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <1414160997-30575-1-git-send-email-daniel.thompson@linaro.org>
References: <1414160997-30575-1-git-send-email-daniel.thompson@linaro.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 27 Oct 2014 14:00:21 +0900
Message-ID: <CAAVeFuLZJtdUXNyT6Nbi7jbZ-MsVjUFkmPg9oVEa=ZpkZRwkbw@mail.gmail.com>
Subject: Re: [PATCH] gpio: msm-v1: Fix typo in function argument
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:29 PM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> irq_set_irq_wake() treats its second argument as a boolean. It is much
> easier to read code when constant booleans are either 0 or 1!
>
> This particular line of code distracted me somewhat when I was doing a bit of
> work in a code browser since it (spuriously) got me worried that I had
> misunderstood how irq_set_irq_wake() worked.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
>  drivers/gpio/gpio-msm-v1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
> index 73b7396..997e61e 100644
> --- a/drivers/gpio/gpio-msm-v1.c
> +++ b/drivers/gpio/gpio-msm-v1.c
> @@ -686,7 +686,7 @@ static int gpio_msm_v1_probe(struct platform_device *pdev)
>         irq_set_chained_handler(irq1, msm_gpio_irq_handler);
>         irq_set_chained_handler(irq2, msm_gpio_irq_handler);
>         irq_set_irq_wake(irq1, 1);
> -       irq_set_irq_wake(irq2, 2);
> +       irq_set_irq_wake(irq2, 1);
>         return 0;

That could be confusing indeed.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
