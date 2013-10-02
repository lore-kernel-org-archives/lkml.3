Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3JBKfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3JBKfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:35:11 -0400
Date: Wed, 2 Oct 2013 13:35:08 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andre Richter <andre.o.richter@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/1] virt/kvm/iommu.c: Add leading zeros to device's BDF
 notation in debug messages
Message-ID: <20131002103508.GG17294@redhat.com>
References: <1380709406-3528-1-git-send-email-andre.o.richter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380709406-3528-1-git-send-email-andre.o.richter@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:23:26PM +0200, Andre Richter wrote:
> When KVM (de)assigns PCI(e) devices to VMs, a debug message is printed
> including the BDF notation of the respective device. Currently, the BDF
> notation does not have the commonly used leading zeros. This produces
> messages like "assign device 0:1:8.0", which look strange at first sight.
> 
> The patch fixes this by exchanging the printk(KERN_DEBUG ...) with dev_info()
> and also inserts "kvm" into the debug message, so that it is obvious where
> the message comes from. Also reduces LoC.
Legacy assigned device is deprecated, but this looks nice enough to
apply. Alex can you glance at it?

> 
> Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
> ---
>  virt/kvm/iommu.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 72a130b..a3b1410 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -190,11 +190,7 @@ int kvm_assign_device(struct kvm *kvm,
>  
>  	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>  
> -	printk(KERN_DEBUG "assign device %x:%x:%x.%x\n",
> -		assigned_dev->host_segnr,
> -		assigned_dev->host_busnr,
> -		PCI_SLOT(assigned_dev->host_devfn),
> -		PCI_FUNC(assigned_dev->host_devfn));
> +	dev_info(&pdev->dev, "kvm assign device\n");
>  
>  	return 0;
>  out_unmap:
> @@ -220,11 +216,7 @@ int kvm_deassign_device(struct kvm *kvm,
>  
>  	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>  
> -	printk(KERN_DEBUG "deassign device %x:%x:%x.%x\n",
> -		assigned_dev->host_segnr,
> -		assigned_dev->host_busnr,
> -		PCI_SLOT(assigned_dev->host_devfn),
> -		PCI_FUNC(assigned_dev->host_devfn));
> +	dev_info(&pdev->dev, "kvm deassign device\n");
>  
>  	return 0;
>  }
> -- 
> 1.8.1.2

--
			Gleb.
