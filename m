Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969Ab3BTTlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:41:51 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42192 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3BTTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:41:47 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: [RFC/PATCH 1/5] context tracking: conditionalize guest support based on CONFIG_KVM
Date: Wed, 20 Feb 2013 11:41:38 -0800
Message-Id: <1361389302-11968-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361389302-11968-1-git-send-email-khilman@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can build on !KVM systems too.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/context_tracking.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 74f68f4..6fe96b1 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -1,5 +1,7 @@
 #include <linux/context_tracking.h>
+#ifdef CONFIG_KVM
 #include <linux/kvm_host.h>
+#endif
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
@@ -62,6 +64,7 @@ void user_exit(void)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_KVM
 void guest_enter(void)
 {
 	if (vtime_accounting_enabled())
@@ -79,6 +82,7 @@ void guest_exit(void)
 		__guest_exit();
 }
 EXPORT_SYMBOL_GPL(guest_exit);
+#endif
 
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
-- 
1.8.1.2

