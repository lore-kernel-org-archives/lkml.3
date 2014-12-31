Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaLaBYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:24:19 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43278 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaLaBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:30 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/19] lib/plist.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:47 +0100
Message-Id: <1419988915-20730-13-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the include of linux/spinlock.h produces byte-identical
output for {allno,def}config, and identical objdump -d output for
allyesconfig. In the former two cases, more than a 100 lines are
eliminated from the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/plist.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/plist.c b/lib/plist.c
index d408e774b746..3a30c53db061 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -25,7 +25,6 @@
 
 #include <linux/bug.h>
 #include <linux/plist.h>
-#include <linux/spinlock.h>
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
-- 
2.1.3

