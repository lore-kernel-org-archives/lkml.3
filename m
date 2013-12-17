Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3LQJxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:53:09 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33349 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3LQJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:53:05 -0500
Date: Tue, 17 Dec 2013 09:53:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH mfd-next] mfd: max14577 and sec: add PM_SLEEP dependency
 to suspend/resume
Message-ID: <20131217095300.GA19810@lee--X1>
References: <1387272505-4621-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387272505-4621-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Krzysztof Kozlowski wrote:

> Add CONFIG_PM_SLEEP dependency to suspend and resume functions of
> max14577 MFD driver and sec-core.c code.
> 
> This fixes the warnings:
> drivers/mfd/max14577.c:176:12: warning: ‘max14577_suspend’ defined but not used [-Wunused-function]
> drivers/mfd/max14577.c:199:12: warning: ‘max14577_resume’ defined but not used [-Wunused-function]
> drivers/mfd/sec-core.c:347:12: warning: ‘sec_pmic_suspend’ defined but not used [-Wunused-function]
> drivers/mfd/sec-core.c:369:12: warning: ‘sec_pmic_resume’ defined but not used [-Wunused-function]
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max14577.c |    2 ++
>  drivers/mfd/sec-core.c |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index a5e1c370c609..1018a6644469 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int max14577_suspend(struct device *dev)
>  {
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> @@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
>  
>  	return 0;
>  }
> +#endif /* CONFIG_PM_SLEEP */

Is this the best way we have of doing this?

Isn't there a helper which casts these to NULL if unused?

>  static struct of_device_id max14577_dt_match[] = {
>  	{ .compatible = "maxim,max14577", },
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 56615af42a28..455e3a8fb95d 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -343,6 +343,7 @@ static int sec_pmic_remove(struct i2c_client *i2c)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int sec_pmic_suspend(struct device *dev)
>  {
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> @@ -377,6 +378,7 @@ static int sec_pmic_resume(struct device *dev)
>  
>  	return 0;
>  }
> +#endif /* CONFIG_PM_SLEEP */
>  
>  static SIMPLE_DEV_PM_OPS(sec_pmic_pm_ops, sec_pmic_suspend, sec_pmic_resume);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
