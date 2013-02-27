Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab3B0TEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:04:31 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:59222 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3B0TEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:04:30 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/nsproxy.c: Improving a snippet of code.
Date: Wed, 27 Feb 2013 15:32:09 -0300
Message-Id: <1361989929-1145-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems GCC generates a better code in that way, so I changed that statement.
Btw, they have the same semantic, so I'm sending this patch due to performance issues.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
---
 kernel/nsproxy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 78e2ecb..21da3d1 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -148,7 +148,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	 * means share undolist with parent, so we must forbid using
 	 * it along with CLONE_NEWIPC.
 	 */
-	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM)) {
+	if ((flags & (CLONE_NEWIPC | CLONE_SYSVSEM)) ==
+		(CLONE_NEWIPC | CLONE_SYSVSEM)) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.7.2.5

