Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3BKM2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:28:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3BKM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:28:01 -0500
Date: Mon, 11 Feb 2013 04:27:46 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-b91dbe96f6e72471bd00e74791507357e09cfbb5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-6-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-6-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add rbtree support
Git-Commit-ID: b91dbe96f6e72471bd00e74791507357e09cfbb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:27:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b91dbe96f6e72471bd00e74791507357e09cfbb5
Gitweb:     http://git.kernel.org/tip/b91dbe96f6e72471bd00e74791507357e09cfbb5
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:36 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:39 +0100

liblockdep: Add rbtree support

We re-use kernel's rbtree structure for the preload improvement
in the following patches.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-6-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/rbtree.c                          | 1 +
 tools/lib/lockdep/uinclude/linux/rbtree.h           | 1 +
 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/tools/lib/lockdep/rbtree.c b/tools/lib/lockdep/rbtree.c
new file mode 100644
index 0000000..f7f4303
--- /dev/null
+++ b/tools/lib/lockdep/rbtree.c
@@ -0,0 +1 @@
+#include "../../../lib/rbtree.c"
diff --git a/tools/lib/lockdep/uinclude/linux/rbtree.h b/tools/lib/lockdep/uinclude/linux/rbtree.h
new file mode 100644
index 0000000..965901d
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rbtree.h
@@ -0,0 +1 @@
+#include "../../../include/linux/rbtree.h"
diff --git a/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h b/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
new file mode 100644
index 0000000..c375947
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
@@ -0,0 +1,2 @@
+#define __always_inline
+#include "../../../include/linux/rbtree_augmented.h"
