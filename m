Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3IYQkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:40:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab3IYQkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:40:40 -0400
Message-ID: <1380127227.3030.316.camel@ul30vt.home>
Subject: Re: [PATCH 5/7] iommu: supress loff_t compilation error on powerpc
From: Alex Williamson <alex.williamson@redhat.com>
To: Bharat Bhushan <r65777@freescale.com>
Cc: joro@8bytes.org, benh@kernel.crashing.org, galak@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        iommu@lists.linux-foundation.org,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Date: Wed, 25 Sep 2013 10:40:27 -0600
In-Reply-To: <1379575763-2091-6-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-6-git-send-email-Bharat.Bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 210db24..8a8156a 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -181,7 +181,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			       size_t count, loff_t *ppos, bool iswrite)
>  {
>  	int ret;
> -	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	loff_t off;
> +	u64 pos = (u64 )(*ppos & VFIO_PCI_OFFSET_MASK);
>  	void __iomem *iomem = NULL;
>  	unsigned int rsrc;
>  	bool is_ioport;

What's the compile error that this fixes?

