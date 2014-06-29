Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaF2HZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:25:45 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:28647 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbaF2HZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:25:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcIACq+r1NbsmJR/2dsb2JhbABZgw2sLwsFAW4BmUaBBxd1hDEvI4EaN4hGAcYAF4VkiSMdhC0Fml6LP4g+g0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 1/1] MIPS: jz4740: remove unnecessary null test before debugfs_remove
Date: Sun, 29 Jun 2014 09:24:23 +0200
Message-Id: <1404026663-3510-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove(NULL) is safe this check is probably not required

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/mips/jz4740/clock-debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/jz4740/clock-debugfs.c b/arch/mips/jz4740/clock-debugfs.c
index a8acdef..325422d0 100644
--- a/arch/mips/jz4740/clock-debugfs.c
+++ b/arch/mips/jz4740/clock-debugfs.c
@@ -87,8 +87,7 @@ void jz4740_clock_debugfs_add_clk(struct clk *clk)
 /* TODO: Locking */
 void jz4740_clock_debugfs_update_parent(struct clk *clk)
 {
-	if (clk->debugfs_parent_entry)
-		debugfs_remove(clk->debugfs_parent_entry);
+	debugfs_remove(clk->debugfs_parent_entry);
 
 	if (clk->parent) {
 		char parent_path[100];
-- 
1.8.4.5

