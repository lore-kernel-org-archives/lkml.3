Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3LQMNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:13:24 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52673 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQMNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:13:22 -0500
Date: Tue, 17 Dec 2013 17:43:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Buesch <m@bues.ch>, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] drivers: ssb: Remove unused function ssb_sdio_func_to_bus()
 in main.c
Message-ID: <20131217121314.GA27839@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function ssb_sdio_func_to_bus() in main.c.

This eliminates the following warning in main.c:
drivers/ssb/main.c:94:17: warning: no previous prototype for ‘ssb_sdio_func_to_bus’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/ssb/main.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 32a811d..8138952 100644
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
1.7.9.5

