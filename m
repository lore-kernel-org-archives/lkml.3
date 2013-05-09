Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3EIT3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:29:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39834 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752237Ab3EIT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:29:39 -0400
Date: Thu, 9 May 2013 15:29:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Libo Chen <libo.chen@huawei.com>
cc: grant.likely@linaro.org, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 4/4] usb: tilegx: fix memleak when create hcd fail
In-Reply-To: <1368079537-15328-5-git-send-email-libo.chen@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1305091529270.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Libo Chen wrote:

> When usb_create_hcd fail, we should call gxio_usb_host_destroy
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ohci-tilegx.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
> index 1ae7b28..5888fc4 100644
> --- a/drivers/usb/host/ohci-tilegx.c
> +++ b/drivers/usb/host/ohci-tilegx.c
> @@ -112,8 +112,10 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
>  
>  	hcd = usb_create_hcd(&ohci_tilegx_hc_driver, &pdev->dev,
>  			     dev_name(&pdev->dev));
> -	if (!hcd)
> -		return -ENOMEM;
> +	if (!hcd){
> +		ret = -ENOMEM;
> +		goto err_hcd;
> +	}
>  
>  	/*
>  	 * We don't use rsrc_start to map in our registers, but seems like
> @@ -165,6 +167,7 @@ err_have_irq:
>  err_no_irq:
>  	tilegx_stop_ohc();
>  	usb_put_hcd(hcd);
> +err_hcd:
>  	gxio_usb_host_destroy(&pdata->usb_ctx);
>  	return ret;
>  }

Acked-by: Alan Stern <stern@rowland.harvard.edu>

