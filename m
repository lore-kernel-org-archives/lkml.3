Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3LQOrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:47:13 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47731 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3LQOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:47:12 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] lib/lcm.c: Ensure correct result whenever it fits
Date: Tue, 17 Dec 2013 15:46:11 +0100
Message-Id: <1387291572-12348-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.8.4.rc3.2.g61bff3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that lcm(a,b) returns the mathematically correct result,
provided it fits in an unsigned long. The current version returns
garbage if a*b overflows, even if the final result would fit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
There are of course still plenty of cases where the return value is
wrong.

 lib/lcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/lcm.c b/lib/lcm.c
index b9c8de4..01b3aa9 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -7,7 +7,7 @@
 unsigned long lcm(unsigned long a, unsigned long b)
 {
 	if (a && b)
-		return (a * b) / gcd(a, b);
+		return (a / gcd(a, b)) * b;
 	else if (b)
 		return b;
 
-- 
1.8.4.rc3.2.g61bff3f

