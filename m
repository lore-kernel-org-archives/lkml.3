Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaHDAUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:20:11 -0400
Received: from s87.loopia.se ([194.9.94.112]:35413 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaHDAUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:20:06 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 10/19] ath6kl: fix %d confusingly prefixed with 0x in format strings
Date: Sun,  3 Aug 2014 17:19:56 -0700
Message-Id: <1407111596-14944-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/ath/ath6kl/init.c | 2 +-
 drivers/net/wireless/ath/ath6kl/main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index fffd523..91af845 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1049,7 +1049,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ar->hw.reserved_ram_size = le32_to_cpup(val);
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
-				   "found reserved ram size ie 0x%d\n",
+				   "found reserved ram size ie 0x%x\n",
 				   ar->hw.reserved_ram_size);
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 21516bc..933aef0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -225,7 +225,7 @@ int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
 	ret = ath6kl_hif_diag_write32(ar, address, value);
 
 	if (ret) {
-		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
+		ath6kl_err("failed to write 0x%x during diagnose window to 0x%x\n",
 			   address, value);
 		return ret;
 	}
-- 
2.0.0.526.g5318336

