Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaG2M0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:26:50 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37626 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaG2M0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <1406606791-8834-3-git-send-email-ethan.zhao@oracle.com>
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
	<1406606791-8834-3-git-send-email-ethan.zhao@oracle.com>
Date: Tue, 29 Jul 2014 20:26:47 +0800
Message-ID: <CABawtvOBy2BRJ0YQTmJSpbXUGXVH60DCjAqhzR13CZ3UXX_BMg@mail.gmail.com>
Subject: Re: [PATCH 2/4 v3] KVM: use pci device flag operation helper functions
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "<gleb@kernel.org>" <gleb@kernel.org>,
        "<pbonzini@redhat.com>" <pbonzini@redhat.com>,
        "<kvm@vger.kernel.org>" <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "<boris.ostrovsky@oracle.com>" <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "<xen-devel@lists.xenproject.org>" <xen-devel@lists.xenproject.org>,
        "<alex.williamson@redhat.com>" <alex.williamson@redhat.com>,
        "<alexander.h.duyck@intel.com>" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was already
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
I forgot to add the Ack tag.

Thanks,
Ethan

Sorry for last post in HTML format with ipad.

On Tue, Jul 29, 2014 at 12:06 PM, Ethan Zhao <ethan.zhao@oracle.com> wrote:
> Use helper function instead of direct operation to pci device
> flag when set device to assigned or deassigned.
>
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  v3: amend helper functions naming.
>  virt/kvm/assigned-dev.c |    2 +-
>  virt/kvm/iommu.c        |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index bf06577..d122bda 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -302,7 +302,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
>         else
>                 pci_restore_state(assigned_dev->dev);
>
> -       assigned_dev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +       pci_clear_dev_assigned(assigned_dev->dev);
>
>         pci_release_regions(assigned_dev->dev);
>         pci_disable_device(assigned_dev->dev);
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 0df7d4b..8cfe021 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -194,7 +194,7 @@ int kvm_assign_device(struct kvm *kvm,
>                         goto out_unmap;
>         }
>
> -       pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> +       pci_set_dev_assigned(pdev);
>
>         dev_info(&pdev->dev, "kvm assign device\n");
>
> @@ -220,7 +220,7 @@ int kvm_deassign_device(struct kvm *kvm,
>
>         iommu_detach_device(domain, &pdev->dev);
>
> -       pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +       pci_clear_dev_assigned(pdev);
>
>         dev_info(&pdev->dev, "kvm deassign device\n");
>
> --
> 1.7.1
>
