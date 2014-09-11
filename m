Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaIKJvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:51:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50721 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752408AbaIKJvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:51:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35807609"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Fabian Frederick <fabf@skynet.be>
Subject: [RESEND][PATCH] userns: use marco instead of magic number for max userns level
Date: Thu, 11 Sep 2014 17:51:31 +0800
Message-ID: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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

