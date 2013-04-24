Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3DXBmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:42:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54798 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3DXBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:41:41 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-94-51773851dda3
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Minchan Kim <minchan@kernel.org>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 6/6] add documentation on proc.txt
Date: Wed, 24 Apr 2013 10:41:04 +0900
Message-Id: <1366767664-17541-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1366767664-17541-1-git-send-email-minchan@kernel.org>
References: <1366767664-17541-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds stuff about new reclaim field in proc.txt

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---

Rob, I didn't add your Acked-by because interface was slight changed.
I hope you give Acke-by after review again.
Thanks.

 Documentation/filesystems/proc.txt | 22 ++++++++++++++++++++++
 mm/Kconfig                         |  7 +------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 488c094..1411ad0 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -136,6 +136,7 @@ Table 1-1: Process specific entries in /proc
  maps		Memory maps to executables and library files	(2.4)
  mem		Memory held by this process
  root		Link to the root directory of this process
+ reclaim	Reclaim pages in this process
  stat		Process status
  statm		Process memory status information
  status		Process status in human readable form
@@ -489,6 +490,27 @@ To clear the soft-dirty bit
 
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The file /proc/PID/reclaim is used to reclaim pages in this process.
+To reclaim file-backed pages,
+    > echo file > /proc/PID/reclaim
+
+To reclaim anonymous pages,
+    > echo anon > /proc/PID/reclaim
+
+To reclaim all pages,
+    > echo all > /proc/PID/reclaim
+
+Also, you can specify address range of process so part of address space
+will be reclaimed. The format is following as
+    > echo addr size-byte > /proc/PID/reclaim
+
+NOTE: addr should be page-aligned.
+
+Below is example which try to reclaim 2 pages from 0x100000.
+
+To reclaim both pages in address range,
+    > echo $((1<<20) 8192 > /proc/PID/reclaim
+
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
 using /proc/kpageflags and number of times a page is mapped using
 /proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
diff --git a/mm/Kconfig b/mm/Kconfig
index 314bf49..9d6b306 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -486,9 +486,4 @@ config PROCESS_RECLAIM
 	default n
 	help
 	 It allows to reclaim pages of the process by /proc/pid/reclaim.
-
-	 (echo file > /proc/PID/reclaim) reclaims file-backed pages only.
-	 (echo anon > /proc/PID/reclaim) reclaims anonymous pages only.
-	 (echo all > /proc/PID/reclaim) reclaims all pages.
-
- 	 Any other vaule is ignored.
+	 See Documentation/filesystem/proc.txt for more details.
-- 
1.8.2

