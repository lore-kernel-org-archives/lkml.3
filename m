Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaBUQHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:07:30 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:46654 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932264AbaBUQH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:07:29 -0500
From: Roland Dreier <roland@kernel.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NTB: Fix typo in setting one translation register
Date: Fri, 21 Feb 2014 08:07:21 -0800
Message-Id: <1392998841-17728-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.0
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
---
 drivers/ntb/ntb_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 170e8e60cdb7..2774d356b689 100644
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
1.9.0

