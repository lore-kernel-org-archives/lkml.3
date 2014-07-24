Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaGXLKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaGXLKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:10:14 -0400
Message-ID: <53D0E984.3040104@redhat.com>
Date: Thu, 24 Jul 2014 13:09:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        gleb@kernel.org, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
CC: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 2/4] KVM: use pci device flag operation helper functions
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com> <1406045944-1587-3-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1406045944-1587-3-git-send-email-ethan.zhao@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/07/2014 18:19, Ethan Zhao ha scritto:
> Use helper function instead of direct operation to pci device
> flag when set device to assigned or deassigned.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  virt/kvm/assigned-dev.c |    2 +-
>  virt/kvm/iommu.c        |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index bf06577..d122bda 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -302,7 +302,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
>  	else
>  		pci_restore_state(assigned_dev->dev);
>  
> -	assigned_dev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_set_dev_deassigned(assigned_dev->dev);
>  
>  	pci_release_regions(assigned_dev->dev);
>  	pci_disable_device(assigned_dev->dev);
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 0df7d4b..8cfe021 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -194,7 +194,7 @@ int kvm_assign_device(struct kvm *kvm,
>  			goto out_unmap;
>  	}
>  
> -	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> +	pci_set_dev_assigned(pdev);
>  
>  	dev_info(&pdev->dev, "kvm assign device\n");
>  
> @@ -220,7 +220,7 @@ int kvm_deassign_device(struct kvm *kvm,
>  
>  	iommu_detach_device(domain, &pdev->dev);
>  
> -	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_set_dev_deassigned(pdev);
>  
>  	dev_info(&pdev->dev, "kvm deassign device\n");
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
