Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab3BKXBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:01:23 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22936 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab3BKXBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:01:21 -0500
Message-ID: <1360623670.2950.67.camel@lorien2>
Subject: [PATCH 3/4] amd_iommu: Remove local PCI_BUS() define and use
 PCI_BUS() from pci
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: bhelgaas@google.com, Joerg Roedel <joro@8bytes.org>
Cc: tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, shemminger@vyatta.com, jiang.liu@huawei.com,
        linasvepstas@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        dhowells@redhat.com, wangyijing@huawei.com, shuahkhan@gmail.com
Date: Mon, 11 Feb 2013 16:01:10 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to remove local PCI_BUS() define and use the new PCI_BUS interface from
pci.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/iommu/amd_iommu_types.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e38ab43..a07882f 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/pci.h>
 
 /*
  * Maximum number of IOMMUs supported
@@ -315,9 +316,6 @@
 
 #define MAX_DOMAIN_ID 65536
 
-/* FIXME: move this macro to <linux/pci.h> */
-#define PCI_BUS(x) (((x) >> 8) & 0xff)
-
 /* Protection domain flags */
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
-- 
1.7.9.5



