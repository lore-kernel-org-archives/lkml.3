Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaE1PUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:20:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33395 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaE1PUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:20:18 -0400
Date: Wed, 28 May 2014 16:20:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mfd: fix unintentional NULL check in
 menelaus_set_voltage()
Message-ID: <20140528152011.GB1954@lee--X1>
References: <1401284030-9650-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401284030-9650-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Emil Goode wrote:

> The struct menelaus_vtg pointer vtg cannot be NULL here
> so the condition is never true and if it ever was true
> it would lead to a NULL pointer dereference when we goto
> label set_voltage.
> 
> Before the below patch was applied the code was:
> 
> if (vtg == 0)
> 
> The intention was to check if vtg_val is 0.
> 
> commit 59a9f7a32adf6537b4e4db8ca204eeb77d7a634e
> ("mfd: menelaus: Use NULL instead of 0")
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
> Hello,
> 
> This is only build tested, it would be good to get a comment
> from someone who is familiar with this code.
> 
> Found using coccinelle.
> 
> Best regards,
> 
> Emil Goode
> 
>  drivers/mfd/menelaus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index ad25bfa..4859597 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
>  	struct i2c_client *c = the_menelaus->client;
>  
>  	mutex_lock(&the_menelaus->lock);
> -	if (!vtg)
> +	if (vtg_val == 0)

I would prefer:

  if (!vtg_val)

>  		goto set_voltage;
>  
>  	ret = menelaus_read_reg(vtg->vtg_reg);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
