Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaLaBZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:25:20 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52076 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaLaBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:29 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/19] lib/llist.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:44 +0100
Message-Id: <1419988915-20730-10-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file doesn't seem to use anything provided by linux/interrupt.h
or anything recursively included through that. Removing it produces
byte-identical output, while reducing .llist.o.cmd from 541 to 156
lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/llist.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/llist.c b/lib/llist.c
index f76196d07409..0b0e9779d675 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -24,7 +24,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <linux/interrupt.h>
 #include <linux/llist.h>
 
 
-- 
2.1.3

