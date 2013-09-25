Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3IYAVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:21:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3IYAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 117/117] fuse: readdir: check for slash in names
Date: Tue, 24 Sep 2013 17:19:43 -0700
Message-Id: <20130925001753.726692827@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit efeb9e60d48f7778fdcad4a0f3ad9ea9b19e5dfd upstream.

Userspace can add names containing a slash character to the directory
listing.  Don't allow this as it could cause all sorts of trouble.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1174,6 +1174,8 @@ static int parse_dirfile(char *buf, size
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		if (!dir_emit(ctx, dirent->name, dirent->namelen,
 			       dirent->ino, dirent->type))
@@ -1320,6 +1322,8 @@ static int parse_dirplusfile(char *buf,
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		if (!over) {
 			/* We fill entries into dstbuf only as much as


