Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab3ARJk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:40:27 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38958 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3ARJkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:40:25 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: akpm@linux-foundation.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 1/3] fs/9p: remove obsolete simple_strto<foo>
Date: Fri, 18 Jan 2013 15:09:16 +0530
Message-Id: <1358501956-31493-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the obsolete simple_strto<foo> with kstrto<foo>.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/9p/v9fs.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d934f04..6ac48fc 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -112,7 +112,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
-	char *s, *e;
+	char *s;
 	int ret = 0;
 
 	/* setup defaults */
@@ -249,9 +249,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			} else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				v9ses->uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0') {
-					ret = -EINVAL;
+				ret = kstrtouint(s, 10, &v9ses->uid);
+				if (ret) {
 					pr_info("Unknown access argument %s\n",
 						s);
 					kfree(s);
-- 
1.7.7.6

