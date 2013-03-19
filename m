Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab3CSGrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:47:14 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45635 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976Ab3CSGrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:47:13 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 1/3] lib/kobject: simplify the kobject_init function
Date: Tue, 19 Mar 2013 14:46:59 +0800
Message-Id: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031906-0542-0000-0000-000004B31888
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

The printk() function at the end of function kobject_init() already had '\n',
so remove the duplicated one.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..279a172 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -274,7 +274,7 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 		goto error;
 	}
 	if (!ktype) {
-		err_str = "must have a ktype to be initialized properly!\n";
+		err_str = "must have a ktype to be initialized properly!";
 		goto error;
 	}
 	if (kobj->state_initialized) {
-- 
1.7.9.5

