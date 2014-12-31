Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaLaBW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:29 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:64909 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaLaBWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:25 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] lib/idr.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:40 +0100
Message-Id: <1419988915-20730-6-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr.c doesn't seem to use anything from hardirq.h (or anything
included from that). Removing it produces identical objdump -d output,
and gives 44 fewer lines in the .idr.o.cmd dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/idr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index e654aebd5f80..5335c43adf46 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -30,7 +30,6 @@
 #include <linux/idr.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 
 #define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
 #define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
-- 
2.1.3

