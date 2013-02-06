Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3BFVaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:30:20 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37927 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3BFVaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:30:15 -0500
From: Daniel Baluta <dbaluta@ixiacom.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com
Cc: Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] perf/hwbp: Fix cleanup in case of kzalloc failure
Date: Wed,  6 Feb 2013 23:29:20 +0200
Message-Id: <1360186160-7566-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously this is a typo and could result in memory leaks
if kzalloc fails on a given cpu.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 kernel/events/hw_breakpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index fe8a916..a64f8ae 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -676,7 +676,7 @@ int __init init_hw_breakpoint(void)
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		for (i = 0; i < TYPE_MAX; i++)
-			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+			kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
 		if (err_cpu == cpu)
 			break;
 	}
-- 
1.7.5.4

