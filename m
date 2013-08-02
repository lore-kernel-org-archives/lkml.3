Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3HBRh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:37:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:7753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3HBRhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380903345"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] NTB: Correct Number of Scratch Pad Registers
Date: Fri,  2 Aug 2013 10:35:31 -0700
Message-Id: <1375464944-27914-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NTB Xeon hardware has 16 scratch pad registers and 16 back-to-back
scratch pad registers.  Correct the #define to represent this and update
the variable names to reflect their usage.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |    2 +-
 drivers/ntb/ntb_regs.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 515099e..3b0ab50 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -547,7 +547,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	if (ndev->conn_type == NTB_CONN_B2B) {
 		ndev->reg_ofs.sdb = ndev->reg_base + SNB_B2B_DOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_B2B_SPAD_OFFSET;
-		ndev->limits.max_spads = SNB_MAX_SPADS;
+		ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
 	} else {
 		ndev->reg_ofs.sdb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_SPAD_OFFSET;
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 5bfa8c0..96209b4 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -53,8 +53,8 @@
 #define NTB_LINK_WIDTH_MASK	0x03f0
 
 #define SNB_MSIX_CNT		4
-#define SNB_MAX_SPADS		16
-#define SNB_MAX_COMPAT_SPADS	8
+#define SNB_MAX_B2B_SPADS	16
+#define SNB_MAX_COMPAT_SPADS	16
 /* Reserve the uppermost bit for link interrupt */
 #define SNB_MAX_DB_BITS		15
 #define SNB_DB_BITS_PER_VEC	5
-- 
1.7.9.5

