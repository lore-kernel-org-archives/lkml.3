Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaFPTzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbaFPTzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:55:36 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: reduce scope of audit_log_fcaps
Date: Mon, 16 Jun 2014 15:55:12 -0400
Message-Id: <6e18908afba618ba61edb477eadff961c4104ada.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_fcaps() isn't used outside kernel/audit.c.  Reduce its scope.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 kernel/audit.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index bdd0172..3225a5d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1637,7 +1637,7 @@ void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
 	}
 }
 
-void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
+static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 {
 	kernel_cap_t *perm = &name->fcap.permitted;
 	kernel_cap_t *inh = &name->fcap.inheritable;
diff --git a/kernel/audit.h b/kernel/audit.h
index 7bb6573..3cdffad 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -222,7 +222,6 @@ extern void audit_copy_inode(struct audit_names *name,
 			     const struct inode *inode);
 extern void audit_log_cap(struct audit_buffer *ab, char *prefix,
 			  kernel_cap_t *cap);
-extern void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name);
 extern void audit_log_name(struct audit_context *context,
 			   struct audit_names *n, struct path *path,
 			   int record_num, int *call_panic);
-- 
1.7.1

