Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbaE3RBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:01:10 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47535 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbaE3RBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:01:06 -0400
Date: Fri, 30 May 2014 11:01:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-pci@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI, EDAC: fix ordering assign resource and bus_add
Message-ID: <20140530170103.GE4607@google.com>
References: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:29:31PM -0700, Yinghai Lu wrote:
> We should assign unassigned resource before pci_bus_add_device.
> 
> as late one will enable driver and create sysfs file that will need
> pci io resources from assign unassigned code.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to pci/resource for v3.16, thanks!

> ---
>  drivers/edac/i82875p_edac.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/edac/i82875p_edac.c
> ===================================================================
> --- linux-2.6.orig/drivers/edac/i82875p_edac.c
> +++ linux-2.6/drivers/edac/i82875p_edac.c
> @@ -293,13 +293,14 @@ static int i82875p_setup_overfl_dev(stru
>  		if (dev == NULL)
>  			return 1;
>  
> +		pci_bus_assign_resources(dev->bus);
> +
>  		err = pci_bus_add_device(dev);
>  		if (err) {
>  			i82875p_printk(KERN_ERR,
>  				"%s(): pci_bus_add_device() Failed\n",
>  				__func__);
>  		}
> -		pci_bus_assign_resources(dev->bus);
>  	}
>  
>  	*ovrfl_pdev = dev;
