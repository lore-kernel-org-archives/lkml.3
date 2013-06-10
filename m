Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3FJMBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:01:51 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:32798 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3FJMBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
Date: Mon, 10 Jun 2013 17:31:47 +0530
Message-ID: <CAK9yfHySr3J8roLmntGvUi3-DkBCW397TjO65Qr0Zej8C7ROdg@mail.gmail.com>
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use devm_ioremap_resource
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 17:05, Tushar Behera <tushar.behera@linaro.org> wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: Mark Brown <broonie@kernel.org>
> CC: Liam Girdwood <lgirdwood@gmail.com>
> ---
>  drivers/regulator/ti-abb-regulator.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
> index 870d209..f494a11 100644
> --- a/drivers/regulator/ti-abb-regulator.c
> +++ b/drivers/regulator/ti-abb-regulator.c
> @@ -722,10 +722,10 @@ static int ti_abb_probe(struct platform_device *pdev)
>                 ret = -ENODEV;
>                 goto err;
>         }
> -       abb->base = devm_request_and_ioremap(dev, res);
> -       if (!abb->base) {
> +       abb->base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(abb->base)) {
>                 dev_err(dev, "Unable to map '%s'\n", pname);

You may remove the above error message as devm_ioremap_resource prints
its own error messages.

> -               ret = -ENOMEM;
> +               ret = PTR_ERR(abb->base);
>                 goto err;
>         }
>
> @@ -776,10 +776,10 @@ static int ti_abb_probe(struct platform_device *pdev)
>                 ret = -ENODEV;
>                 goto skip_opt;
>         }
> -       abb->ldo_base = devm_request_and_ioremap(dev, res);
> -       if (!abb->ldo_base) {
> +       abb->ldo_base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(abb->ldo_base)) {
>                 dev_err(dev, "Unable to map '%s'\n", pname);

ditto

> -               ret = -ENOMEM;
> +               ret = PTR_ERR(abb->ldo_base);
>                 goto err;
>         }
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
