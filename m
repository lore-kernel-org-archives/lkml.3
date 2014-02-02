Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaBBFrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 00:47:51 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52533 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaBBFrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 00:47:48 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH RESEND 10/10] manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate
Date: Sun,  2 Feb 2014 14:47:38 +0900
Message-Id: <1391320058-3448-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update FALLOC_FL_COLLAPSE_RANGE flag in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 man2/fallocate.2 |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index ec9011c..69a4dbd 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -1,5 +1,6 @@
 .\" Copyright (c) 2007 Silicon Graphics, Inc. All Rights Reserved
 .\" Written by Dave Chinner <dgc@sgi.com>
+.\" Updated by Namjae Jeon <namjae.jeon@samsung.com>
 .\"
 .\" %%%LICENSE_START(GPLv2_ONELINE)
 .\" May be distributed as per GNU General Public License version 2.
@@ -7,6 +8,7 @@
 .\"
 .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
 .\" 2011-09-19: Substantial restructuring of the page
+.\" 2013-11-10: Added FALLOC_FL_COLLAPSE_RANGE
 .\"
 .TH FALLOCATE 2 2013-11-08 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -113,6 +115,25 @@ does not change.
 Not all filesystems support
 .BR FALLOC_FL_PUNCH_HOLE ;
 if a filesystem doesn't support the operation, an error is returned.
+.SS Collapsing file space
+Specifiying the
+.BR FALLOC_FL_COLLAPSE_RANGE
+flag in
+.I mode
+collpse space in the byte range starting at
+.I offset
+and continuing for
+.I len
+bytes. Within the specified range, it first de-allocates blocks and eliminates
+the hole created in this process by shifting data blocks into the hole.
+
+Different filesystem may implement different limitatios on the granularity of
+the operation. Most filesystem will limit operations to filesystem block size
+boundaries, but this boundary may be larger or smaller depending
+on the filesystem and/or the configuration of the filesystem or file.
+
+If filesystem has such limitation on granularity, It will return error(EINVAL).
+
 .SH RETURN VALUE
 On success,
 .BR fallocate ()
-- 
1.7.9.5

