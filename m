Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaEJA2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617AbaEJA2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:28:15 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com, serge@hallyn.com,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH V2 5/6] namespaces: expose ns_entries
Date: Fri,  9 May 2014 20:27:26 -0400
Message-Id: <78e1583f2fb1d8577c88d4992311bd66665cc263.1399681022.git.rgb@redhat.com>
In-Reply-To: <cover.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
In-Reply-To: <cover.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
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
index 40bab47..ac5519f 100644
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
index aebb3a2..02979ab 100644
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

