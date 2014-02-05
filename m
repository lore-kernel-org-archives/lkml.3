Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBEPCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:02:07 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:55096 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBEPCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:02:05 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: document failed_reads, failed_writes stats
Date: Wed,  5 Feb 2014 17:58:35 +0300
Message-Id: <1391612315-10738-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.rc2.211.gd198f5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document `failed_reads' and `failed_writes' device attributes.
Remove info about `discard' - there is no such zram attr.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 24 +++++++++++++++---------
 Documentation/blockdev/zram.txt            |  3 ++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index 3f0b9ae..8aa0468 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -43,6 +43,21 @@ Description:
 		The invalid_io file is read-only and specifies the number of
 		non-page-size-aligned I/O requests issued to this device.
 
+What:		/sys/block/zram<id>/failed_reads
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_reads file is read-only and specifies the number of
+		failed reads happened on this device.
+
+
+What:		/sys/block/zram<id>/failed_writes
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_writes file is read-only and specifies the number of
+		failed writes happened on this device.
+
 What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
@@ -53,15 +68,6 @@ Description:
 		is freed. This statistic is applicable only when this disk is
 		being used as a swap disk.
 
-What:		/sys/block/zram<id>/discard
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The discard file is read-only and specifies the number of
-		discard requests received by this device. These requests
-		provide information to block device regarding blocks which are
-		no longer used by filesystem.
-
 What:		/sys/block/zram<id>/zero_pages
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 393541be..b31ac5e 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -51,9 +51,10 @@ size of the disk when not in use so a huge zram is wasteful.
 		disksize
 		num_reads
 		num_writes
+		failed_reads
+		failed_writes
 		invalid_io
 		notify_free
-		discard
 		zero_pages
 		orig_data_size
 		compr_data_size
-- 
1.9.rc2.211.gd198f5d

