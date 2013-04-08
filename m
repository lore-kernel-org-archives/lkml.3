Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935948Ab3DHJwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935927Ab3DHJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/102] b43: N-PHY: increase initial value of "mind" in RSSI calibration
Date: Mon,  8 Apr 2013 10:50:43 +0100
Message-Id: <1365414657-29191-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit e67dd874e60529dbd2e8232babb1e23479ba2ffa upstream.

We're using "mind" variable to find the VCM that got the best polling
results. For each VCM we calculte "currd" which is compared to the
"mind". For PHY rev3+ "currd" gets values around 14k-40k. Looking for a
value smaller than 40 makes no sense, so increase the initial value.

This fixes a regression introduced in 3.4 by commit:
e0c9a0219a8f542e3946fe972a68aacf8c3f906c
(my BCM4322 performance dropped from 18,4Mb/s to 9,26Mb/s)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/phy_n.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1081188..5ae0b6a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1371,7 +1371,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		}
 		for (i = 0; i < 4; i++) {
 			s32 curr;
-			s32 mind = 40;
+			s32 mind = 0x100000;
 			s32 minpoll = 249;
 			u8 minvcm = 0;
 			if (2 * core != i)
@@ -1554,7 +1554,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	}
 
 	for (i = 0; i < 4; i++) {
-		s32 mind = 40;
+		s32 mind = 0x100000;
 		u8 minvcm = 0;
 		s32 minpoll = 249;
 		s32 curr;
-- 
1.8.1.2

