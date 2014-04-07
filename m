Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaDGW2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbaDGW2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:28:44 -0400
Subject: [PATCH 0/3] vfio: Fix coverity found issues
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 07 Apr 2014 16:28:43 -0600
Message-ID: <20140407221857.12761.73684.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall nothing very serious here.  We botch the size of a PCIe
capability due to a cut-n-paste error, but nobody has noticed due to
the rarity of the capability.  A 32bit host could possibly see some
overflows attempting to do a DMA map, but all of the parameters are
also validated elsewhere, so while this may cause unexepected behavior
for the user, there doesn't appear to be any risk to the host.
Thanks,

Alex

---

Alex Williamson (3):
      vfio/pci: Fix sizing of DPA and THP express capabilities
      vfio/pci: Fix unchecked return value
      vfio/iommu_type1: Avoid overflow


 drivers/vfio/pci/vfio_pci.c        |    3 ++
 drivers/vfio/pci/vfio_pci_config.c |    7 ++----
 drivers/vfio/vfio_iommu_type1.c    |   45 ++++++++++++++----------------------
 3 files changed, 23 insertions(+), 32 deletions(-)
