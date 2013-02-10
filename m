Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916Ab3BJAkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:40:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3BJAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 06/11] liblockdep: rbtree support
Date: Sat,  9 Feb 2013 19:39:36 -0500
Message-Id: <1360456781-32462-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We re-use kernel's rbtree structure for the preload improvement in the
following patches.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/rbtree.c                          | 1 +
 tools/lib/lockdep/uinclude/linux/rbtree.h           | 1 +
 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h | 2 ++
 3 files changed, 4 insertions(+)
 create mode 100644 tools/lib/lockdep/rbtree.c
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h

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
-- 
1.8.1.2

