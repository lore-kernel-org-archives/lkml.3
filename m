Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbaICXEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:04:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbaICWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Brian W. Hart" <hartb@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 074/125] powerpc/powernv: Update dev->dma_mask in pci_set_dma_mask() path
Date: Wed,  3 Sep 2014 15:07:11 -0700
Message-Id: <20140903220625.897009613@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian W Hart <hartb@linux.vnet.ibm.com>

commit a32305bf90a2ae0e6a9a93370c7616565f75e15a upstream.

powerpc defines various machine-specific routines for handling
pci_set_dma_mask().  The routines for machine "PowerNV" may neglect
to set dev->dma_mask.  This could confuse anyone (e.g. drivers) that
consult dev->dma_mask to find the current mask.  Set the dma_mask in
the PowerNV leaf routine.

Signed-off-by: Brian W. Hart <hartb@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -491,6 +491,7 @@ static int pnv_pci_ioda_dma_set_mask(str
 		set_dma_ops(&pdev->dev, &dma_iommu_ops);
 		set_iommu_table_base(&pdev->dev, &pe->tce32_table);
 	}
+	*pdev->dev.dma_mask = dma_mask;
 	return 0;
 }
 


