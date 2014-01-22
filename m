Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaAVCk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:40:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46879 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaAVCk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:40:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] uapi: convert u64 to __u64 in exported headers
Date: Tue, 21 Jan 2014 21:40:26 -0500
Message-Id: <1390358426-8884-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u64 type is not defined in any exported kernel headers, so trying
to use it will lead to build failures.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/uapi/linux/nfs4.h       | 2 +-
 include/uapi/linux/perf_event.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nfs4.h b/include/uapi/linux/nfs4.h
index 788128e..35f5f4c 100644
--- a/include/uapi/linux/nfs4.h
+++ b/include/uapi/linux/nfs4.h
@@ -150,7 +150,7 @@
 #define NFS4_SECINFO_STYLE4_CURRENT_FH	0
 #define NFS4_SECINFO_STYLE4_PARENT	1
 
-#define NFS4_MAX_UINT64	(~(u64)0)
+#define NFS4_MAX_UINT64	(~(__u64)0)
 
 /* An NFS4 sessions server must support at least NFS4_MAX_OPS operations.
  * If a compound requires more operations, adjust NFS4_MAX_OPS accordingly.
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 959d454..7a3fed5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -787,7 +787,7 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_SHIFT	26
 
 #define PERF_MEM_S(a, s) \
-	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
+	(((__u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
 /*
  * single taken branch record layout:
-- 
1.8.4.3

