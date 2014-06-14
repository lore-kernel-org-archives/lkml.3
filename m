Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaFNWYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:24:22 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:43531 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaFNWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:24:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIACXKnFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYRgI4ECGDeILgMVAckuDYV+F4VjhnCBP2QdhC0EmEqBeYswgiiGAIF+gUQ7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 1/1] drivers/gpu/drm/msm/msm_iommu.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sun, 15 Jun 2014 00:24:26 +0200
Message-Id: <1402784666-20300-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: David Airlie <airlied@linux.ie>
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/msm/msm_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 92b7459..198ed84 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -110,7 +110,7 @@ static int msm_iommu_unmap(struct msm_mmu *mmu, uint32_t iova,
 
 		VERB("unmap[%d]: %08x(%x)", i, iova, bytes);
 
-		BUG_ON(!IS_ALIGNED(bytes, PAGE_SIZE));
+		BUG_ON(!PAGE_ALIGNED(bytes));
 
 		da += bytes;
 	}
-- 
1.8.4.5

