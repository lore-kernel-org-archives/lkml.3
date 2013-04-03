Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575Ab3DCQCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762536Ab3DCQCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:02:13 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 8/9] uretprobes: Remove -ENOSYS as return probes implemented
Date: Wed,  3 Apr 2013 18:00:38 +0200
Message-Id: <1365004839-21982-9-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose return probes implementation.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 489f5e3..9af52f7 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -828,10 +828,6 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->ret_handler)
 		return -EINVAL;
 
-	/* TODO: Implement return probes */
-	if (uc->ret_handler)
-		return -ENOSYS;
-
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
-- 
1.8.1.4

