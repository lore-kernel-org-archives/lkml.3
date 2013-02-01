Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3BAQsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:48:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26263 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab3BAQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:48:12 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 5/7] liblockdep: rwlock test suite
Date: Fri,  1 Feb 2013 11:47:09 -0500
Message-Id: <1359737231-26127-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple test to make sure we handle rwlocks correctly.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/tests/WW.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 tools/lib/lockdep/tests/WW.c

diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
new file mode 100644
index 0000000..4b1be0f
--- /dev/null
+++ b/tools/lib/lockdep/tests/WW.c
@@ -0,0 +1,16 @@
+#include <liblockdep/rwlock.h>
+
+void main(void)
+{
+	pthread_rwlock_t a, b;
+
+	liblockdep_init();
+	liblockdep_set_thread();
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

