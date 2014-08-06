Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaHFElx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:41:53 -0400
Received: from s87.loopia.se ([194.9.94.112]:32123 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaHFElu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:41:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 01/15] sparc: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:41:36 -0700
Message-Id: <1407300096-32151-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 arch/sparc/kernel/smp_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 7958242..b3a5d81 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -68,7 +68,7 @@ void smp_store_cpu_info(int id)
 	mid = cpu_get_hwmid(cpu_node);
 
 	if (mid < 0) {
-		printk(KERN_NOTICE "No MID found for CPU%d at node 0x%08d", id, cpu_node);
+		printk(KERN_NOTICE "No MID found for CPU%d at node 0x%08x", id, cpu_node);
 		mid = 0;
 	}
 	cpu_data(id).mid = mid;
-- 
2.0.0.526.g5318336

