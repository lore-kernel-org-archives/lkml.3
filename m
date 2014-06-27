Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaF0U7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:59:47 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:10142 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbaF0U7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:59:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAGrarVNXQCoO/2dsb2JhbABbgw2rbwUBAQEBAQEFAW0BmQKBDRd1hGAjgRo3iEYBxFMXhWSJIR2ELQWaXYs/iDyCAIFEOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
Subject: [PATCH 1/1] mm/hwpoison-inject.c: remove unnecessary null test before debugfs_remove_recursive
Date: Fri, 27 Jun 2014 22:58:16 +0200
Message-Id: <1403902696-12162-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required"

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/hwpoison-inject.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 95487c7..329caf5 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -72,8 +72,7 @@ DEFINE_SIMPLE_ATTRIBUTE(unpoison_fops, NULL, hwpoison_unpoison, "%lli\n");
 
 static void pfn_inject_exit(void)
 {
-	if (hwpoison_dir)
-		debugfs_remove_recursive(hwpoison_dir);
+	debugfs_remove_recursive(hwpoison_dir);
 }
 
 static int pfn_inject_init(void)
-- 
1.8.4.5

