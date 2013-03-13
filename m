Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3CMTqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:46:50 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44208 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:46:49 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: s390: mm: Removed useless label
Date: Wed, 13 Mar 2013 21:46:08 +0200
Message-Id: <1363203968-17967-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrote conditional statement and eliminated the out_kthread label.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 arch/s390/mm/cmm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 479e942..9d84a1f 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -458,12 +458,10 @@ static int __init cmm_init(void)
 	if (rc)
 		goto out_pm;
 	cmm_thread_ptr = kthread_run(cmm_thread, NULL, "cmmthread");
-	rc = IS_ERR(cmm_thread_ptr) ? PTR_ERR(cmm_thread_ptr) : 0;
-	if (rc)
-		goto out_kthread;
-	return 0;
+	if (!IS_ERR(cmm_thread_ptr))
+		return 0;
 
-out_kthread:
+	rc = PTR_ERR(cmm_thread_ptr);
 	unregister_pm_notifier(&cmm_power_notifier);
 out_pm:
 	unregister_oom_notifier(&cmm_oom_nb);
-- 
1.7.9.5

