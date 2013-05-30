Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967542Ab3E3GEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:04:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6683 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3E3GEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:04:36 -0400
Message-ID: <51A6EBBE.6020805@huawei.com>
Date: Thu, 30 May 2013 14:03:42 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@intel.com>
CC: <bhelgaas@google.com>, <yinghai@kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] PCI: set correct value for iov device before device
References: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
In-Reply-To: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xudong,
   This bug has been fixed by Jiang Liu in patch
https://patchwork.kernel.org/patch/2613481/


On 2013/5/30 13:45, Xudong Hao wrote:
> Since device registering is put into pci_device_add(), it must set value of
> Virtual Function device's member before the pci_dev is put to device tree. Or
> some relevant subsystem of driver model such as xen will report a incorrect
> IOV device to Xen hypervior.
> 
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> ---
>  drivers/pci/iov.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index c93071d..43d3de9 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
>  	if (reset)
>  		__pci_reset_function(virtfn);
>  
> -	pci_device_add(virtfn, virtfn->bus);
> -	mutex_unlock(&iov->dev->sriov->lock);
> -
>  	virtfn->physfn = pci_dev_get(dev);
>  	virtfn->is_virtfn = 1;
>  
> +	pci_device_add(virtfn, virtfn->bus);
> +	mutex_unlock(&iov->dev->sriov->lock);
> +
>  	rc = pci_bus_add_device(virtfn);
>  	sprintf(buf, "virtfn%u", id);
>  	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
> 


-- 
Thanks!
Yijing

