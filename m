Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3AQNEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab3AQNED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:04:03 -0500
From: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
Subject: [PATCH] symlink: allow an empty target string
Date: Thu, 17 Jan 2013 13:03:53 +0000
Message-Id: <1358427833-3847-2-git-send-email-P@draigBrady.com>
In-Reply-To: <1358427833-3847-1-git-send-email-P@draigBrady.com>
References: <1358427833-3847-1-git-send-email-P@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX only states that ENOENT should be returned
if an empty string is specified for the link name.
In fact it states the link target...
"shall be treated only as a character string and
 shall not be validated as a pathname".

Signed-off-by: Pádraig Brady <P@draigBrady.com>
---
 fs/namei.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 43a97ee..26dd264 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3533,12 +3533,13 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	int error;
+	int empty;
 	struct filename *from;
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
 
-	from = getname(oldname);
+	from = getname_flags(oldname, LOOKUP_EMPTY, &empty);
 	if (IS_ERR(from))
 		return PTR_ERR(from);
 retry:
-- 
1.7.6.4

