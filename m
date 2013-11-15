Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3KOEcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:32:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43401 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3KOEb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:31:59 -0500
Message-ID: <5285A393.8000808@oracle.com>
Date: Fri, 15 Nov 2013 12:31:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 1/6] list: introduce list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Introduce a trivial helper list_last_entry_or_null() to fetch the
last entry from a list, return NULL if the list is empty.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/linux/list.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index ef95941..3337249 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -384,6 +384,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 	(!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)
 
 /**
+ * list_last_entry_or_null - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_last_entry_or_null(ptr, type, member) \
+	(!list_empty(ptr) ? list_last_entry(ptr, type, member) : NULL)
+
+/**
  * list_next_entry - get the next element in list
  * @pos:	the type * to cursor
  * @member:	the name of the list_struct within the struct.
-- 
1.8.3.2
