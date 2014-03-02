Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaCBOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:59 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53206 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaCBOJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:09:57 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 6/6] Documentation/filesystems/vfat.txt: update the limitation for fat fallocate
Date: Sun,  2 Mar 2014 23:09:44 +0900
Message-Id: <1393769384-3643-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update the limitation for fat fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 Documentation/filesystems/vfat.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index 4a93e98..5cf57b3 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -175,6 +175,16 @@ nfs=stale_rw|nostale_ro
 
 <bool>: 0,1,yes,no,true,false
 
+LIMITATION
+---------------------------------------------------------------------
+* The fallocated region of file is discarded at umount/evict time
+  when using fallocate with FALLOC_FL_KEEP_SIZE.
+  So, User should assume that fallocated region can be discarded at
+  last close if there is memory pressure resulting in eviction of
+  the inode from the memory. As a result, for any dependency on
+  the fallocated region, user should make sure to recheck fallocate
+  after reopening the file.
+
 TODO
 ----------------------------------------------------------------------
 * Need to get rid of the raw scanning stuff.  Instead, always use
-- 
1.7.11-rc0


