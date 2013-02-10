Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab3BJAkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:40:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40750 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3BJAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 07/11] liblockdep: prevent multiple declarations of CALLER_ADDR0
Date: Sat,  9 Feb 2013 19:39:37 -0500
Message-Id: <1360456781-32462-7-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are declared once in the public and once in the private headers, prevent
declaring them twice if both headers are used.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/include/liblockdep/common.h | 3 +++
 tools/lib/lockdep/uinclude/linux/kernel.h     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
index a675ef0..1bad66c 100644
--- a/tools/lib/lockdep/include/liblockdep/common.h
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -3,8 +3,11 @@
 
 #include <pthread.h>
 
+#ifndef CALLER_ADDR0
 #define CALLER_ADDR0 (__builtin_return_address(0))
 #define _THIS_IP_ CALLER_ADDR0
+#endif
+
 #define NR_LOCKDEP_CACHING_CLASSES 2
 #define MAX_LOCKDEP_SUBCLASSES 8UL
 
diff --git a/tools/lib/lockdep/uinclude/linux/kernel.h b/tools/lib/lockdep/uinclude/linux/kernel.h
index da97ce8..af02ac1 100644
--- a/tools/lib/lockdep/uinclude/linux/kernel.h
+++ b/tools/lib/lockdep/uinclude/linux/kernel.h
@@ -28,7 +28,9 @@
 #define noinline
 #define list_add_tail_rcu list_add_tail
 
+#ifndef CALLER_ADDR0
 #define _THIS_IP_ CALLER_ADDR0
 #define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#endif
 
 #endif
-- 
1.8.1.2

