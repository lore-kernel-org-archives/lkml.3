Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaDBRzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:55:44 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:44025 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaDBRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:55:39 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, forest@alittletooquiet.net,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH v2 1/4] staging: vt6655: fix DBG_PRT and PRINT_K macros
Date: Wed,  2 Apr 2014 14:53:01 -0300
Message-Id: <1396461184-13231-2-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap both macros inside a 'do { ... } while(0)' to prevent breakage if
used within another 'if'. Also fix a usage of DBG_PRT with a missing
semicolon.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/staging/vt6655/device.h | 13 +++++++++++--
 drivers/staging/vt6655/wpactl.c |  2 +-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 062c3a3..985c3c1 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -148,8 +148,17 @@
 
 /*---------------------  Export Types  ------------------------------*/
 
-#define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
-#define PRINT_K(p, args...) { if (PRIVATE_Message) printk(p, ##args); }
+#define DBG_PRT(l, p, args...)		\
+do {					\
+	if (l <= msglevel)		\
+		printk(p, ##args);	\
+} while (0)
+
+#define PRINT_K(p, args...)		\
+do {					\
+	if (PRIVATE_Message)		\
+		printk(p, ##args);	\
+} while (0)
 
 //0:11A 1:11B 2:11G
 typedef enum _VIA_BB_TYPE
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index d17224f..bdfb528 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -679,7 +679,7 @@ static int wpa_get_scan(PSDevice pDevice,
 		ret = -EFAULT;
 	}
 	param->u.scan_results.scan_count = count;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count)
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count);
 
 		kfree(pBuf);
 	return ret;
-- 
1.9.0

