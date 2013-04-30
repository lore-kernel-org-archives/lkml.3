Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3D3Ijm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:39:42 -0400
Received: from smtpout1.laposte.net ([193.253.67.226]:39647 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab3D3Ijk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:39:40 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 04:39:39 EDT
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] memory hotplug: fix warnings
Date: Tue, 30 Apr 2013 10:31:37 +0200
Message-Id: <1367310697-6332-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation warnings:

  mm/slab.c: In function ‘kmem_cache_init_late’:
  mm/slab.c:1778:2: warning: statement with no effect [-Wunused-value]

  mm/page_cgroup.c: In function ‘page_cgroup_init’:
  mm/page_cgroup.c:305:2: warning: statement with no effect [-Wunused-value]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
---
 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 73817af..85c31a8 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -137,7 +137,7 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
 #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
 #else
-#define hotplug_memory_notifier(fn, pri)	(0)
+#define hotplug_memory_notifier(fn, pri)	({ 0; })
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
 #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
-- 
1.7.10.4

