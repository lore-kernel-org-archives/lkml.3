Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbaCTX4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:56:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaCTX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:56:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_misc: add missing 'break' statement
Date: Thu, 20 Mar 2014 23:56:17 +0000
Message-Id: <1395359777-14302-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing 'break' statement in function bm_status_write() results in
a user program to receive '3' when doing the following:

  write(fd, "-1", 2);

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/binfmt_misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1c740e1..b605003 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -656,6 +656,7 @@ static ssize_t bm_status_write(struct file * file, const char __user * buffer,
 
 			mutex_unlock(&root->d_inode->i_mutex);
 			dput(root);
+			break;
 		default: return res;
 	}
 	return count;
-- 
1.9.1

