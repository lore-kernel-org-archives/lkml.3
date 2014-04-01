Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaDANBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:01:18 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:50575 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDANBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:01:17 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH 1/3] staging: vt6655: fix DBG_PRT and PRINT_K macros
Date: Tue,  1 Apr 2014 09:52:11 -0300
Message-Id: <1396356733-5344-2-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesize both macros so they will not break program logic if used
within another 'if'. Also fix a usage of DBG_PRT with a missing
semicolon.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/staging/vt6655/device.h | 4 ++--
 drivers/staging/vt6655/wpactl.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 062c3a3..483b017 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -148,8 +148,8 @@
 
 /*---------------------  Export Types  ------------------------------*/
 
-#define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
-#define PRINT_K(p, args...) { if (PRIVATE_Message) printk(p, ##args); }
+#define DBG_PRT(l, p, args...) ({ if (l <= msglevel) printk(p, ##args); })
+#define PRINT_K(p, args...) ({ if (PRIVATE_Message) printk(p, ##args); })
 
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

