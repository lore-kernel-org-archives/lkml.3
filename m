Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931Ab3CWBZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:46554 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422813Ab3CWBZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="274836328"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/29] tsx: Add generic linux/elide.h macros
Date: Fri, 22 Mar 2013 18:24:58 -0700
Message-Id: <1364001923-10796-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For lock elision we (mostly) use generic elide() macros that
can be added to the lock code with minimal intrusion. Add a generic
version that does nothing and is used when RTM is not available.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/elide.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/elide.h

diff --git a/include/linux/elide.h b/include/linux/elide.h
new file mode 100644
index 0000000..95b3ec2
--- /dev/null
+++ b/include/linux/elide.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_ELIDE_H
+#define _LINUX_ELIDE_H 1
+
+#include <linux/rtm.h>
+
+#ifdef CONFIG_RTM_LOCKS
+#include <asm/elide.h>
+#else
+#define elide_lock(l, f) 0
+#define elide_lock_adapt(f, l, a, ac) 0
+#define elide_unlock(l) 0
+#define elide_abort() do {} while (0)
+struct elision_config {};
+#define DEFAULT_ELISION_CONFIG {}
+#define TUNE_ELISION_CONFIG(a, b)
+#endif
+
+#endif
-- 
1.7.7.6

