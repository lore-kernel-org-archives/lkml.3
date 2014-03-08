Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaCHBXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:23:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaCHBH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 55/99] fuse: readdir: check for slash in names
Date: Fri,  7 Mar 2014 17:07:51 -0800
Message-Id: <20140308010613.369058150@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit efeb9e60d48f7778fdcad4a0f3ad9ea9b19e5dfd upstream.

Userspace can add names containing a slash character to the directory
listing.  Don't allow this as it could cause all sorts of trouble.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[bwh: Backported to 3.2: drop changes to parse_dirplusfile() which we
 don't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1103,6 +1103,8 @@ static int parse_dirfile(char *buf, size
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		over = filldir(dstbuf, dirent->name, dirent->namelen,
 			       file->f_pos, dirent->ino, dirent->type);


