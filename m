Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BAEtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:49:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23325 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3BAEs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:27 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 5/7] liblock: rwlock test suite
Date: Thu, 31 Jan 2013 23:47:36 -0500
Message-Id: <1359694058-24452-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple test to make sure we handle rwlocks correctly.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/liblock/tests/WW.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 tools/lib/liblock/tests/WW.c

diff --git a/tools/lib/liblock/tests/WW.c b/tools/lib/liblock/tests/WW.c
new file mode 100644
index 0000000..f2d00bd
--- /dev/null
+++ b/tools/lib/liblock/tests/WW.c
@@ -0,0 +1,16 @@
+#include <liblock/rwlock.h>
+
+void main(void)
+{
+	liblock_pthread_rwlock_t a, b;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_rwlock_init(&a, NULL);
+	liblock_pthread_rwlock_init(&b, NULL);
+
+	liblock_pthread_rwlock_wrlock(&a);
+	liblock_pthread_rwlock_rdlock(&b);
+	liblock_pthread_rwlock_wrlock(&a);
+}
-- 
1.8.1.1

