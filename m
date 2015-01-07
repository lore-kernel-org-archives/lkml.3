Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbbAGTAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbbAGTAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:00:50 -0500
Message-ID: <1420657243.6345.22.camel@redhat.com>
Subject: Re: [PATCH V2] vfio-pci: Fix the check on pci device type in
 vfio_pci_probe()
From: Alex Williamson <alex.williamson@redhat.com>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 07 Jan 2015 12:00:43 -0700
In-Reply-To: <1419303487-9077-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <20141223011622.GA6035@richard>
	 <1419303487-9077-1-git-send-email-weiyang@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 10:58 +0800, Wei Yang wrote:
> Current vfio-pci just supports normal pci device, so vfio_pci_probe() will
> return if the pci device is not a normal device. While current code makes a
> mistake. PCI_HEADER_TYPE is the offset in configuration space of the device
> type, but we use this value to mask the type value.
> 
> This patch fixs this by do the check directly on the pci_dev->hdr_type.
> 
> Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
> 
> V2:
>    * Fix the problem by checking pci_dev->hdr_type
> 
> ---
>  drivers/vfio/pci/vfio_pci.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied to my for-linus branch for v3.19.  I've also tagged it for
stable.  Thanks,

Alex

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 9558da3..2f8a055 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -839,13 +839,11 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> -	u8 type;
>  	struct vfio_pci_device *vdev;
>  	struct iommu_group *group;
>  	int ret;
>  
> -	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &type);
> -	if ((type & PCI_HEADER_TYPE) != PCI_HEADER_TYPE_NORMAL)
> +	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  
>  	group = iommu_group_get(&pdev->dev);



