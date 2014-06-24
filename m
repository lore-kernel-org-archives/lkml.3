Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaFXPkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:40:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37777 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaFXPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:40:04 -0400
Date: Tue, 24 Jun 2014 16:39:59 +0100
From: Daniel Walter <dwalter@google.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ar7: replace mac address parsing
Message-ID: <20140624153959.GA19564@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sscanf() with mac_pton().

Signed-off-by: Daniel Walter <dwalter@google.com>
---

 arch/mips/ar7/platform.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
---
diff --git a/arch/mips/ar7/platform.c b/arch/mips/ar7/platform.c
index 7e2356f..653cbff 100644
--- a/arch/mips/ar7/platform.c
+++ b/arch/mips/ar7/platform.c
@@ -307,10 +307,7 @@ static void __init cpmac_get_mac(int instance, unsigned char *dev_addr)
 	}
 
 	if (mac) {
-		if (sscanf(mac, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
-					&dev_addr[0], &dev_addr[1],
-					&dev_addr[2], &dev_addr[3],
-					&dev_addr[4], &dev_addr[5]) != 6) {
+		if (!mac_pton(mac, dev_addr)) {
 			pr_warning("cannot parse mac address, "
 					"using random address\n");
 			eth_random_addr(dev_addr);
