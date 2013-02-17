Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3BQCm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:42:59 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36354 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab3BQCm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
Date: Sun, 17 Feb 2013 10:42:57 +0800
Message-ID: <CAP1dx+xn-0N2GMF1s9=mG1t9jty8s1g_NW-S2m+UySG=_2fbmg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mfd: syscon: Removed support for unloading
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 02:42, Alexander Shiyan <shc_work@mail.ru> wrote:
> The driver can be used in various subsystems and therefore should not
> be unloaded when it is defined in the kernel configuration, so remove
> support for unloading it.
>
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> ---
>  drivers/mfd/syscon.c | 18 ------------------
>  1 file changed, 18 deletions(-)
>
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 3f10591..e1886fb 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -138,17 +138,6 @@ static int syscon_probe(struct platform_device *pdev)
>         return 0;
>  }
>
> -static int syscon_remove(struct platform_device *pdev)
> -{
> -       struct syscon *syscon;
> -
> -       syscon = platform_get_drvdata(pdev);
> -       iounmap(syscon->base);
> -       platform_set_drvdata(pdev, NULL);
> -
> -       return 0;
> -}
> -
>  static struct platform_driver syscon_driver = {
>         .driver = {
>                 .name = "syscon",
> @@ -156,7 +145,6 @@ static struct platform_driver syscon_driver = {
>                 .of_match_table = of_syscon_match,
>         },
>         .probe          = syscon_probe,
> -       .remove         = syscon_remove,
>  };
>
>  static int __init syscon_init(void)
> @@ -165,12 +153,6 @@ static int __init syscon_init(void)
>  }
>  postcore_initcall(syscon_init);
>
> -static void __exit syscon_exit(void)
> -{
> -       platform_driver_unregister(&syscon_driver);
> -}
> -module_exit(syscon_exit);
> -
>  MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
>  MODULE_DESCRIPTION("System Control driver");
>  MODULE_LICENSE("GPL v2");
> --
> 1.7.12.4
>
