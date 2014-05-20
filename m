Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaETQmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:42:16 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:31414 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbaETQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:42:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWACmFe1NbsnsG/2dsb2JhbABZgwarCAQBAQEBAQEFAYM6lm4CAoEcF3SCZj8YgQIkE4hFAdQbhVWIeYRHAQOPPIorAYsSiA6DOjs
Date: Tue, 20 May 2014 18:42:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/video/fbdev/riva/riva_hw.c: replace shift loop
 by ilog2
Message-Id: <20140520184213.e917b4c5f8f175533372b10d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/video/fbdev/riva/riva_hw.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbdev/riva/riva_hw.c b/drivers/video/fbdev/riva/riva_hw.c
index 78fdbf5..dae3504 100644
--- a/drivers/video/fbdev/riva/riva_hw.c
+++ b/drivers/video/fbdev/riva/riva_hw.c
@@ -640,9 +640,7 @@ static void nv3UpdateArbitrationSettings
     if (fifo_data.valid)
     {
         int  b = fifo_data.graphics_burst_size >> 4;
-        *burst = 0;
-        while (b >>= 1)
-	    (*burst)++;
+	*burst = ilog2(b);
         *lwm   = fifo_data.graphics_lwm >> 3;
     }
     else
@@ -831,9 +829,7 @@ static void nv4UpdateArbitrationSettings
     if (fifo_data.valid)
     {
         int  b = fifo_data.graphics_burst_size >> 4;
-        *burst = 0;
-        while (b >>= 1)
-	    (*burst)++;
+	*burst = ilog2(b);
         *lwm   = fifo_data.graphics_lwm >> 3;
     }
 }
@@ -1096,9 +1092,7 @@ static void nv10UpdateArbitrationSettings
     if (fifo_data.valid)
     {
         int  b = fifo_data.graphics_burst_size >> 4;
-        *burst = 0;
-        while (b >>= 1)
-	    (*burst)++;
+	*burst = ilog2(b);
         *lwm   = fifo_data.graphics_lwm >> 3;
     }
 }
@@ -1150,9 +1144,7 @@ static void nForceUpdateArbitrationSettings
     if (fifo_data.valid)
     {
         int  b = fifo_data.graphics_burst_size >> 4;
-        *burst = 0;
-        while (b >>= 1)
-	    (*burst)++;
+	*burst = ilog2(b);
         *lwm   = fifo_data.graphics_lwm >> 3;
     }
 }
-- 
1.8.4.5
