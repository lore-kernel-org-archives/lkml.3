Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaLaBWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:25 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:38577 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaLaBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:22 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] lib/sort.c: Use simpler includes
Date: Wed, 31 Dec 2014 02:21:37 +0100
Message-Id: <1419988915-20730-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sort.c doesn't use facilities from kernel.h, but does use some types
defined in linux/types.h. Include the latter directly instead of
relying on some other header doing it. Similarly, include
linux/export.h directly instead of through module.h. This removes 80
lines from the dependency file .sort.o.cmd.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/sort.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/sort.c b/lib/sort.c
index 926d00429ed2..14fc1dfadb3f 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -4,8 +4,8 @@
  * Jan 23 2005  Matt Mackall <mpm@selenic.com>
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/export.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
 
-- 
2.1.3

