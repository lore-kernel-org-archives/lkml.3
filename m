Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaDVF2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:28:48 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33179 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVF2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:28:46 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] perf-event/cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:28:37 +0800
Message-Id: <1398144517-9496-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a cgroup subsystem who should init early, then it should carefully
take care of the implementation of css_alloc, because it will be called
before mm_init() setup the world.

Luckily we don't, and we better explicitly assign the early_init field
to 0, for document reason.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..b3a8916 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8062,5 +8062,6 @@ struct cgroup_subsys perf_event_cgrp_subsys = {
 	.css_free	= perf_cgroup_css_free,
 	.exit		= perf_cgroup_exit,
 	.attach		= perf_cgroup_attach,
+	.early_init	= 0,
 };
 #endif /* CONFIG_CGROUP_PERF */
-- 
2.0.0-rc0

