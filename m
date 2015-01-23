Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbbAWXEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:04:08 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:65013 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbAWXEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:04:06 -0500
Date: Fri, 23 Jan 2015 17:04:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: keystone: fix incorrect annotations on probe and
 remove
Message-ID: <20150123230400.GQ29776@google.com>
References: <20150108221736.GA39839@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108221736.GA39839@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 02:17:36PM -0800, Dmitry Torokhov wrote:
> Even though platform bus is not hot-pluggable, devices on it can be unbound
> from the driver and bound back to it via sysfs, so we should not be using
> __init annotations on probe() and __exit annotations on remove() methods.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I also removed the __init annotations from ks_pcie_host_init() and
ks_add_pcie_port() and applied this to pci/host-keystone for v3.20, thanks!

> ---
> 
> Not tested, found by casual code inspection.
> 
>  drivers/pci/host/pci-keystone.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
> index 1b893bc..7b84e1d 100644
> --- a/drivers/pci/host/pci-keystone.c
> +++ b/drivers/pci/host/pci-keystone.c
> @@ -332,7 +332,7 @@ static const struct of_device_id ks_pcie_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ks_pcie_of_match);
>  
> -static int __exit ks_pcie_remove(struct platform_device *pdev)
> +static int ks_pcie_remove(struct platform_device *pdev)
>  {
>  	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
>  
> @@ -341,7 +341,7 @@ static int __exit ks_pcie_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static int __init ks_pcie_probe(struct platform_device *pdev)
> +static int ks_pcie_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct keystone_pcie *ks_pcie;
> @@ -398,9 +398,9 @@ fail_clk:
>  	return ret;
>  }
>  
> -static struct platform_driver ks_pcie_driver __refdata = {
> +static struct platform_driver ks_pcie_driver = {
>  	.probe  = ks_pcie_probe,
> -	.remove = __exit_p(ks_pcie_remove),
> +	.remove = ks_pcie_remove,
>  	.driver = {
>  		.name	= "keystone-pcie",
>  		.owner	= THIS_MODULE,
> -- 
> 2.2.0.rc0.207.ga3a616c
> 
> 
> -- 
> Dmitry
