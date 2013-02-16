Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3BPCx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:53:26 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44981 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3BPCxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:53:25 -0500
MIME-Version: 1.0
In-Reply-To: <1360931766.3453.1.camel@phoenix>
References: <1360931766.3453.1.camel@phoenix>
Date: Sat, 16 Feb 2013 10:53:25 +0800
Message-ID: <CAN1soZzxoZsfcrPrW5yjEvrH+cCLgCKL4JpatrSz9t+=JpyqDg@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8925: Remove unused parameter from max8925_regulator_dt_init
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 8:36 PM, Axel Lin <axel.lin@ingics.com> wrote:
> The info parameter is not used at all, remove it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/max8925-regulator.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
> index 0d5f64a..3597da8 100644
> --- a/drivers/regulator/max8925-regulator.c
> +++ b/drivers/regulator/max8925-regulator.c
> @@ -246,7 +246,6 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
>
>  #ifdef CONFIG_OF
>  static int max8925_regulator_dt_init(struct platform_device *pdev,
> -                                   struct max8925_regulator_info *info,
>                                     struct regulator_config *config,
>                                     int ridx)
>  {
> @@ -272,7 +271,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
>         return 0;
>  }
>  #else
> -#define max8925_regulator_dt_init(w, x, y, z)  (-1)
> +#define max8925_regulator_dt_init(x, y, z)     (-1)
>  #endif
>
>  static int max8925_regulator_probe(struct platform_device *pdev)
> @@ -309,7 +308,7 @@ static int max8925_regulator_probe(struct platform_device *pdev)
>         config.dev = &pdev->dev;
>         config.driver_data = ri;
>
> -       if (max8925_regulator_dt_init(pdev, ri, &config, regulator_idx))
> +       if (max8925_regulator_dt_init(pdev, &config, regulator_idx))
>                 if (pdata)
>                         config.init_data = pdata;
>
> --
> 1.7.9.5
>
>
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
