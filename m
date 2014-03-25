Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaCYRVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaCYRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 28/81] ext4: don't leave i_crtime.tv_sec uninitialized
Date: Tue, 25 Mar 2014 10:15:41 -0700
Message-Id: <1395767794-5012-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 19ea80603715d473600cd993b9987bc97d042e02 upstream.

If the i_crtime field is not present in the inode, don't leave the
field uninitialized.

Fixes: ef7f38359 ("ext4: Add nanosecond timestamps")
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ext4.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a4903ff..13644c4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -776,6 +776,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
 			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+	else								       \
+		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
-- 
1.8.3.2

