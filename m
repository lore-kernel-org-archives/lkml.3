Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab3DBXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:16:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab3DBWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 020/124] b43: N-PHY: increase initial value of "mind" in RSSI calibration
Date: Tue,  2 Apr 2013 15:10:02 -0700
Message-Id: <20130402221106.532477855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1615,7 +1615,7 @@ static void b43_nphy_rev3_rssi_cal(struc
 		}
 		for (i = 0; i < 4; i += 2) {
 			s32 curr;
-			s32 mind = 40;
+			s32 mind = 0x100000;
 			s32 minpoll = 249;
 			u8 minvcm = 0;
 			if (2 * core != i)
@@ -1799,7 +1799,7 @@ static void b43_nphy_rev2_rssi_cal(struc
 	}
 
 	for (i = 0; i < 4; i++) {
-		s32 mind = 40;
+		s32 mind = 0x100000;
 		u8 minvcm = 0;
 		s32 minpoll = 249;
 		s32 curr;


