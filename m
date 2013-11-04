Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3KDDbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:31:33 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50765 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3KDDbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:31:31 -0500
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: [PATCH] mm: improve the description for dirty_background_ratio/dirty_ratio sysctl
Date: Mon,  4 Nov 2013 11:33:42 +0800
Message-Id: <1383536022-29555-1-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

Now dirty_backgraound_ratio/dirty_ratio contains a percentage of total avaiable
memory, which contains free pages and reclaimable pages.  The number of these
pages is not equal to the number of total system memory.  But they are described
as a percentage of total system memory in Documentation/sysctl/vm.txt.  So we
need to fix them to avoid misunderstanding.

Cc: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 Documentation/sysctl/vm.txt |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 79a797e..1fbd4eb 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -119,8 +119,11 @@ other appears as 0 when read.
 
 dirty_background_ratio
 
-Contains, as a percentage of total system memory, the number of pages at which
-the background kernel flusher threads will start writing out dirty data.
+Contains, as a percentage of total available memory that contains free pages
+and reclaimable pages, the number of pages at which the background kernel
+flusher threads will start writing out dirty data.
+
+The total avaiable memory is not equal to total system memory.
 
 ==============================================================
 
@@ -151,9 +154,11 @@ interval will be written out next time a flusher thread wakes up.
 
 dirty_ratio
 
-Contains, as a percentage of total system memory, the number of pages at which
-a process which is generating disk writes will itself start writing out dirty
-data.
+Contains, as a percentage of total available memory that contains free pages
+and reclaimable pages, the number of pages at which a process which is
+generating disk writes will itself start writing out dirty data.
+
+The total avaiable memory is not equal to total system memory.
 
 ==============================================================
 
-- 
1.7.9.7

