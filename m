Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaLaBY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:24:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54083 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaLaBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:29 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] lib/nlattr.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:46 +0100
Message-Id: <1419988915-20730-12-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nlattr.c doesn't seem to rely on anything from netdevice.h. Removing
it yields identical objdump -d output for each of {allyes,allno,def}config,
and eliminates more than 200 lines from the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/nlattr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 9c3e85ff0a6c..76a1b59523ab 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -9,7 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
-#include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
-- 
2.1.3

