Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3ATPZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:25:13 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55387 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab3ATPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:25:11 -0500
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: [PATCH 1/2] wlan-ng/prism2mgmt.c: added parantheses to macro
Date: Sun, 20 Jan 2013 16:24:45 +0100
Message-Id: <1358695485-1793-1-git-send-email-sisewank@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@cip.cs.fau.de>

Enclose the macro into braces so that it can be closed by a semicolon

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>

---
 drivers/staging/wlan-ng/prism2mgmt.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 02a4bf7..6021f89 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -421,11 +421,14 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 			break;
 
 #define REQBASICRATE(N) \
-	if ((count >= N) && DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
-		req->basicrate ## N .data = item->supprates[(N)-1]; \
-		req->basicrate ## N .status = \
-			P80211ENUM_msgitem_status_data_ok; \
-	}
+	do { \
+		if ((count >= N) && DOT11_RATE5_ISBASIC_GET( \
+			item->supprates[(N)-1])) { \
+			req->basicrate ## N .data = item->supprates[(N)-1]; \
+			req->basicrate ## N .status = \
+				P80211ENUM_msgitem_status_data_ok; \
+		} \
+	} while (0)
 
 	REQBASICRATE(1);
 	REQBASICRATE(2);
@@ -437,11 +440,13 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 	REQBASICRATE(8);
 
 #define REQSUPPRATE(N) \
-	if (count >= N) { \
-		req->supprate ## N .data = item->supprates[(N)-1]; \
-		req->supprate ## N .status = \
-			P80211ENUM_msgitem_status_data_ok; \
-	}
+	do { \
+		if (count >= N) { \
+			req->supprate ## N .data = item->supprates[(N)-1]; \
+			req->supprate ## N .status = \
+				P80211ENUM_msgitem_status_data_ok; \
+		} \
+	} while (0)
 
 	REQSUPPRATE(1);
 	REQSUPPRATE(2);
-- 
1.7.10.4

