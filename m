Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3COQQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:16:24 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56019 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab3COQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:16:23 -0400
Message-ID: <1363364177.1335.123.camel@x61.thuisdomein>
Subject: [PATCH] arc: remove #ifdef-ed out include of dead header
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-snps-arc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 17:16:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 16:16:18.0042 (UTC) FILETIME=[6C8F9DA0:01CE2198]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no (Kconfig) macro CONFIG_BLOCK_DEV_RAM. (CONFIG_BLK_DEV_RAM
does exist though.) But linux/blk.h got killed in 2005 anyway (in a
patch titled "kill blk.h"), so these three lines can be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested (no relevant hardware or compiler).

 arch/arc/mm/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index caf797d..6634cf5 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -10,9 +10,6 @@
 #include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
-#ifdef CONFIG_BLOCK_DEV_RAM
-#include <linux/blk.h>
-#endif
 #include <linux/swap.h>
 #include <linux/module.h>
 #include <asm/page.h>
-- 
1.7.11.7

