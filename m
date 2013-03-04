Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3CDOjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab3CDOj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:39:29 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v4 6/6] uretprobes: implemented, thus remove -ENOSYS
Date: Mon,  4 Mar 2013 15:38:13 +0100
Message-Id: <1362407893-32505-7-git-send-email-anton@redhat.com>
In-Reply-To: <1362407893-32505-1-git-send-email-anton@redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  1/6 and 6/6 patches are here to enclose return probes implementation
as well as prohibit uprobe_register() routine with no consumer set.

v3 changes: (the patch is introduced in v3)
  - remove 'TODO' as return probes implemented now

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e86b6ea..b9c51dc 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -840,10 +840,6 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->rp_handler)
 		return -EINVAL;
 
-	/* TODO: Implement return probes */
-	if (uc->rp_handler)
-		return -ENOSYS;
-
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
-- 
1.8.1.2

