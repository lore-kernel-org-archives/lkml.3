Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3FMWmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:42:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22278 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab3FMWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:42:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [Patch v5 6/9] liblockdep: Add pthread_rwlock_t test suite
Date: Thu, 13 Jun 2013 18:41:21 -0400
Message-Id: <1371163284-6346-7-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple test to make sure we handle rwlocks correctly.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/tests/WW.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 tools/lib/lockdep/tests/WW.c

diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
new file mode 100644
index 0000000..d44f77d
--- /dev/null
+++ b/tools/lib/lockdep/tests/WW.c
@@ -0,0 +1,13 @@
+#include <liblockdep/rwlock.h>
+
+void main(void)
+{
+	pthread_rwlock_t a, b;
+
+	pthread_rwlock_init(&a, NULL);
+	pthread_rwlock_init(&b, NULL);
+
+	pthread_rwlock_wrlock(&a);
+	pthread_rwlock_rdlock(&b);
+	pthread_rwlock_wrlock(&a);
+}
-- 
1.8.1.2

