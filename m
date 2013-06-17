Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3FQRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3FQReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: rmanohar@qca.qualcomm.com, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 69/84] Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"
Date: Mon, 17 Jun 2013 10:31:13 -0700
Message-Id: <1371490288-23167-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 96005931785238e1a24febf65ffb5016273e8225 upstream.

This reverts commit 68d9e1fa24d9c7c2e527f49df8d18fb8cf0ec943

This change reduces rx sensitivity with no apparent extra benefit.
It looks like it was meant for testing in a specific scenario,
but it was never properly validated.

Cc: rmanohar@qca.qualcomm.com
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 262e1e0..9269d28 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -778,11 +778,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x1a1a1a1a},
-	{0x0000a084, 0x1a1a1a1a},
-	{0x0000a088, 0x1a1a1a1a},
-	{0x0000a08c, 0x1a1a1a1a},
-	{0x0000a090, 0x171a1a1a},
+	{0x0000a080, 0x22222229},
+	{0x0000a084, 0x1d1d1d1d},
+	{0x0000a088, 0x1d1d1d1d},
+	{0x0000a08c, 0x1d1d1d1d},
+	{0x0000a090, 0x171d1d1d},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},
-- 
1.8.1.2

