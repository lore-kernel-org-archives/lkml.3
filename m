Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966729AbaCUBcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:32:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161AbaCUADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 005/149] ocfs2 syncs the wrong range...
Date: Thu, 20 Mar 2014 17:02:48 -0700
Message-Id: <20140321000436.976807024@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1b56e98990bcdbb20b9fab163654b9315bf158e8 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2370,8 +2370,8 @@ out_dio:
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
 	    ((file->f_flags & O_DIRECT) && !direct_io)) {
-		ret = filemap_fdatawrite_range(file->f_mapping, pos,
-					       pos + count - 1);
+		ret = filemap_fdatawrite_range(file->f_mapping, *ppos,
+					       *ppos + count - 1);
 		if (ret < 0)
 			written = ret;
 
@@ -2384,8 +2384,8 @@ out_dio:
 		}
 
 		if (!ret)
-			ret = filemap_fdatawait_range(file->f_mapping, pos,
-						      pos + count - 1);
+			ret = filemap_fdatawait_range(file->f_mapping, *ppos,
+						      *ppos + count - 1);
 	}
 
 	/*


