Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLaBXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:23:15 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:64571 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaLaBWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:35 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] lib/percpu_ida.c: Remove redundant includes
Date: Wed, 31 Dec 2014 02:21:53 +0100
Message-Id: <1419988915-20730-19-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three #includes seem to be completely redundant: Removing them
yields identical objdump -d output for each of
{allyes,allno,def}config, and neither included file end up in the
generated dependency file through some recursive include. In total,
about 50 lines are eliminated from .percpu.o.cmd.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/percpu_ida.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e5539c..f75715131f20 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -19,13 +19,10 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <linux/hardirq.h>
-#include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/percpu_ida.h>
-- 
2.1.3

