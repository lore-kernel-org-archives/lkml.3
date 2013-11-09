Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3KIG4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:56:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab3KIGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [PATCH 3.11 92/94] NTB: Correct Number of Scratch Pad Registers
Date: Fri,  8 Nov 2013 22:52:38 -0800
Message-Id: <20131109065210.741755673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit 87034511519815259e37336f52edf06d114d43b6 upstream.

The NTB Xeon hardware has 16 scratch pad registers and 16 back-to-back
scratch pad registers.  Correct the #define to represent this and update
the variable names to reflect their usage.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_hw.c   |    2 +-
 drivers/ntb/ntb_regs.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -547,7 +547,7 @@ static int ntb_xeon_setup(struct ntb_dev
 	if (ndev->conn_type == NTB_CONN_B2B) {
 		ndev->reg_ofs.sdb = ndev->reg_base + SNB_B2B_DOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_B2B_SPAD_OFFSET;
-		ndev->limits.max_spads = SNB_MAX_SPADS;
+		ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
 	} else {
 		ndev->reg_ofs.sdb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_SPAD_OFFSET;
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


