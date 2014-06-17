Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbaFQPMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:12:55 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64219 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbaFQPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:12:53 -0400
Date: Tue, 17 Jun 2014 16:12:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: nyushchenko@dev.rtsoft.ru
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where
 appropriate
Message-ID: <20140617151226.GM29841@lee--X1>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
 <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> 
> This avoids leak of IRQ mapping on error paths, and makes it possible
> to use devm_request_irq() without facing unmap-while-handler-installed
> issues.
> 
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> ---
>  drivers/mfd/max8997.c |    4 +++-
>  drivers/mfd/max8998.c |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 8cf7a01..6ae0786 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -153,7 +153,9 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
> +	pd->ono = devm_irq_of_parse_and_map(dev, dev->of_node, 1);
> +	if (pd->ono < 0)
> +		return ERR_PTR(pd->ono);
>  
>  	/*
>  	 * ToDo: the 'wakeup' member in the platform data is more of a linux
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index 592db06..6b62dd7 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -159,7 +159,9 @@ static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
>  	if (!pd)
>  		return ERR_PTR(-ENOMEM);
>  
> -	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
> +	pd->ono = devm_irq_of_parse_and_map(dev, dev->of_node, 1);
> +	if (pd->ono < 0)
> +		return ERR_PTR(pd->ono);
>  
>  	/*
>  	 * ToDo: the 'wakeup' member in the platform data is more of a linux

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
