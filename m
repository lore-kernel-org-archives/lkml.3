Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaBSOUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:20:12 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43645 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaBSOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <1391529538-21685-7-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-7-git-send-email-ulf.hansson@linaro.org>
Date: Wed, 19 Feb 2014 15:20:07 +0100
Message-ID: <CAPDyKFombL2-Rt46QpXPNWe5PeGQnOGmQQNfYd5MdYdEePn-4w@mail.gmail.com>
Subject: Re: [PATCH 06/17] spi: pl022: Let runtime PM callbacks be available
 for CONFIG_PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 16:58, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> Convert to the SET_PM_RUNTIME_PM macro while defining the runtime PM
> callbacks. This means the callbacks becomes available for both
> CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME, which is needed to handle the
> combinations of these scenarios.
>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Mark, any thoughts of this one?

This will be needed no matter of patch 7.

Also note that, Russell has already applied the corresponding part in
the amba bus (patch 1)

Kind regards
Uffe

> ---
>  drivers/spi/spi-pl022.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index 2789b45..70fa907 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -2288,7 +2288,7 @@ pl022_remove(struct amba_device *adev)
>         return 0;
>  }
>
> -#if defined(CONFIG_SUSPEND) || defined(CONFIG_PM_RUNTIME)
> +#ifdef CONFIG_PM
>  /*
>   * These two functions are used from both suspend/resume and
>   * the runtime counterparts to handle external resources like
> @@ -2354,7 +2354,7 @@ static int pl022_resume(struct device *dev)
>  }
>  #endif /* CONFIG_PM */
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int pl022_runtime_suspend(struct device *dev)
>  {
>         struct pl022 *pl022 = dev_get_drvdata(dev);
> @@ -2374,7 +2374,7 @@ static int pl022_runtime_resume(struct device *dev)
>
>  static const struct dev_pm_ops pl022_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(pl022_suspend, pl022_resume)
> -       SET_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
> +       SET_PM_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
>  };
>
>  static struct vendor_data vendor_arm = {
> --
> 1.7.9.5
>
