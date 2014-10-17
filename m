Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaJQJCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:02:35 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63783 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaJQJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <1412188684-20820-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412188684-20820-1-git-send-email-pramod.gurav@smartplayin.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 17 Oct 2014 18:02:11 +0900
Message-ID: <CAAVeFu+3MW3LMm-HV+7jBgaQmMOF+m=KGNP1nLnaij8=X0=xcg@mail.gmail.com>
Subject: Re: [PATCH] gpio: grgpio: remove irq_domain resources on failure
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 3:38 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> Call irq_domain_remove when gpiochip_add fails to release irq_domain
> resources.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/gpio/gpio-grgpio.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
> index 66ad3df..38acdce 100644
> --- a/drivers/gpio/gpio-grgpio.c
> +++ b/drivers/gpio/gpio-grgpio.c
> @@ -441,6 +441,7 @@ static int grgpio_probe(struct platform_device *ofdev)
>         err = gpiochip_add(gc);
>         if (err) {
>                 dev_err(&ofdev->dev, "Could not add gpiochip\n");
> +               irq_domain_remove(priv->domain);
>                 return err;
>         }

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
