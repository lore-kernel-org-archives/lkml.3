Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaEVUVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:21:55 -0400
Received: from mout.gmx.net ([212.227.15.15]:63484 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaEVUVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:21:51 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: jeffrey.t.kirsher@intel.com
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] e1000: Use time_after() for time comparison
Date: Thu, 22 May 2014 22:21:30 +0200
Message-Id: <1400790090-13404-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:aYKZZHS0UwOEH/G06r38lBE5AiRPCC+X8C3KdVYahBQ+JhYq/r8
 GQ8urFwWZ+R4TCkzT6png2mHJm5io6TdBTbwgd2sPeSVh9fmLYsf/b4pnlqfaODAo/LtxPW
 d1Q9rDymYWKZYfM/NqNs785fsW39oepsYN6yQfCmFfAsuMyMeE0m0yrmZ95DO4iGki6VnbU
 3EkV0+Ke/+aQF+toDoWnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 73a8aee..1cbf281 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1460,7 +1460,8 @@ static int e1000_run_loopback_test(struct e1000_adapter *adapter)
 			 * enough time to complete the receives, if it's
 			 * exceeded, break and error off
 			 */
-		} while (good_cnt < 64 && jiffies < (time + 20));
+		} while (good_cnt < 64 && time_after(time + 20, jiffies));
+
 		if (good_cnt != 64) {
 			ret_val = 13; /* ret_val is the same as mis-compare */
 			break;
-- 
1.7.10.4

