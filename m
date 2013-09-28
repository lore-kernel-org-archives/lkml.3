Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3I1Xg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:36:56 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:41260 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3I1Xgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:50 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: fix return value in case of error in v9fs_fid_xattr_set
Date: Sat, 28 Sep 2013 20:32:17 -0300
Message-Id: <1380411144-9236-5-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error in the p9_client_write, the function v9fs_fid_xattr_set
should return its negative value, what was never being done.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/xattr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 3c28cdf..0788388 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -149,11 +149,10 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
 			write_count = value_len;
 		write_count = p9_client_write(fid, ((char *)value)+offset,
 					NULL, offset, write_count);
-		if (write_count < 0) {
-			/* error in xattr write */
-			retval = write_count;
-			break;
-		}
+		/* error in xattr write */
+		if (write_count < 0)
+			return write_count;
+
 		offset += write_count;
 		value_len -= write_count;
 	}
-- 
1.8.4

