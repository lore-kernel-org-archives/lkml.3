Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaLaBXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:23:53 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51803 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaLaBWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:32 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] lib/show_mem.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:49 +0100
Message-Id: <1419988915-20730-15-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_mem.c doesn't use anything from nmi.h. Removing it yields
identical objdump -d output for each of {allyes,allno,def}config and
eliminates more than 100 lines in the dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/show_mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/show_mem.c b/lib/show_mem.c
index 7de89f4a36cf..adc98e1825ba 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/mm.h>
-#include <linux/nmi.h>
 #include <linux/quicklist.h>
 #include <linux/cma.h>
 
-- 
2.1.3

