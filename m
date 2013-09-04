Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920Ab3IDOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:25:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:40105 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3IDOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:25:34 -0400
X-Auth-Info: wgndIlc2L50jubmXpfJca0vp3CSEhGJisM+TA0wuww0=
From: Marek Vasut <marex@denx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/7] regulator: anatop-regulator: Use devm_regulator_register
Date: Wed, 4 Sep 2013 16:25:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, Nancy.Chen@freescale.com
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201309041625.25514.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sachin Kamat,

> devm_* simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Makes sense

Acked-by: Marek Vasut <marex@denx.de>

> ---
> This series is compile tested.
> ---
>  drivers/regulator/anatop-regulator.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/anatop-regulator.c
> b/drivers/regulator/anatop-regulator.c index 0d4a8cc..e42bfd1 100644
> --- a/drivers/regulator/anatop-regulator.c
> +++ b/drivers/regulator/anatop-regulator.c
> @@ -200,7 +200,7 @@ static int anatop_regulator_probe(struct
> platform_device *pdev) config.regmap = sreg->anatop;
> 
>  	/* register regulator */
> -	rdev = regulator_register(rdesc, &config);
> +	rdev = devm_regulator_register(dev, rdesc, &config);
>  	if (IS_ERR(rdev)) {
>  		dev_err(dev, "failed to register %s\n",
>  			rdesc->name);
> @@ -223,7 +223,6 @@ static int anatop_regulator_remove(struct
> platform_device *pdev) struct anatop_regulator *sreg =
> rdev_get_drvdata(rdev);
>  	const char *name = sreg->name;
> 
> -	regulator_unregister(rdev);
>  	kfree(name);
> 
>  	return 0;

Best regards,
Marek Vasut
