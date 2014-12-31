Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaLaB0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:26:34 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55645 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaLaBWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:24 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] lib/halfmd4.c: Simplify includes
Date: Wed, 31 Dec 2014 02:21:39 +0100
Message-Id: <1419988915-20730-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need EXPORT_SYMBOL, so compiler.h and export.h suffice. This
means linux/types.h is no longer implicitly included, so add an
include of uapi/linux/types.h to linux/cryptohash.h for __u32. Other
users of cryptohash.h cannot be affected, since they must already have
been including uapi/linux/types.h in order for gcc not to complain
about unknown types.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/cryptohash.h | 2 ++
 lib/halfmd4.c              | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 2cd9f1cf9fa3..f4754282c9c2 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -1,6 +1,8 @@
 #ifndef __CRYPTOHASH_H
 #define __CRYPTOHASH_H
 
+#include <uapi/linux/types.h>
+
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
 #define SHA_WORKSPACE_WORDS 16
diff --git a/lib/halfmd4.c b/lib/halfmd4.c
index 66d0ee8b7776..a8fe6274a13c 100644
--- a/lib/halfmd4.c
+++ b/lib/halfmd4.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/cryptohash.h>
 
-- 
2.1.3

