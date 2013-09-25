Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3IYARk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:17:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3IYARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 110/110] fuse: readdir: check for slash in names
Date: Tue, 24 Sep 2013 17:15:48 -0700
Message-Id: <20130925001335.324446652@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1175,6 +1175,8 @@ static int parse_dirfile(char *buf, size
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		over = filldir(dstbuf, dirent->name, dirent->namelen,
 			       file->f_pos, dirent->ino, dirent->type);
@@ -1323,6 +1325,8 @@ static int parse_dirplusfile(char *buf,
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		if (!over) {
 			/* We fill entries into dstbuf only as much as


