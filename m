Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205Ab3DKVAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:00:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935800Ab3DKUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:22 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZDYxgX4iq60A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=v8_7Gzy7jK4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=ci0R9jrIFp8a7j49ubkA:9 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202600.596526625@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 088/171 ] b43: N-PHY: increase initial value of "mind" in RSSI calibration
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0088-b43-N-PHY-increase-initial-value-of-mind-in-RSSI-cal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

[ Upstream commit e67dd874e60529dbd2e8232babb1e23479ba2ffa ]

We're using "mind" variable to find the VCM that got the best polling
results. For each VCM we calculte "currd" which is compared to the
"mind". For PHY rev3+ "currd" gets values around 14k-40k. Looking for a
value smaller than 40 makes no sense, so increase the initial value.

This fixes a regression introduced in 3.4 by commit:
e0c9a0219a8f542e3946fe972a68aacf8c3f906c
(my BCM4322 performance dropped from 18,4Mb/s to 9,26Mb/s)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b92bb9c..e167a88 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1371,7 +1371,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		}
 		for (i = 0; i < 4; i += 2) {
 			s32 curr;
-			s32 mind = 40;
+			s32 mind = 0x100000;
 			s32 minpoll = 249;
 			u8 minvcm = 0;
 			if (2 * core != i)
@@ -1555,7 +1555,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	}
 
 	for (i = 0; i < 4; i++) {
-		s32 mind = 40;
+		s32 mind = 0x100000;
 		u8 minvcm = 0;
 		s32 minpoll = 249;
 		s32 curr;
-- 
1.7.10.4


