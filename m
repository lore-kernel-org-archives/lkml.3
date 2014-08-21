Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaHUBKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaHUBK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:10:27 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com,
        serge@hallyn.com
Subject: [PATCH V4 5/8] namespaces: expose ns_entries
Date: Wed, 20 Aug 2014 21:09:38 -0400
Message-Id: <91b9d8da8145ec17b28283b1e3978edcbb0f9e09.1408581429.git.rgb@redhat.com>
In-Reply-To: <cover.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
In-Reply-To: <cover.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose ns_entries so subsystems other than proc can use this set of namespace
operations.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/proc/namespaces.c    |    2 +-
 include/linux/proc_ns.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index e953e0a..29c3909 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -15,7 +15,7 @@
 #include "internal.h"
 
 
-static const struct proc_ns_operations *ns_entries[] = {
+const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_NET_NS
 	&netns_operations,
 #endif
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index aaafe3e..f4563db 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -28,6 +28,7 @@ extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
+extern const struct proc_ns_operations *ns_entries[];
 
 /*
  * We always define these enumerators
-- 
1.7.1

