Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3CDM7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:41 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38318 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab3CDM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:38 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, lguest@lists.ozlabs.org
Subject: [PATCH -v3 14/23] lguest: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:22 +0900
Message-Id: <1362401911-14074-15-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@lists.ozlabs.org
---

No change from v2

 drivers/lguest/page_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 3b62be16..864baab 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -686,7 +686,7 @@ static unsigned int new_pgdir(struct lg_cpu *cpu,
 	 * We pick one entry at random to throw out.  Choosing the Least
 	 * Recently Used might be better, but this is easy.
 	 */
-	next = random32() % ARRAY_SIZE(cpu->lg->pgdirs);
+	next = prandom_u32() % ARRAY_SIZE(cpu->lg->pgdirs);
 	/* If it's never been allocated at all before, try now. */
 	if (!cpu->lg->pgdirs[next].pgdir) {
 		cpu->lg->pgdirs[next].pgdir =
-- 
1.8.1.2

