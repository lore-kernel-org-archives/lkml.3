Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbbA2CgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994AbbA2CgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 063/139] ath9k: fix BE/BK queue order
Date: Wed, 28 Jan 2015 14:20:06 -0800
Message-Id: <1422483682-15393-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78063d81d353e10cbdd279c490593113b8fdae1c upstream.

Hardware queues are ordered by priority. Use queue index 0 for BK, which
has lower priority than BE.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a2c9a5d..6c8e807 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -215,8 +215,8 @@
 #define AH_WOW_BEACON_MISS		BIT(3)
 
 enum ath_hw_txq_subtype {
-	ATH_TXQ_AC_BE = 0,
-	ATH_TXQ_AC_BK = 1,
+	ATH_TXQ_AC_BK = 0,
+	ATH_TXQ_AC_BE = 1,
 	ATH_TXQ_AC_VI = 2,
 	ATH_TXQ_AC_VO = 3,
 };
-- 
1.9.1

