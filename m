Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaDVF0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:26:37 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40309 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVF0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:26:35 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] blk-cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:26:10 +0800
Message-Id: <1398144370-9236-1-git-send-email-nasa4836@gmail.com>
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
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e4a4145..941bbc8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -912,6 +912,7 @@ struct cgroup_subsys blkio_cgrp_subsys = {
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
 	.base_cftypes = blkcg_files,
+	.early_init = 0,
 };
 EXPORT_SYMBOL_GPL(blkio_cgrp_subsys);
 
-- 
2.0.0-rc0

