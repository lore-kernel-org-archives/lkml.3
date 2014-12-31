Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaLaBYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:24:17 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:47049 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaLaBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:31 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] lib/radix-tree.c: Change to simpler include
Date: Wed, 31 Dec 2014 02:21:48 +0100
Message-Id: <1419988915-20730-14-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment helpfully explains why hardirq.h is included, but since
2d4b84739f0a ("hardirq: Split preempt count mask definitions")
in_interrupt() has been provided by preempt_mask.h. Use that instead,
saving around 40 lines in the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/radix-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 3291a8e37490..3d2aa27b845b 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -33,7 +33,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/rcupdate.h>
-#include <linux/hardirq.h>		/* in_interrupt() */
+#include <linux/preempt_mask.h>		/* in_interrupt() */
 
 
 /*
-- 
2.1.3

