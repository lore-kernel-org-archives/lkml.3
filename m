Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDRA5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:57:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52585 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaDRA5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:57:16 -0400
From: Joel Fernandes <joelf@ti.com>
To: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: Joel Fernandes <joelf@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] [FIX] dmaengine: virt-dma: Free descriptor after callback
Date: Thu, 17 Apr 2014 19:56:50 -0500
Message-ID: <1397782610-7370-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free the vd (virt descriptor) after the callback is called.  In EDMA driver
atleast which uses virt-dma, we make use of the desc during the callback and if
its dangerously freed before the callback is called. I also noticed this in
omap-dma dmaengine driver.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/virt-dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/virt-dma.c b/drivers/dma/virt-dma.c
index 6f80432..98aeb7f 100644
--- a/drivers/dma/virt-dma.c
+++ b/drivers/dma/virt-dma.c
@@ -84,10 +84,10 @@ static void vchan_complete(unsigned long arg)
 
 		list_del(&vd->node);
 
-		vc->desc_free(vd);
-
 		if (cb)
 			cb(cb_data);
+
+		vc->desc_free(vd);
 	}
 }
 
-- 
1.7.9.5

