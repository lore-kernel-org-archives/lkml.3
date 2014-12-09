Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaLIVDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:03:35 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51694 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaLIVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:03:31 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
Date: Tue,  9 Dec 2014 22:03:04 +0100
Message-Id: <1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the mathematically correct answer when an argument is 0.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/lcm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/lcm.c b/lib/lcm.c
index 01b3aa922dda..51cc6b13cd52 100644
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
2.1.3

