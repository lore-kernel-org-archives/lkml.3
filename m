Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaIEHWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:22:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:5970 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754415AbaIEHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:22:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,471,1406563200"; 
   d="scan'208";a="35556526"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH] userns: use marco instead of magic number for max userns level
Date: Fri, 5 Sep 2014 13:39:25 +0800
Message-ID: <1409895565-26572-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use marco instead of magic number
for max user namespace level.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 kernel/user_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0..5435489 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -47,6 +47,8 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
 	cred->user_ns = user_ns;
 }
 
+#define MAX_USER_NS_LEVEL 32
+
 /*
  * Create a new user namespace, deriving the creator from the user in the
  * passed credentials, and replacing that user with the new root user for the
@@ -62,7 +64,7 @@ int create_user_ns(struct cred *new)
 	kgid_t group = new->egid;
 	int ret;
 
-	if (parent_ns->level > 32)
+	if (parent_ns->level > MAX_USER_NS_LEVEL)
 		return -EUSERS;
 
 	/*
-- 
1.9.0

