Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab3CSGrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:47:20 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45643 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976Ab3CSGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:47:16 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 2/3] lib/kobject: Panic when kobj or ktype is not properly assigned 
Date: Tue, 19 Mar 2013 14:47:00 +0800
Message-Id: <1363675621-31186-2-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031906-0542-0000-0000-000004B3188E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

kobj and ktype are two important attributes which will be used after kobject_init(),
and (!kobj)|(!ktype) may cause FS corruption which could not be recovered.
Panic instead of dump_stack() when neither kobj nor ktype is properly assigned to
detect the bug early.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 279a172..ff9b3c3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -290,7 +290,7 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 
 error:
 	printk(KERN_ERR "kobject (%p): %s\n", kobj, err_str);
-	dump_stack();
+	BUG_ON(1);
 }
 EXPORT_SYMBOL(kobject_init);
 
-- 
1.7.9.5

