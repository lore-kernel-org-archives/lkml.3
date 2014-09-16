Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaIPU6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:58:15 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49283 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaIPUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:05 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 07/22] isofs: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:21 +0200
Message-Id: <1410900696-6481-8-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/isofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 5ddaf86..881b3bd 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -247,7 +247,7 @@ static int isofs_dentry_cmp_common(
 	}
 	if (alen == blen) {
 		if (ci) {
-			if (strnicmp(name->name, str, alen) == 0)
+			if (strncasecmp(name->name, str, alen) == 0)
 				return 0;
 		} else {
 			if (strncmp(name->name, str, alen) == 0)
-- 
2.0.4

