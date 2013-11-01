Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3KALxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:53:41 -0400
Received: from 8bytes.org ([85.214.48.195]:37988 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3KALxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:53:39 -0400
Date: Fri, 1 Nov 2013 12:53:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] vfio, iommu: Fixed interaction of VFIO_IOMMU_MAP_DMA
 with IOMMU address limits
Message-ID: <20131101115336.GH17455@8bytes.org>
References: <1377704672.10408.81.camel@ul30vt.home>
 <1381305832-2900-1-git-send-email-jsteckli@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381305832-2900-1-git-send-email-jsteckli@os.inf.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 12:53:38 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5273964220861331913964
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 10:03:52AM +0200, Julian Stecklina wrote:
> The BUG_ON in drivers/iommu/intel-iommu.c:785 can be triggered from userspace via
> VFIO by calling the VFIO_IOMMU_MAP_DMA ioctl on a vfio device with any address
> beyond the addressing capabilities of the IOMMU. The problem is that the ioctl code
> calls iommu_iova_to_phys before it calls iommu_map. iommu_map handles the case that
> it gets addresses beyond the addressing capabilities of its IOMMU.
> intel_iommu_iova_to_phys does not.
> 
> This patch fixes iommu_iova_to_phys to return NULL for addresses beyond what the
> IOMMU can handle. This in turn causes the ioctl call to fail in iommu_map and
> (correctly) return EFAULT to the user with a helpful warning message in the kernel
> log.
> 
> Signed-off-by: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

