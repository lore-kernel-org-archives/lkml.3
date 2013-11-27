Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3K0OJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:09:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3K0OJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:09:50 -0500
Date: Wed, 27 Nov 2013 06:09:19 -0800
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-dbe941827eab53194eda5cd350a4e1414f192658@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371163284-6346-7-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-7-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add pthread_rwlock_t test suite
Git-Commit-ID: dbe941827eab53194eda5cd350a4e1414f192658
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:09:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbe941827eab53194eda5cd350a4e1414f192658
Gitweb:     http://git.kernel.org/tip/dbe941827eab53194eda5cd350a4e1414f192658
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 13 Jun 2013 18:41:21 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:55:24 +0100

liblockdep: Add pthread_rwlock_t test suite

A simple test to make sure we handle rwlocks correctly.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/1371163284-6346-7-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/tests/WW.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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
