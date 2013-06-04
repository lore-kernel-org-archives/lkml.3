Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3FDRAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:00:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab3FDRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/75] ath9k_hw: Enable manual peak calibration for AR9485
Date: Tue,  4 Jun 2013 09:55:11 -0700
Message-Id: <1370364959-9475-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit e99c60b58b595eaa1c279922ae29d5397c787294 upstream.

Manual peak calibration is currently enabled only for
AR9462 and AR9565. This is also required for AR9485.
The initvals are also modified to disable HW peak calibration.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    | 2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 87fb0bb..d7eef8b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -964,7 +964,7 @@ static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
 {
 	int i;
 
-	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah))
+	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah))
 		return;
 
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index a3710f3..0ec1ca7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -874,7 +874,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.8.1.2

