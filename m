Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3EXRYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab3EXRYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:24:31 -0400
Subject: [PATCH 0/2] vfio: type1 iommu hugepage support
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 24 May 2013 11:24:26 -0600
Message-ID: <20130524171613.14229.84050.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series let's the vfio type1 iommu backend take advantage of iommu
large page support.  See patch 2/2 for the details.  This has been
tested on both amd_iommu and intel_iommu, but only my AMD system has
large page support.  I'd appreciate any testing and feedback on other
systems, particularly vt-d systems supporting large pages.  Mapping
efficiency should be improved a bit without iommu hugepages, but I
hope that it's much more noticeable with huge pages, especially for
very large QEMU guests.

This change includes a clarification to the mapping expectations for
users of the type1 iommu, but is compatible with known users and works
with existing QEMU userspace supporting vfio.  Thanks,

Alex

---

Alex Williamson (2):
      vfio: Convert type1 iommu to use rbtree
      vfio: hugepage support for vfio_iommu_type1


 drivers/vfio/vfio_iommu_type1.c |  607 ++++++++++++++++++++++++---------------
 include/uapi/linux/vfio.h       |    8 -
 2 files changed, 387 insertions(+), 228 deletions(-)
