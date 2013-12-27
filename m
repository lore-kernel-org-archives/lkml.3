Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3L0Wkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:40:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20204 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3L0Wkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:40:35 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE fix
Date: Fri, 27 Dec 2013 17:40:18 -0500
Message-Id: <1388184018-11396-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I messed up and forgot to commit this fix before sending out the original
patch.

It fixes build issues in various files using VM_BUG_ON_PAGE.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/mmdebug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index e522734..8bb6490 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -2,6 +2,7 @@
 #define LINUX_MM_DEBUG_H 1
 
 #ifdef CONFIG_DEBUG_VM
+extern void dump_page(struct page *page);
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
 	do { if (unlikely(cond)) { dump_page(page); BUG(); } } while(0)
-- 
1.8.3.2

