Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJAR2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:28:11 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:35058 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbaJAR2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:28:10 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org
Subject: [PATCH v2] ssb: Fix Sparse error in main
Date: Wed,  1 Oct 2014 22:58:02 +0530
Message-Id: <1412184482-2603-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes below sparse error:
drivers/ssb/main.c:94:16: warning: symbol 'ssb_sdio_func_to_bus'
was not declared. Should it be static?

Cc: Michael Buesch <m@bues.ch>
Cc: netdev@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
Changes since v1:
Removed the function as it is not called anywhere in the kernel
as per suggestion from Michael Buesch.

 drivers/ssb/main.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 2fead38..1e180c4 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -90,25 +90,6 @@ found:
 }
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
-#ifdef CONFIG_SSB_SDIOHOST
-struct ssb_bus *ssb_sdio_func_to_bus(struct sdio_func *func)
-{
-	struct ssb_bus *bus;
-
-	ssb_buses_lock();
-	list_for_each_entry(bus, &buses, list) {
-		if (bus->bustype == SSB_BUSTYPE_SDIO &&
-		    bus->host_sdio == func)
-			goto found;
-	}
-	bus = NULL;
-found:
-	ssb_buses_unlock();
-
-	return bus;
-}
-#endif /* CONFIG_SSB_SDIOHOST */
-
 int ssb_for_each_bus_call(unsigned long data,
 			  int (*func)(struct ssb_bus *bus, unsigned long data))
 {
-- 
1.8.3.2

