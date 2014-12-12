Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbaLLKD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:03:29 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:28066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934608AbaLLKD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:03:27 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44951224"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [RESEND][PATCH] userns: use macro instead of magic number for max userns level
Date: Fri, 12 Dec 2014 18:02:54 +0800
Message-ID: <1418378574-10917-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro instead of magic number
for max user namespace level.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

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
1.9.3

