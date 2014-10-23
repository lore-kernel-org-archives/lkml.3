Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbaJWAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:09:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47381 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaJWAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:09:58 -0400
From: Gregory Fong <gregory.0xf0@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Cernekee <cernekee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>
Subject: [PATCH] mm: cma: Use %pa to avoid truncating the physical address
Date: Wed, 22 Oct 2014 17:09:49 -0700
Message-Id: <1414022989-23035-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Cernekee <cernekee@gmail.com>

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
[gregory.0xf0@gmail.com: rebased from 3.14 and updated commit message]
Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
---
 mm/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 963bc4a..154efb0 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -288,8 +288,8 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	if (ret)
 		goto err;
 
-	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
-		(unsigned long)base);
+	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
+		&base);
 	return 0;
 
 err:
-- 
1.9.1

