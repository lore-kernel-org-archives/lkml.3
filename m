Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3CSORC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:17:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:45470 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3CSOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:16:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] kernel/srcu: merge common code into a macro
Date: Tue, 19 Mar 2013 15:16:44 +0100
Message-Id: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_SRCU() and DEFINE_STATIC_SRCU() does the same thing except for
the "static" attribute. This patch moves the common pieces into
_DEFINE_SRCU() which is used by the the former macros either adding the
static attribute or not.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/srcu.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 6eb691b..d04acb8 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -102,13 +102,13 @@ void process_srcu(struct work_struct *work);
  * define and init a srcu struct at build time.
  * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
  */
-#define DEFINE_SRCU(name)						\
+#define _DEFINE_SRCU(name, mod)						\
 	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
-	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+	mod struct srcu_struct name =					\
+				__SRCU_STRUCT_INIT(name);
 
-#define DEFINE_STATIC_SRCU(name)					\
-	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
-	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+#define DEFINE_SRCU(name)		_DEFINE_SRCU(name, )
+#define DEFINE_STATIC_SRCU(name)	_DEFINE_SRCU(name, static)
 
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
-- 
1.7.10.4

