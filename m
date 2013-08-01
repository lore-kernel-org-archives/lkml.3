Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3HAIw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:52:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33030 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3HAIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:52:27 -0400
Date: Thu, 1 Aug 2013 09:52:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] mfd: max8997: cast void pointer to data of
 max8997_pmic_dt_match
Message-ID: <20130801085221.GN13298@lee--X1>
References: <002e01ce8e5b$08700410$19500c30$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002e01ce8e5b$08700410$19500c30$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Aug 2013, Jingoo Han wrote:

> Casting (void *) data of max8997_pmic_dt_match is necessary,
> because variable 'data' of struct 'of_device_id' is defined as
> 'const void *data'. Thus, pointer should be used instead of value.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/max8997.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 1471405..e6d668a 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -51,7 +51,7 @@ static struct mfd_cell max8997_devs[] = {
>  
>  #ifdef CONFIG_OF
>  static struct of_device_id max8997_pmic_dt_match[] = {
> -	{ .compatible = "maxim,max8997-pmic", .data = TYPE_MAX8997 },
> +	{ .compatible = "maxim,max8997-pmic", .data = (void *)TYPE_MAX8997 },
>  	{},
>  };
>  #endif

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
