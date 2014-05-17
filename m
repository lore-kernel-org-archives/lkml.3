Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaEQTdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:33:08 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:59060 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbaEQTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:33:07 -0400
Message-ID: <1400355184.23222.22.camel@x220>
Subject: [PATCH] m32r: remove check for CONFIG_MEMHOLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Date: Sat, 17 May 2014 21:33:04 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2014 19:33:04.0530 (UTC) FILETIME=[D293B720:01CF7206]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a check for CONFIG_MEMHOLE in m32r's code ever since it was
added in v2.6.9. But there has never been a Kconfig symbol MEMHOLE.
(Neither have there been Kconfig symbols MEMHOLE_START and
MEMHOLE_SIZE, by the way.) Remove this check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/m32r/kernel/setup.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 0392112a5d70..4975c4555fe8 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -186,14 +186,6 @@ static unsigned long __init setup_memory(void)
 	 */
 	reserve_bootmem(CONFIG_MEMORY_START, PAGE_SIZE, BOOTMEM_DEFAULT);
 
-	/*
-	 * reserve memory hole
-	 */
-#ifdef CONFIG_MEMHOLE
-	reserve_bootmem(CONFIG_MEMHOLE_START, CONFIG_MEMHOLE_SIZE,
-			BOOTMEM_DEFAULT);
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
-- 
1.9.0

