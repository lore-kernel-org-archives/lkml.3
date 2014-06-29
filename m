Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaF2IDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:03:19 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:25686 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbaF2IDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:03:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkIAEvHr1NbsmJR/2dsb2JhbABZgw2sLwsFAW4BkgaHQIEHF3WECwIkLyOBCRE3iEYBxgMXhWSJIx2ELQWPeod6gmqLP4g+g0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org
Subject: [PATCH 1/1] iommu/fsl_pamu: Remove unnecessary null test before kfree
Date: Sun, 29 Jun 2014 10:01:26 +0200
Message-Id: <1404028886-5060-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: iommu@lists.linux-foundation.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/iommu/fsl_pamu_domain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 93072ba..0009dff 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -1118,8 +1118,7 @@ static int fsl_pamu_set_windows(struct iommu_domain *domain, u32 w_count)
 	ret = pamu_set_domain_geometry(dma_domain, &domain->geometry,
 				((w_count > 1) ? w_count : 0));
 	if (!ret) {
-		if (dma_domain->win_arr)
-			kfree(dma_domain->win_arr);
+		kfree(dma_domain->win_arr);
 		dma_domain->win_arr = kzalloc(sizeof(struct dma_window) *
 							  w_count, GFP_ATOMIC);
 		if (!dma_domain->win_arr) {
-- 
1.8.4.5

