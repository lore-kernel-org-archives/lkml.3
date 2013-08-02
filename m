Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3HBKRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:17:44 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:43493 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3HBKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:17:39 -0400
Date: Fri, 2 Aug 2013 11:17:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 1/2] mfd: ab8500-gpadc: add CONFIG_PM_RUNTIME to
 runtime_suspend/runtime_resume
Message-ID: <20130802101733.GD17368@lee--X1>
References: <000101ce8f40$0e118070$2a348150$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000101ce8f40$0e118070$2a348150$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug 2013, Jingoo Han wrote:

> Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume functions
> to fix the build warnings when CONFIG_PM_RUNTIME is not selected.
> This is because runtime PM callbacks defined by SET_RUNTIME_PM_OPS
> are only used when the CONFIG_PM_RUNTIME is enabled.
> 
> drivers/mfd/ab8500-gpadc.c:870:12: warning: 'ab8500_gpadc_runtime_suspend' defined but not used [-Wunused-function]
> drivers/mfd/ab8500-gpadc.c:878:12: warning: 'ab8500_gpadc_runtime_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ab8500-gpadc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> index 7623e91..77c616f 100644
> --- a/drivers/mfd/ab8500-gpadc.c
> +++ b/drivers/mfd/ab8500-gpadc.c
> @@ -867,6 +867,7 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
>  		gpadc->cal_data[ADC_INPUT_VBAT].offset);
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
>  static int ab8500_gpadc_runtime_suspend(struct device *dev)
>  {
>  	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> @@ -885,6 +886,7 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
>  		dev_err(dev, "Failed to enable vtvout LDO: %d\n", ret);
>  	return ret;
>  }
> +#endif
>  
>  static int ab8500_gpadc_suspend(struct device *dev)
>  {

Looks sensible. I wonder why we haven't caught these before.

I guess we always enable PM_SLEEP.

Applied until Linus tells me otherwise.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
