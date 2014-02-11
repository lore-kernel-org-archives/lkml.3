Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBKVKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:10:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:45340 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbaBKVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:10:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] rcu: fix sparse warning for rcu_expedited from kernel/ksysfs.c
Date: Tue, 11 Feb 2014 16:10:12 -0500
Message-ID: <1392153012-14378-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

kernel/ksysfs.c:143:5: warning: symbol 'rcu_expedited' was not declared. Should it be static?

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/ksysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index d945a949760f..53476a147b9a 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -19,6 +19,8 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 
+#include "rcu/rcu.h"	/* rcu_expedited */
+
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
-- 
1.8.5.2

