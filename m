Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab3CSGrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:47:18 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:43738 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933998Ab3CSGrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:47:17 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 3/3] lib/kobject: WARN_ON corresponds to BUG_ON
Date: Tue, 19 Mar 2013 14:47:01 +0800
Message-Id: <1363675621-31186-3-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031906-5024-0000-0000-000005819064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

WARN_ON corresponds to BUG_ON and also gets more info.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index ff9b3c3..f7d9f31 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -281,7 +281,7 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 		/* do not error out as sometimes we can recover */
 		printk(KERN_ERR "kobject (%p): tried to init an initialized "
 		       "object, something is seriously wrong.\n", kobj);
-		dump_stack();
+		WARN_ON(1);
 	}
 
 	kobject_init_internal(kobj);
-- 
1.7.9.5

