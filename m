Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaCEOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaCEOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/131] ext4: don't leave i_crtime.tv_sec uninitialized
Date: Wed,  5 Mar 2014 14:22:43 +0000
Message-Id: <1394029455-23128-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 19ea80603715d473600cd993b9987bc97d042e02 upstream.

If the i_crtime field is not present in the inode, don't leave the
field uninitialized.

Fixes: ef7f38359 ("ext4: Add nanosecond timestamps")
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index caa5e5b..db03437 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -759,6 +759,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
 			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+	else								       \
+		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
-- 
1.9.0

