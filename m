Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaLaB1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:27:22 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52195 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaLaBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:22 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] lib/interval_tree.c: Simplify includes
Date: Wed, 31 Dec 2014 02:21:36 +0100
Message-Id: <1419988915-20730-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file uses nothing from init.h, and also doesn't need the full
module.h machinery; export.h is sufficient. The latter requires the
user to ensure compiler.h is included, so do that explicitly instead
of relying on some other header pulling it in.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/interval_tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index f367f9ad544c..c85f6600a5f8 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -1,7 +1,7 @@
-#include <linux/init.h>
 #include <linux/interval_tree.h>
 #include <linux/interval_tree_generic.h>
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 #define START(node) ((node)->start)
 #define LAST(node)  ((node)->last)
-- 
2.1.3

