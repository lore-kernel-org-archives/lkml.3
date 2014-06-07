Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaFGOBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 10:01:10 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:30118 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbaFGOBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 10:01:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIOAMUZk1NXQ3Uj/2dsb2JhbABYgw2sGQgBAQUBmRCBBBd1hDEvI4EaN4hGAbQpmHwXhV2IK2QdhCsEj1qKR4soiB2DPjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH 1/1] fs/proc/kcore.c: use PAGE_ALIGN instead of ALIGN(PAGE_SIZE)
Date: Sat,  7 Jun 2014 16:00:43 +0200
Message-Id: <1402149643-31534-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/proc/kcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 39e6ef3..6df8d07 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -172,7 +172,7 @@ get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 
 	start = ((unsigned long)pfn_to_page(pfn)) & PAGE_MASK;
 	end = ((unsigned long)pfn_to_page(pfn + nr_pages)) - 1;
-	end = ALIGN(end, PAGE_SIZE);
+	end = PAGE_ALIGN(end);
 	/* overlap check (because we have to align page */
 	list_for_each_entry(tmp, head, list) {
 		if (tmp->type != KCORE_VMEMMAP)
-- 
1.9.1

