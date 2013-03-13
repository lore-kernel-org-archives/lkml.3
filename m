Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3CMTGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:06:39 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:33305 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab3CMTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:06:38 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: s390: mm: Use PTR_RET function
Date: Wed, 13 Mar 2013 21:05:57 +0200
Message-Id: <1363201557-17715-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 arch/s390/mm/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 479e942..5cf867f 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -458,7 +458,7 @@ static int __init cmm_init(void)
 	if (rc)
 		goto out_pm;
 	cmm_thread_ptr = kthread_run(cmm_thread, NULL, "cmmthread");
-	rc = IS_ERR(cmm_thread_ptr) ? PTR_ERR(cmm_thread_ptr) : 0;
+	rc = PTR_RET(cmm_thread_ptr);
 	if (rc)
 		goto out_kthread;
 	return 0;
-- 
1.7.9.5

