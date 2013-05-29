Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967191Ab3E2XWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:22:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2372 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab3E2XWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:22:42 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Subject: Re: [PATCH] tg3: remove redundant pm init code
From: "Michael Chan" <mchan@broadcom.com>
To: "Yijing Wang" <wangyijing@huawei.com>
cc: "Nithin Nayak Sujir" <nsujir@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Hanjun Guo" <guohanjun@huawei.com>, "Jiang Liu" <liuj97@gmail.com>
In-Reply-To: <1369818032-36272-1-git-send-email-wangyijing@huawei.com>
References: <1369818032-36272-1-git-send-email-wangyijing@huawei.com>
Date: Wed, 29 May 2013 23:22:38 +0000
Message-ID: <1369869759.8868.52.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7DB8543A2L824611704-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 17:00 +0800, Yijing Wang wrote: 
> Pci_enable_device() will set device pm state to D0, so
> it's no need to do it again in tg3_init_one().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Acked-by: Michael Chan <mchan@broadcom.com>

> ---
>  drivers/net/ethernet/broadcom/tg3.c |   20 +-------------------
>  1 files changed, 1 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 728d42a..1396ab3 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -17042,25 +17042,10 @@ static int tg3_init_one(struct pci_dev *pdev,
>  
>  	pci_set_master(pdev);
>  
> -	/* Find power-management capability. */
> -	pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
> -	if (pm_cap == 0) {
> -		dev_err(&pdev->dev,
> -			"Cannot find Power Management capability, aborting\n");
> -		err = -EIO;
> -		goto err_out_free_res;
> -	}
> -
> -	err = pci_set_power_state(pdev, PCI_D0);
> -	if (err) {
> -		dev_err(&pdev->dev, "Transition to D0 failed, aborting\n");
> -		goto err_out_free_res;
> -	}
> -
>  	dev = alloc_etherdev_mq(sizeof(*tp), TG3_IRQ_MAX_VECS);
>  	if (!dev) {
>  		err = -ENOMEM;
> -		goto err_out_power_down;
> +		goto err_out_free_res;
>  	}
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> @@ -17406,9 +17391,6 @@ err_out_iounmap:
>  err_out_free_dev:
>  	free_netdev(dev);
>  
> -err_out_power_down:
> -	pci_set_power_state(pdev, PCI_D3hot);
> -
>  err_out_free_res:
>  	pci_release_regions(pdev);
>  



