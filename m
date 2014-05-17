Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243AbaEQRQC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:16:02 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65176 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866AbaEQRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:16:00 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] iommu: fsl_pamu.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:16:44 +0200
Message-Id: <1400347004-25368-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/iommu/fsl_pamu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index cba0498..b99dd88 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -592,8 +592,7 @@ found_cpu_node:
 		/* advance to next node in cache hierarchy */
 		node = of_find_node_by_phandle(*prop);
 		if (!node) {
-			pr_debug("Invalid node for cache hierarchy %s\n",
-				node->full_name);
+			pr_debug("Invalid node for cache hierarchy\n");
 			return ~(u32)0;
 		}
 	}
-- 
1.7.10.4

