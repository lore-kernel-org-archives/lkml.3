Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaISCSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaISCSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:18:31 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com
Subject: [PATCH] audit: remove open_arg() function that is never used
Date: Thu, 18 Sep 2014 22:17:56 -0400
Message-Id: <7798658322e73d36d5754922920efe37d7f1cd59.1411092980.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

open_arg() was added in commit 55669bfa "audit: AUDIT_PERM support"
and never used.  Remove it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4e17443..63a74a7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -126,14 +126,6 @@ struct audit_tree_refs {
 	struct audit_chunk *c[31];
 };
 
-static inline int open_arg(int flags, int mask)
-{
-	int n = ACC_MODE(flags);
-	if (flags & (O_TRUNC | O_CREAT))
-		n |= AUDIT_PERM_WRITE;
-	return n & mask;
-}
-
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
 	unsigned n;
-- 
1.7.1

