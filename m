Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbaFSKCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:02:51 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59275 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFSKCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:02:49 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] mm: percpu: micro-optimize round-to-even
Date: Thu, 19 Jun 2014 12:02:29 +0200
Message-Id: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change shaves a few bytes off the generated code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 mm/percpu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 2ddf9a9..978097f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -720,8 +720,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	if (unlikely(align < 2))
 		align = 2;
 
-	if (unlikely(size & 1))
-		size++;
+	size += size & 1;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
-- 
1.9.2

