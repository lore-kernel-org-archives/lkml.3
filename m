Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaLaB0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:26:55 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49831 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaLaBWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:23 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] lib/dynamic_queue_limits.c: Simplify includes
Date: Wed, 31 Dec 2014 02:21:38 +0100
Message-Id: <1419988915-20730-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file doesn't use anything from ctype.h. Instead of module.h, just
use export.h for EXPORT_SYMBOL. The latter requires the user to
include compiler.h, so do that explicitly instead of relying on some
other header pulling it in.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/dynamic_queue_limits.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index 0777c5a45fa0..f346715e2255 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -3,12 +3,12 @@
  *
  * Copyright (c) 2011, Tom Herbert <therbert@google.com>
  */
-#include <linux/module.h>
 #include <linux/types.h>
-#include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 #define POSDIFF(A, B) ((int)((A) - (B)) > 0 ? (A) - (B) : 0)
 #define AFTER_EQ(A, B) ((int)((A) - (B)) >= 0)
-- 
2.1.3

