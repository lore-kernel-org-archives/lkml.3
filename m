Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaKTM3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:29:21 -0500
Received: from bes.se.axis.com ([195.60.68.10]:42070 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaKTM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:29:19 -0500
From: Niklas Svensson <niklas.svensson@axis.com>
To: <ralf@linux-mips.org>, <paul.burton@imgtec.com>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Niklas Svensson <niklass@axis.com>
Subject: [PATCH] MIPS: mips-cm: CM regions are disabled at boot
Date: Thu, 20 Nov 2014 13:29:00 +0100
Message-ID: <1416486540-28681-1-git-send-email-niklass@axis.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each CM_REGION_TARGET is set to disabled at boot,
so there is no need to disable the matching
CM_GCR_REG explicitly.

Signed-off-by: Niklas Svensson <niklass@axis.com>
---
 arch/mips/kernel/mips-cm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index f76f7a0..a4bbfd9 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -104,16 +104,6 @@ int mips_cm_probe(void)
 	base_reg |= CM_GCR_BASE_CMDEFTGT_MEM;
 	write_gcr_base(base_reg);
 
-	/* disable CM regions */
-	write_gcr_reg0_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
-	write_gcr_reg0_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
-	write_gcr_reg1_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
-	write_gcr_reg1_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
-	write_gcr_reg2_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
-	write_gcr_reg2_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
-	write_gcr_reg3_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
-	write_gcr_reg3_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
-
 	/* probe for an L2-only sync region */
 	mips_cm_probe_l2sync();
 
-- 
2.1.3

