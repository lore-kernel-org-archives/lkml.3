Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3IMLDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:03:23 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58603 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3IMLDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:03:21 -0400
Subject: [PATCH] mm: catch memory commitment underflow
To: Hugh Dickins <hughd@google.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Sep 2013 15:03:17 +0400
Message-ID: <20130913110317.20994.25319.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds debug for vm_committed_as under CONFIG_DEBUG_VM=y

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/mmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..2c7e6aa 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -131,6 +131,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 
 	vm_acct_memory(pages);
 
+#ifdef CONFIG_DEBUG_VM
+	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus(),
+			"memory commitment underflow");
+#endif
+
 	/*
 	 * Sometimes we want to use more memory than we have
 	 */

