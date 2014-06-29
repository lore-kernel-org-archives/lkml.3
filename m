Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaF2HRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:17:42 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37887 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbaF2HRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:17:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcIAMe8r1NbsmJR/2dsb2JhbABagw2sLwsFAW4BmUaBBxd1hGAjgRo3iEYBxX8XhWSJIx2ELQWaXos/iD6CAIFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 1/1] MIPS: Octeon: remove unnecessary null test before debugfs_remove_recursive
Date: Sun, 29 Jun 2014 09:16:19 +0200
Message-Id: <1404026179-2910-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/mips/cavium-octeon/oct_ilm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/oct_ilm.c b/arch/mips/cavium-octeon/oct_ilm.c
index 71b213d..2d68a39 100644
--- a/arch/mips/cavium-octeon/oct_ilm.c
+++ b/arch/mips/cavium-octeon/oct_ilm.c
@@ -194,8 +194,7 @@ err_irq:
 static __exit void oct_ilm_module_exit(void)
 {
 	disable_timer(TIMER_NUM);
-	if (dir)
-		debugfs_remove_recursive(dir);
+	debugfs_remove_recursive(dir);
 	free_irq(OCTEON_IRQ_TIMER0 + TIMER_NUM, 0);
 }
 
-- 
1.8.4.5

