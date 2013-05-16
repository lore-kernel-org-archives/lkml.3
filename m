Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3EPKoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:44:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:57602 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3EPKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:44:04 -0400
From: Kevin Hao <haokexin@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] resource: remove the unneeded assignment in function __find_resource
Date: Thu, 16 May 2013 18:43:05 +0800
Message-ID: <1368700985-24934-1-git-send-email-haokexin@gmail.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This line was introduced by commit fcb11918 (resources: add arch hook
for preventing allocation in reserved areas). But the struct tmp was
already assigned to *new in the above line, so this seems superfluous.
Just remove it.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 kernel/resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index d738698..3241516 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -448,7 +448,6 @@ static int __find_resource(struct resource *root, struct resource *old,
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
 
-	tmp.flags = new->flags;
 	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
-- 
1.8.1.4

