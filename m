Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaH2OzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:55:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49511 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaH2OzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:55:12 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/3] Introduce VM_BUG_ON_VMA
Date: Fri, 29 Aug 2014 10:54:18 -0400
Message-Id: <1409324059-28692-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
References: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very similar to VM_BUG_ON_PAGE but dumps VMA information instead.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/mmdebug.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index dfb9333..569e4c8 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -20,12 +20,20 @@ void dump_vma(const struct vm_area_struct *vma);
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_BUG_ON_VMA(cond, vma)					\
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_vma(vma);					\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
+#define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
-- 
1.7.10.4

