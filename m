Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaETQk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:40:56 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:47858 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbaETQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:40:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAPOEe1NbsnsG/2dsb2JhbABZgwarCAQBAQEBAQEFAYM6lm4CAoEcF3SCZj8YgQIkE4hFAdQbhVWIeYRHAQOPPIorAYsSiA6DOjs
Date: Tue, 20 May 2014 18:40:44 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/video/fbdev/nvidia/nv_hw.c: replace shift loop
 by ilog2
Message-Id: <20140520184044.3f637e58aa8d67a062c621d5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes function nv30UpdateArbitrationSettings
which was completely written with spaces at start of lines.

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/video/fbdev/nvidia/nv_hw.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/video/fbdev/nvidia/nv_hw.c b/drivers/video/fbdev/nvidia/nv_hw.c
index 81c80ac..2058c52 100644
--- a/drivers/video/fbdev/nvidia/nv_hw.c
+++ b/drivers/video/fbdev/nvidia/nv_hw.c
@@ -405,9 +405,7 @@ static void nv4UpdateArbitrationSettings(unsigned VClk,
 	nv4CalcArbitration(&fifo_data, &sim_data);
 	if (fifo_data.valid) {
 		int b = fifo_data.graphics_burst_size >> 4;
-		*burst = 0;
-		while (b >>= 1)
-			(*burst)++;
+		*burst = ilog2(b);
 		*lwm = fifo_data.graphics_lwm >> 3;
 	}
 }
@@ -645,9 +643,7 @@ static void nv10UpdateArbitrationSettings(unsigned VClk,
 	nv10CalcArbitration(&fifo_data, &sim_data);
 	if (fifo_data.valid) {
 		int b = fifo_data.graphics_burst_size >> 4;
-		*burst = 0;
-		while (b >>= 1)
-			(*burst)++;
+		*burst = ilog2(b);
 		*lwm = fifo_data.graphics_lwm >> 3;
 	}
 }
@@ -658,19 +654,18 @@ static void nv30UpdateArbitrationSettings (
     unsigned int      *lwm
 )
 {
-    unsigned int MClk, NVClk;
-    unsigned int fifo_size, burst_size, graphics_lwm;
+	unsigned int MClk, NVClk;
+	unsigned int fifo_size, burst_size, graphics_lwm;
 
-    fifo_size = 2048;
-    burst_size = 512;
-    graphics_lwm = fifo_size - burst_size;
+	fifo_size = 2048;
+	burst_size = 512;
+	graphics_lwm = fifo_size - burst_size;
 
-    nvGetClocks(par, &MClk, &NVClk);
+	nvGetClocks(par, &MClk, &NVClk);
 
-    *burst = 0;
-    burst_size >>= 5;
-    while(burst_size >>= 1) (*burst)++;
-    *lwm = graphics_lwm >> 3;
+	burst_size >>= 5;
+	*burst = ilog2(burst_size);
+	*lwm = graphics_lwm >> 3;
 }
 
 static void nForceUpdateArbitrationSettings(unsigned VClk,
@@ -746,9 +741,7 @@ static void nForceUpdateArbitrationSettings(unsigned VClk,
 	nv10CalcArbitration(&fifo_data, &sim_data);
 	if (fifo_data.valid) {
 		int b = fifo_data.graphics_burst_size >> 4;
-		*burst = 0;
-		while (b >>= 1)
-			(*burst)++;
+		*burst = ilog2(b);
 		*lwm = fifo_data.graphics_lwm >> 3;
 	}
 }
-- 
1.8.4.5

