Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab3HBKQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:16:53 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43300 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3HBKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:16:51 -0400
Date: Fri, 2 Aug 2013 11:16:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 2/2] mfd: ab8500-gpadc: add CONFIG_PM_SLEEP to
 suspend/resume
Message-ID: <20130802101644.GC17368@lee--X1>
References: <000201ce8f40$2322df90$69689eb0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000201ce8f40$2322df90$69689eb0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug 2013, Jingoo Han wrote:

> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
> warnings when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
> when the CONFIG_PM_SLEEP is enabled.
> 
> drivers/mfd/ab8500-gpadc.c:891:12: warning: 'ab8500_gpadc_suspend' defined but not used [-Wunused-function]
> drivers/mfd/ab8500-gpadc.c:903:12: warning: 'ab8500_gpadc_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ab8500-gpadc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> index 77c616f..36000f9 100644
> --- a/drivers/mfd/ab8500-gpadc.c
> +++ b/drivers/mfd/ab8500-gpadc.c
> @@ -888,6 +888,7 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
>  }
>  #endif
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int ab8500_gpadc_suspend(struct device *dev)
>  {
>  	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> @@ -915,6 +916,7 @@ static int ab8500_gpadc_resume(struct device *dev)
>  	mutex_unlock(&gpadc->ab8500_gpadc_lock);
>  	return ret;
>  }
> +#endif
>  
>  static int ab8500_gpadc_probe(struct platform_device *pdev)
>  {

Looks sensible. I wonder why we haven't caught these before.

I guess we always enable PM_SLEEP.

Applied until Linus tells me otherwise.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
