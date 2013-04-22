Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3DVIpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:45:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3DVIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:45:31 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-27-5174f8a753dd
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Rob Landley <rob@landley.net>
Subject: [PATCH 6/6] add documentation on proc.txt
Date: Mon, 22 Apr 2013 17:45:06 +0900
Message-Id: <1366620306-30940-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1366620306-30940-1-git-send-email-minchan@kernel.org>
References: <1366620306-30940-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation about new reclaim field in proc.txt

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/filesystems/proc.txt | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 488c094..c1f5ee4 100644
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
@@ -489,6 +490,29 @@ To clear the soft-dirty bit
 
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The /proc/PID/reclaim is used to reclaim pages in this process.
+To reclaim file-backed pages,
+    > echo 1 > /proc/PID/reclaim
+
+To reclaim anonymous pages,
+    > echo 2 > /proc/PID/reclaim
+
+To reclaim both pages,
+    > echo 3 > /proc/PID/reclaim
+
+Also, you can specify address range of process so part of address space
+will be reclaimed. The format is following as
+    > echo 4 addr size > /proc/PID/reclaim
+
+To reclaim file-backed pages in address range,
+    > echo 4 $((1<<20) 4096 > /proc/PID/reclaim
+
+To reclaim anonymous pages in address range,
+    > echo 5 $((1<<20) 4096 > /proc/PID/reclaim
+
+To reclaim both pages in address range,
+    > echo 6 $((1<<20) 4096 > /proc/PID/reclaim
+
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
 using /proc/kpageflags and number of times a page is mapped using
 /proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
-- 
1.8.2

