Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaBQUXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbaBQUXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:23:50 -0500
Subject: [PATCH 0/4] vfio: type1 multi-domain support & kvm-vfio coherency
 checking
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 13:23:49 -0700
Message-ID: <20140217201324.22775.31904.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series switches the vfio type1 IOMMU backend to support multiple
IOMMU domains per container.  As outlined in 1/4, this provides several
advantages, including supporting features like IOMMU_CACHE and allowing
bus_type independence.  With such support, we're able to provide an
interface to indicate the container is fully cache coherent and export
it for use by the external user interface.  This allows the kvm-vfio
pseudo device to properly test for non-coherent DMA rather than assume
it whenever a kvm-vfio device is registered.

A change introduced by 1/4 creates a new, v2 type1 IOMMU backend.  This
type differs subtly in unmap behavior as described in the patch itself.
For QEMU use of VFIO, there's no change and switching to v2 is
transparent.  I'd appreciate any feedback on whether we should simply
call the previous behavior broken or if we should do like implemented
here and support a compatible mode.  Comments welcome.  Thanks,

Alex

---

Alex Williamson (4):
      vfio/iommu_type1: Multi-IOMMU domain support
      vfio/type1: Add extension to test DMA cache coherence of IOMMU
      vfio: Add external user check extension interface
      kvm/vfio: Support for DMA coherent IOMMUs


 drivers/vfio/vfio.c             |    6 
 drivers/vfio/vfio_iommu_type1.c |  656 +++++++++++++++++++++------------------
 include/linux/vfio.h            |    2 
 include/uapi/linux/vfio.h       |    6 
 virt/kvm/vfio.c                 |   27 +-
 5 files changed, 389 insertions(+), 308 deletions(-)
