Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3CVNJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab3CVNJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:51 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 7/7] uretprobes: implemented, thus remove -ENOSYS
Date: Fri, 22 Mar 2013 14:09:04 +0100
Message-Id: <1363957745-6657-8-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  enclose return probes implementation

v3 changes: (the patch is introduced in v3)
  - remove 'TODO' as return probes implemented now

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5fb7809..e13f9f8 100644
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
1.8.1.4

