Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaIVTRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:17:20 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38260 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaIVTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:17:17 -0400
Date: Mon, 22 Sep 2014 13:17:14 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Message-ID: <20140922191714.GC1880@google.com>
References: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 02:57:57PM +0200, Ricardo Ribalda Delgado wrote:
> There is a missmatch between the way file2alias generates the modalias
> and the way the pci driver generates it.
> 
> Some implementations of modprobe will fail to load the driver for a pci
> device automatically when the pci interface is defined on the driver. As
> one will be in uppercase and the other in lowercase.
> 
> Fortunatelly not many drivers define this.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Applied to pci/enumeration for v3.18, with Greg's ack and marked for
stable.

> ---
>  drivers/pci/pci-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9ff0a90..76ef791 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -177,7 +177,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  
> -	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
> +	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
>  		       pci_dev->vendor, pci_dev->device,
>  		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
>  		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
> -- 
> 2.1.0
> 
