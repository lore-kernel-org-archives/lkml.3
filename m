Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3BZPMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497Ab3BZPML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:12:11 -0500
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] amd_iommu_init: remove __init from amd_iommu_erratum_746_workaround
Date: Tue, 26 Feb 2013 16:12:05 +0100
Message-Id: <a6e63dc6f1bdc2d20f3d7d07a5d878e9c1b01d85.1361891160.git.npajkovs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 318fe78 ("IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround")
added amd_iommu_erratum_746_workaround and it's marked as __init, which is wrong

WARNING: drivers/iommu/built-in.o(.text+0x639c): Section mismatch in reference from the function iommu_init_pci() to the function .init.text:amd_iommu_erratum_746_workaround()
The function iommu_init_pci() references
the function __init amd_iommu_erratum_746_workaround().
This is often because iommu_init_pci lacks a __init
annotation or the annotation of amd_iommu_erratum_746_workaround is wrong.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index faf10ba..9761a4f 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -980,7 +980,7 @@ static void __init free_iommu_all(void)
  *     BIOS should disable L2B micellaneous clock gating by setting
  *     L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b
  */
-static void __init amd_iommu_erratum_746_workaround(struct amd_iommu *iommu)
+static void amd_iommu_erratum_746_workaround(struct amd_iommu *iommu)
 {
 	u32 value;
 
-- 
1.7.1

