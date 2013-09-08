Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3IHNnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 09:43:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46098 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3IHNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 09:43:16 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v3 7/7] manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate
Date: Sun,  8 Sep 2013 22:43:06 +0900
Message-Id: <1378647787-2802-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update FALLOC_FL_COLLAPSE_RANGE flag in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 man2/fallocate.2 |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index f5c395d..b042c59 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -7,6 +7,7 @@
 .\"
 .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
 .\" 2011-09-19: Substantial restructuring of the page
+.\" 2013-09-01: Added FALLOC_FL_COLLAPSE_RANGE
 .\"
 .TH FALLOCATE 2 2013-06-10 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -109,6 +110,19 @@ does not change.
 Not all filesystems support
 .BR FALLOC_FL_PUNCH_HOLE ;
 if a filesystem doesn't support the operation, an error is returned.
+.SS Collapsing file space
+Specifiying the
+.BR FALLOC_FL_COLLAPSE_RANGE
+flag in
+.I mode
+collapse space in the byte range starting at
+.I offset
+and continuing for
+.I len
+bytes, where the offset and len are aligned with block size of filesystem.
+Within the specified range, it first de-allocates blocks and eliminates
+the hole created in this process by shifting data blocks into the hole.
+
 .SH RETURN VALUE
 On success,
 .BR fallocate ()
@@ -139,7 +153,8 @@ was less than 0, or
 .\" See "Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition"
 .\" 21 Sep 2012
 .\" http://thread.gmane.org/gmane.linux.file-systems/48331/focus=1193526
-was less than or equal to 0.
+was less than or equal to 0 or in case of FALLOC_FL_COLLAPSE_RANGE
+offset and len are not aligned with file system's block size.
 .TP
 .B EIO
 An I/O error occurred while reading from or writing to a filesystem.
-- 
1.7.9.5

