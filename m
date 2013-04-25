Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab3DYBHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:07:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58769 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab3DYBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:07:43 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-5b-517881dc4f63
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 6/6] add documentation about reclaim knob on proc.txt
Date: Thu, 25 Apr 2013 10:07:22 +0900
Message-Id: <1366852043-12511-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1366852043-12511-1-git-send-email-minchan@kernel.org>
References: <1366852043-12511-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds stuff about new reclaim field in proc.txt

Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/filesystems/proc.txt | 20 ++++++++++++++++++++
 mm/Kconfig                         |  7 +------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 488c094..ee4cef1 100644
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
@@ -489,6 +490,25 @@ To clear the soft-dirty bit
 
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
+Below is example which try to reclaim 2M from 0x100000.
+    > echo 0x100000 2M > /proc/PID/reclaim
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

