Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3FEHKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:10:53 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47150 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3FEHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:10:52 -0400
Message-ID: <51AEE473.6020402@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:10:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] workqueue: move the internal helper from .h to .c
References: <51AEE452.8080605@linux.vnet.ibm.com>
In-Reply-To: <51AEE452.8080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060507-1396-0000-0000-000003119F80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_workqueue_attrs(), free_workqueue_attrs() and apply_workqueue_attrs()
are only used internally, move them to .c and make them static.

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/workqueue.h |    5 -----
 kernel/workqueue.c        |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..de40c8f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -418,11 +418,6 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
-void free_workqueue_attrs(struct workqueue_attrs *attrs);
-int apply_workqueue_attrs(struct workqueue_struct *wq,
-			  const struct workqueue_attrs *attrs);
-
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
 extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee8e29a..7c2fa6b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3137,6 +3137,11 @@ static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
 	return written;
 }
 
+static struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
+static void free_workqueue_attrs(struct workqueue_attrs *attrs);
+static int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs);
+
 /* prepare workqueue_attrs for sysfs store operations */
 static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
 {
-- 
1.7.4.1

