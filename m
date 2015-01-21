Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbbAUXZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:25:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbbAUXZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:25:48 -0500
Message-ID: <1421882727.6130.453.camel@redhat.com>
Subject: Re: [PATCH v12 12/18] vfio: add a vfio_ prefix to virqfd_enable and
 virqfd_disable and export
From: Alex Williamson <alex.williamson@redhat.com>
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 21 Jan 2015 16:25:27 -0700
In-Reply-To: <1421844606-24751-13-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
	 <1421844606-24751-13-git-send-email-b.reynal@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 13:50 +0100, Baptiste Reynal wrote:
> From: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> We want to reuse virqfd functionality in multiple VFIO drivers; before
> moving these functions to core VFIO, add the vfio_ prefix to the
> virqfd_enable and virqfd_disable functions, and export them so they can
> be used from other modules.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c   | 30 ++++++++++++++++--------------
>  drivers/vfio/pci/vfio_pci_private.h |  4 ++--
>  2 files changed, 18 insertions(+), 16 deletions(-)
...
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 671c17a..2e2f0ea 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -86,8 +86,8 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>  extern int vfio_pci_init_perm_bits(void);
>  extern void vfio_pci_uninit_perm_bits(void);
>  
> -extern int vfio_pci_virqfd_init(void);
> -extern void vfio_pci_virqfd_exit(void);
> +extern int vfio_virqfd_init(void);
> +extern void vfio_virqfd_exit(void);
>  
>  extern int vfio_config_init(struct vfio_pci_device *vdev);
>  extern void vfio_config_free(struct vfio_pci_device *vdev);

This chunk is in the wrong patch, it needs to be moved to the next patch
or else the series isn't bisect-able.  Thanks,

Alex

