Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3CSKHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:07:19 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43527 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3CSKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:07:17 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: platform: x86: Use PTR_RET function
Date: Tue, 19 Mar 2013 03:01:34 +0200
Message-Id: <1363654894-20309-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/platform/x86/samsung-q10.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
index 5f77005..1a90b62 100644
--- a/drivers/platform/x86/samsung-q10.c
+++ b/drivers/platform/x86/samsung-q10.c
@@ -176,10 +176,7 @@ static int __init samsungq10_init(void)
 						   samsungq10_probe,
 						   NULL, 0, NULL, 0);
 
-	if (IS_ERR(samsungq10_device))
-		return PTR_ERR(samsungq10_device);
-
-	return 0;
+	return PTR_RET(samsungq10_device);
 }
 
 static void __exit samsungq10_exit(void)
-- 
1.7.9.5

