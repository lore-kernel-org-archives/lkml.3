Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbaJ3Rg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:36:29 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48494 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbaJ3Rg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:36:28 -0400
Date: Thu, 30 Oct 2014 11:36:24 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Epler <jepler@unpythonic.net>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix name of 'enable' sysfs file
Message-ID: <20141030173624.GB6982@google.com>
References: <20141030163028.GA22250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030163028.GA22250@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 09:30:28AM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
> I misstyped the 'enable' sysfs file as 'enabled', which broke the
> userspace api.  This patch fixes that issue by renaming the file back.
> 
> Reported-by: Jeff Epler <jepler@unpythonic.net>
> Cc: stable <stable@vger.kernel.org> # 3.13
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I applied this to for-linus for v3.18.  If a symlink turns out to be
needed, we can also add that.  Jeff, if you test this, I'll update it with
your Tested-by.

> ---
> 
> Jeff, if you could test this to make sure I got it right, that would be
> great.  Again, sorry about this, it was a dumb typo on my part.
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 92b6d9ab00e4..2c6643fdc0cf 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -185,7 +185,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(modalias);
>  
> -static ssize_t enabled_store(struct device *dev, struct device_attribute *attr,
> +static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
>  			     const char *buf, size_t count)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -210,7 +210,7 @@ static ssize_t enabled_store(struct device *dev, struct device_attribute *attr,
>  	return result < 0 ? result : count;
>  }
>  
> -static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
> +static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
>  			    char *buf)
>  {
>  	struct pci_dev *pdev;
> @@ -218,7 +218,7 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
>  	pdev = to_pci_dev(dev);
>  	return sprintf(buf, "%u\n", atomic_read(&pdev->enable_cnt));
>  }
> -static DEVICE_ATTR_RW(enabled);
> +static DEVICE_ATTR_RW(enable);
>  
>  #ifdef CONFIG_NUMA
>  static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
> @@ -563,7 +563,7 @@ static struct attribute *pci_dev_attrs[] = {
>  #endif
>  	&dev_attr_dma_mask_bits.attr,
>  	&dev_attr_consistent_dma_mask_bits.attr,
> -	&dev_attr_enabled.attr,
> +	&dev_attr_enable.attr,
>  	&dev_attr_broken_parity_status.attr,
>  	&dev_attr_msi_bus.attr,
>  #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
