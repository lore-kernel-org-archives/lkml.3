Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3CBDph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:45:37 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39836 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3CBDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:45:33 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v7 7/7] Documentation: update nfs option in filesystem/vfat.txt
Date: Sat,  2 Mar 2013 12:45:25 +0900
Message-Id: <1362195925-21181-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add descriptions about 'stale_rw' and 'nostale_ro' nfs options in
filesystem/vfat.txt

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 Documentation/filesystems/vfat.txt |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index d230dd9..4a93e98 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -150,12 +150,28 @@ discard       -- If set, issues discard/TRIM commands to the block
 		 device when blocks are freed. This is useful for SSD devices
 		 and sparse/thinly-provisoned LUNs.
 
-nfs           -- This option maintains an index (cache) of directory
-		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
+nfs=stale_rw|nostale_ro
+		Enable this only if you want to export the FAT filesystem
+		over NFS.
+
+		stale_rw: This option maintains an index (cache) of directory
+		inodes by i_logstart which is used by the nfs-related code to
+		improve look-ups. Full file operations (read/write) over NFS is
+		supported but with cache eviction at NFS server, this could
+		result in ESTALE issues.
+
+		nostale_ro: This option bases the inode number and filehandle
+		on the on-disk location of a file in the MS-DOS directory entry.
+		This ensures that ESTALE will not be returned after a file is
+		evicted from the inode cache. However, it means that operations
+		such as rename, create and unlink could cause filehandles that
+		previously pointed at one file to point at a different file,
+		potentially causing data corruption. For this reason, this
+		option also mounts the filesystem readonly.
+
+		To maintain backward compatibility, '-o nfs' is also accepted,
+		defaulting to stale_rw
 
-		 Enable this only if you want to export the FAT filesystem
-		 over NFS
 
 <bool>: 0,1,yes,no,true,false
 
-- 
1.7.9.5

