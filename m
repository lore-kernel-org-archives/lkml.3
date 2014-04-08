Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaDHB7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:59:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:26233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbaDHB7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:59:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516557720"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3/9] NTB: Fix typo in setting one translation register
Date: Mon,  7 Apr 2014 17:52:48 -0700
Message-Id: <1396918374-5196-4-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

In the code for Xeon devices in back-to-back mode with xeon_errata_workaround
disabled, the downstream device puts the wrong value in SNB_B2B_XLAT_OFFSETL
(SNB_MBAR01_DSD_ADDR vs. SNB_MBAR01_USD_ADDR).

This was spotted while reading code, since the typo has no practical effect,
at least for now: the low 32 bits of both constants are actually identical
anyway.  However, it's clearer and safer to use the right name.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 170e8e6..2774d35 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -785,7 +785,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 				/* B2B_XLAT_OFFSET is a 64bit register, but can
 				 * only take 32bit writes
 				 */
-				writel(SNB_MBAR01_DSD_ADDR & 0xffffffff,
+				writel(SNB_MBAR01_USD_ADDR & 0xffffffff,
 				       ndev->reg_base + SNB_B2B_XLAT_OFFSETL);
 				writel(SNB_MBAR01_USD_ADDR >> 32,
 				       ndev->reg_base + SNB_B2B_XLAT_OFFSETU);
-- 
1.8.3.2

