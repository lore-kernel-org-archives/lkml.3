Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbbALSVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:21:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbbALSGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 064/216] ath9k: fix BE/BK queue order
Date: Mon, 12 Jan 2015 18:03:01 +0000
Message-Id: <1421085933-32536-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78063d81d353e10cbdd279c490593113b8fdae1c upstream.

Hardware queues are ordered by priority. Use queue index 0 for BK, which
has lower priority than BE.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0acd4b5a4892..32ae0a47fed0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -216,8 +216,8 @@
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
2.1.4

