Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaDVF2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:28:21 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60415 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVF2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:28:17 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] cgroup_freezer: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:28:09 +0800
Message-Id: <1398144489-9412-1-git-send-email-nasa4836@gmail.com>
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
 kernel/cgroup_freezer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 2bc4a22..74fe7f7 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -501,4 +501,5 @@ struct cgroup_subsys freezer_cgrp_subsys = {
 	.attach		= freezer_attach,
 	.fork		= freezer_fork,
 	.base_cftypes	= files,
+	.early_init	= 0,
 };
-- 
2.0.0-rc0

