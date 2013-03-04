Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3CDJSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:18:25 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:35716 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3CDJSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <1361915625-24294-1-git-send-email-maxin.john@gmail.com>
References: <1361915625-24294-1-git-send-email-maxin.john@gmail.com>
Date: Mon, 4 Mar 2013 10:18:20 +0100
Message-ID: <CAMhs6Yy+CFB-dC7PKCEn=19JbiKz=DqWW1G=QeLUzTvwakE_rg@mail.gmail.com>
Subject: Re: [PATCH] i2c: busses: i2c-ocores: Fix PM-related warning
From: "Maxin B. John" <maxin.john@gmail.com>
To: jacmet@sunsite.dk
Cc: wsa@the-dreams.de, ben-linux@fluff.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:53 PM,  <maxin.john@gmail.com> wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
>
> Fixes this warning:
>   CC      drivers/i2c/busses/i2c-ocores.o
> drivers/i2c/busses/i2c-ocores.c:460:12: warning: 'ocores_i2c_suspend'
>  defined but not used [-Wunused-function]
> drivers/i2c/busses/i2c-ocores.c:471:12: warning: 'ocores_i2c_resume'
> defined but not used [-Wunused-function]
>
> Signed-off-by: Maxin B. John <maxin.john@enea.com>
> ---
>  drivers/i2c/busses/i2c-ocores.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index 0e1f824..1ecea5e 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -456,7 +456,7 @@ static int ocores_i2c_remove(struct platform_device *pdev)
>         return 0;
>  }
>
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  static int ocores_i2c_suspend(struct device *dev)
>  {
>         struct ocores_i2c *i2c = dev_get_drvdata(dev);
> @@ -476,12 +476,9 @@ static int ocores_i2c_resume(struct device *dev)
>
>         return 0;
>  }
> +#endif
>
>  static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend, ocores_i2c_resume);
> -#define OCORES_I2C_PM  (&ocores_i2c_pm)
> -#else
> -#define OCORES_I2C_PM  NULL
> -#endif
>
>  static struct platform_driver ocores_i2c_driver = {
>         .probe   = ocores_i2c_probe,
> @@ -490,7 +487,7 @@ static struct platform_driver ocores_i2c_driver = {
>                 .owner = THIS_MODULE,
>                 .name = "ocores-i2c",
>                 .of_match_table = ocores_i2c_match,
> -               .pm = OCORES_I2C_PM,
> +               .pm = &ocores_i2c_pm,
>         },
>  };
>
> --
> 1.7.7
>

ping..
