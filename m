Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaHMRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:02:59 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46988 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaHMRC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:02:58 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: gerb.stralko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>,
        Brian Swetland <swetland@google.com>
Subject: [PATCH] staging: android: fix a possible memory leak
Date: Thu, 14 Aug 2014 02:02:48 +0900
Message-Id: <1407949368-2791-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocated by kstrdup should be freed.

CC: Brian Swetland <swetland@google.com>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/android/logger.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 9b47e66..0bf0d24 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -790,7 +790,7 @@ static int __init create_log(char *log_name, int size)
 	if (unlikely(ret)) {
 		pr_err("failed to register misc device for log '%s'!\n",
 				log->misc.name);
-		goto out_free_log;
+		goto out_free_misc_name;
 	}
 
 	pr_info("created %luK log '%s'\n",
@@ -798,6 +798,9 @@ static int __init create_log(char *log_name, int size)
 
 	return 0;
 
+out_free_misc_name:
+	kfree(log->misc.name);
+
 out_free_log:
 	kfree(log);
 
-- 
1.7.9.5

