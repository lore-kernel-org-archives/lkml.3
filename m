Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab3BFWMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:12:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab3BFWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 06/11] liblockdep: rbtree support
Date: Wed,  6 Feb 2013 17:11:29 -0500
Message-Id: <1360188694-25077-7-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

