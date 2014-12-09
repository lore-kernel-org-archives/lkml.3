Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLIVDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:03:30 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47300 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaLIVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:03:29 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib/lcm.c: Ensure correct result whenever it fits
Date: Tue,  9 Dec 2014 22:03:03 +0100
Message-Id: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that lcm(a,b) returns the mathematically correct result,
provided it fits in an unsigned long. The current version returns
garbage if a*b overflows, even if the final result would fit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/lcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/lcm.c b/lib/lcm.c
index b9c8de461e9e..01b3aa922dda 100644
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
2.1.3

