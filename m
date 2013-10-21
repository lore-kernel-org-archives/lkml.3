Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3JUJWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:22:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39470 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762Ab3JUIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Miklos Szeredi" <mszeredi@suse.cz>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.180584956@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 053/149] fuse: readdir: check for slash in names
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit efeb9e60d48f7778fdcad4a0f3ad9ea9b19e5dfd upstream.

Userspace can add names containing a slash character to the directory
listing.  Don't allow this as it could cause all sorts of trouble.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[bwh: Backported to 3.2: drop changes to parse_dirplusfile() which we
 don't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1063,6 +1063,8 @@ static int parse_dirfile(char *buf, size
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		over = filldir(dstbuf, dirent->name, dirent->namelen,
 			       file->f_pos, dirent->ino, dirent->type);

