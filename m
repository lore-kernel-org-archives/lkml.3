Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaKKM6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:58:08 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40984 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaKKM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:58:05 -0500
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-mm@kvack.org
Cc: nefelim4ag@gmail.com, marco.antonio.780@gmail.com,
        linux-kernel@vger.kernel.org, tonyb@cybernetics.com,
        killertofu@gmail.com
Subject: [PATCH V3 4/4] KSM: mark_new_vma added to Documentation.
Date: Tue, 11 Nov 2014 15:57:36 +0300
Message-Id: <1415710656-29296-5-git-send-email-nefelim4ag@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415710656-29296-1-git-send-email-nefelim4ag@gmail.com>
References: <1415710656-29296-1-git-send-email-nefelim4ag@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 Documentation/vm/ksm.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/vm/ksm.txt b/Documentation/vm/ksm.txt
index f34a8ee..880fdbf 100644
--- a/Documentation/vm/ksm.txt
+++ b/Documentation/vm/ksm.txt
@@ -24,6 +24,8 @@ KSM only operates on those areas of address space which an application
 has advised to be likely candidates for merging, by using the madvise(2)
 system call: int madvise(addr, length, MADV_MERGEABLE).
 
+Also KSM can mark anonymous memory as mergeable, see below.
+
 The app may call int madvise(addr, length, MADV_UNMERGEABLE) to cancel
 that advice and restore unshared pages: whereupon KSM unmerges whatever
 it merged in that range.  Note: this unmerging call may suddenly require
@@ -73,6 +75,11 @@ merge_across_nodes - specifies if pages from different numa nodes can be merged.
                    merge_across_nodes, to remerge according to the new setting.
                    Default: 1 (merging across nodes as in earlier releases)
 
+mark_new_vma     - set 0 to disallow ksm marking every new allocated anonymous
+                   memory as mergeable.
+                   set 1 to allow ksm mark every new allocated anonymous memory
+                   as mergeable
+
 run              - set 0 to stop ksmd from running but keep merged pages,
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
                    set 2 to stop ksmd and unmerge all pages currently merged,
-- 
2.1.3

