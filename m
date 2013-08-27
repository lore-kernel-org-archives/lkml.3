Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3H0QuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:50:06 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:57698 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361Ab3H0QuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:50:05 -0400
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dynamic debug: line queries failing due to uninitialized local variable
Message-Id: <20130827165003.79F28FE066@prod-mail-relay02.akamai.com>
Date: Tue, 27 Aug 2013 16:50:03 +0000 (GMT)
From: jbaron@akamai.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Settings of the form, 'line x module y +p', can fail arbitrarily due to an
uninitialized local variable. With this patch results are consistent, as
expected.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 lib/dynamic_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 99fec3a..c37aeac 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -309,7 +309,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 			struct ddebug_query *query, const char *modname)
 {
 	unsigned int i;
-	int rc;
+	int rc = 0;
 
 	/* check we have an even number of words */
 	if (nwords % 2 != 0) {
-- 
1.8.2

