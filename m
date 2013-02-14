Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150Ab3BNWth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:49:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161118Ab3BNWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Mugunthan V N <mugunthanvnm@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 6/9] net: cwdavinci_cpdma: export symbols for cpsw
Date: Thu, 14 Feb 2013 23:47:48 +0100
Message-Id: <1360882071-4072668-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8YI3wWkiFMJoADfctdExrtuLZh2tvQXvzZxMrYaRmhM
 6ddNXLuqPf5HeU1dIoRSIFJ6H9S4jwyme4jk6omm7kdCjbHPld
 DM1XruhdTHhzjGUHrMXJs35JObAv+kybcSQz8ZLRijmxIA0pog
 Ziaxsd0szpsCYELcTMFN4Z4SkaqF8Qg40MVtsqbsjap1eB5g4E
 iBZWqq2muwRLVn2WB4ly1cPABecylgD5CL5WY3YYO8g7jotoWG
 D2uF2+21tcQPbzKZ60Kj1a0JCK1nPpQHK50//gziOHwvxsgscI
 No+TDEXwCey1rEtsYcGHEMRcyoKT/RIoOT4oDL5Rag1bIoWxXX
 J2qsE5RWk0QmqTqpeqW8H+YEMt1aI6p8WmBUd3tKd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the support for ARM AM33xx in multiplatform kernels
in 3.9, an older bug appears in ARM allmodconfig:
When the cpsw driver is built as a module with cpdma
support enabled, it uses symbols that the cpdma driver
does not export.

Without this patch, building allmodconfig results in:

ERROR: "cpdma_ctlr_int_ctrl" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
ERROR: "cpdma_control_set" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
ERROR: "cpdma_ctlr_eoi" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 7d3bffd..8eeb7c9 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -492,11 +492,13 @@ int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_int_ctrl);
 
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr)
 {
 	dma_reg_write(ctlr, CPDMA_MACEOIVECTOR, 0);
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_eoi);
 
 struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr *ctlr, int chan_num,
 				     cpdma_handler_fn handler)
@@ -1028,3 +1030,4 @@ unlock_ret:
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_control_set);
-- 
1.8.1.2

