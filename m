Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaLSCbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:31:06 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58271 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLSCbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:31:04 -0500
From: Toshi Kikuchi <toshik@chromium.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/genalloc.c: fix the end addr check in addr_in_gen_pool()
Date: Thu, 18 Dec 2014 18:30:59 -0800
Message-Id: <1418956259-13003-1-git-send-email-toshik@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since chunk->end_addr is (chunk->start_addr + size - 1),
the end address to compare should be (start + size - 1).

Signed-off-by: Toshi Kikuchi <toshik@chromium.org>
---
 lib/genalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 2e65d20..42a95e9 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -415,7 +415,7 @@ bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size)
 {
 	bool found = false;
-	unsigned long end = start + size;
+	unsigned long end = start + size - 1;
 	struct gen_pool_chunk *chunk;
 
 	rcu_read_lock();
-- 
2.2.0.rc0.207.ga3a616c

