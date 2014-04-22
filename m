Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaDVF1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:27:40 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60030 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:27:37 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:27:29 +0800
Message-Id: <1398144449-9325-1-git-send-email-nasa4836@gmail.com>
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
 kernel/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 559f822..f23cb67 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5325,5 +5325,6 @@ struct cgroup_subsys debug_cgrp_subsys = {
 	.css_alloc = debug_css_alloc,
 	.css_free = debug_css_free,
 	.base_cftypes = debug_files,
+	.early_init = 0,
 };
 #endif /* CONFIG_CGROUP_DEBUG */
-- 
2.0.0-rc0

