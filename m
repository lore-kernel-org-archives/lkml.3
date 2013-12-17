Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3LQOr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:47:27 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34363 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3LQOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:47:25 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
Date: Tue, 17 Dec 2013 15:46:12 +0100
Message-Id: <1387291572-12348-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.8.4.rc3.2.g61bff3f
In-Reply-To: <1387291572-12348-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1387291572-12348-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the mathematically correct answer when an argument is 0.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
I don't think there is any instance of lcm(0,n) in the kernel, but at
least this reduces code size a little.

 lib/lcm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/lcm.c b/lib/lcm.c
index 01b3aa9..51cc6b1 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -8,9 +8,7 @@ unsigned long lcm(unsigned long a, unsigned long b)
 {
 	if (a && b)
 		return (a / gcd(a, b)) * b;
-	else if (b)
-		return b;
-
-	return a;
+	else
+		return 0;
 }
 EXPORT_SYMBOL_GPL(lcm);
-- 
1.8.4.rc3.2.g61bff3f

