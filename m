Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaJFFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbaJFFJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:26 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 09/13] fork: audit on creation of new namespace(s)
Date: Mon,  6 Oct 2014 01:08:34 -0400
Message-Id: <b9607ab778a84381b4a82cf0110d031f19b17525.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When clone(2) is called to fork a new process creating one or more namespaces,
audit the event to tie the new pid with the namespace IDs.

Signed-off-by: Richard Guy Briggs
---
 kernel/fork.c    |    3 +++
 kernel/nsproxy.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 6a13c46..a7fe4d5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1624,6 +1624,9 @@ long do_fork(unsigned long clone_flags,
 			get_task_struct(p);
 		}
 
+		if (unlikely(clone_flags & CLONE_NEW_MASK)) {
+			audit_log_ns_info(p);
+		}
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 0c2f25e..2cdc16b 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/audit.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
-- 
1.7.1

