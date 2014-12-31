Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaLaBWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:32 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40756 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaLaBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:29 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] lib/kobject_uevent.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:45 +0100
Message-Id: <1419988915-20730-11-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file doesn't seem to use anything from linux/user_namespace.h, and
removing it yields byte-identical object code and strictly fewer
dependencies in the .cmd file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/kobject_uevent.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 9ebf9e20de53..f6c2c1e7779c 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -20,7 +20,6 @@
 #include <linux/export.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
-#include <linux/user_namespace.h>
 #include <linux/socket.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
-- 
2.1.3

