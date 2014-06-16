Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaFPTys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaFPTyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:54:47 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: reduce scope of audit_net_id
Date: Mon, 16 Jun 2014 15:54:21 -0400
Message-Id: <8554a650c43c7b056557c6af238d7391c70b0d11.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_net_id isn't used outside kernel/audit.c.  Reduce its scope.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 59c0bbe..bdd0172 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -126,7 +126,7 @@ static atomic_t    audit_lost = ATOMIC_INIT(0);
 
 /* The netlink socket. */
 static struct sock *audit_sock;
-int audit_net_id;
+static int audit_net_id;
 
 /* Hash for inode-based rules */
 struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
-- 
1.7.1

