Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3ILPKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:10:41 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63547 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3ILPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:10:39 -0400
Date: Thu, 12 Sep 2013 16:10:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: timberdale: remove unnecessary pci_set_drvdata()
Message-ID: <20130912151035.GL11227@lee--X1>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
 <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/timberdale.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index a6755ec..084767b 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -829,12 +829,10 @@ err_config:
>  err_ioremap:
>  	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
>  err_request:
> -	pci_set_drvdata(dev, NULL);

So now err_request is redundant.

Can you clean that up in this patch also please?

>  err_start:
>  	pci_disable_device(dev);
>  err_enable:
>  	kfree(priv);
> -	pci_set_drvdata(dev, NULL);
>  	return -ENODEV;
>  }
>  
> @@ -851,7 +849,6 @@ static void timb_remove(struct pci_dev *dev)
>  
>  	pci_disable_msix(dev);
>  	pci_disable_device(dev);
> -	pci_set_drvdata(dev, NULL);
>  	kfree(priv);
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
