Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3GPHeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:34:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46661 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3GPHeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:34:16 -0400
X-Spam-Score: -100.7
Message-ID: <51E4F73C.4000205@asianux.com>
Date: Tue, 16 Jul 2013 15:33:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
CC: v9fs-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: 9p: use strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 'NULL' terminated string, recommend always to be ended by zero.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/9p/vfs_inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 25b018e..94de6d1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -146,7 +146,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 		char type = 0, ext[32];
 		int major = -1, minor = -1;
 
-		strncpy(ext, stat->extension, sizeof(ext));
+		strlcpy(ext, stat->extension, sizeof(ext));
 		sscanf(ext, "%c %u %u", &type, &major, &minor);
 		switch (type) {
 		case 'c':
@@ -1186,7 +1186,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 			 * this even with .u extension. So check
 			 * for non NULL stat->extension
 			 */
-			strncpy(ext, stat->extension, sizeof(ext));
+			strlcpy(ext, stat->extension, sizeof(ext));
 			/* HARDLINKCOUNT %u */
 			sscanf(ext, "%13s %u", tag_name, &i_nlink);
 			if (!strncmp(tag_name, "HARDLINKCOUNT", 13))
-- 
1.7.7.6
