Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3EVNSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:18:04 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56458 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3EVNSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
	<1369226853-16978-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 22 May 2013 15:18:01 +0200
Message-ID: <CACRpkdYHiwbGonH80aJfHxP6F+hLb+_KdCr_g5ae1Yr-v=WcxA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 2:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch fixes a bug introduced in the v3.10 merge window.
>
> Some platforms will not want external registers. Rather than setting up
> lots of different clauses in the core ab8500 regulator driver not to
> call ab8500-ext init() we just won't pass the initialisation data from
> platform code. This patch checks for it and if it's missing, we won't
> register the external regulators.
>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/regulator/ab8500-ext.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index b4d4547..8421537 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -334,6 +334,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> +       /* have any external regulators been specified? */
> +       if (pdata->num_ext_regulator == 0) {
> +               dev_warn(&pdev->dev, "Not using external regulators\n");
> +               return 0;
> +       }

dev_warn() is really when we warn about something really nasty, worse
than dev_err(). It seems dev_info() is more apropriate.

Anyway since it's an urgent regression:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Linus
