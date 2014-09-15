Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbaIOXHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:07:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47745 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbaIOXH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:07:27 -0400
Date: Tue, 16 Sep 2014 00:07:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH] mfd: intel_soc_pmic: Add CONFIG_PM_SLEEP check for
 suspend_fn/resume_fn
Message-ID: <20140915230723.GK25162@lee--X1>
References: <1410496545-6579-1-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410496545-6579-1-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Jaewon Kim wrote:

> This patch fix warning message with CONFIG_PM_SLEEP disabled
> If CONFIG_PM_SLEEP is not enabled we receive the following warning message:
> 
> drivers/mfd/intel_soc_pmic_core.c:118:12:
>  warning: 'intel_soc_pmic_suspend' defined but not used
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> ---
>  drivers/mfd/intel_soc_pmic_core.c |    2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
> index 2720922..df7b064 100644
> --- a/drivers/mfd/intel_soc_pmic_core.c
> +++ b/drivers/mfd/intel_soc_pmic_core.c
> @@ -115,6 +115,7 @@ static void intel_soc_pmic_shutdown(struct i2c_client *i2c)
>  	return;
>  }
>  
> +#if defined(CONFIG_PM_SLEEP)
>  static int intel_soc_pmic_suspend(struct device *dev)
>  {
>  	struct intel_soc_pmic *pmic = dev_get_drvdata(dev);
> @@ -132,6 +133,7 @@ static int intel_soc_pmic_resume(struct device *dev)
>  
>  	return 0;
>  }
> +#endif
>  
>  static SIMPLE_DEV_PM_OPS(intel_soc_pmic_pm_ops, intel_soc_pmic_suspend,
>  			 intel_soc_pmic_resume);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
