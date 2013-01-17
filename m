Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3AQXIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:08:37 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34226 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab3AQXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:08:36 -0500
From: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Subject: [PATCH 1/3] wlan-ng/prism2mgmt.c: added parenthesis to macro
Date: Fri, 18 Jan 2013 00:07:30 +0100
Message-Id: <1358464052-14002-2-git-send-email-qi50dube@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@cip.cs.fau.de>

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de> 

---
 drivers/staging/wlan-ng/prism2mgmt.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 4efa9bc..62b94b0 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -415,11 +415,14 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 			break;
 
 #define REQBASICRATE(N) \
-	if ((count >= N) && DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
-		req->basicrate ## N .data = item->supprates[(N)-1]; \
-		req->basicrate ## N .status = \
-			P80211ENUM_msgitem_status_data_ok; \
-	}
+	do { \
+		if (count >= N &&
+		    DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
+			req->basicrate ## N .data = item->supprates[(N)-1]; \
+			req->basicrate ## N .status = \
+				P80211ENUM_msgitem_status_data_ok; \
+		} \
+	} while (0)
 
 	REQBASICRATE(1);
 	REQBASICRATE(2);
@@ -431,11 +434,13 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
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
+	} \
+	} while (0)
 
 	REQSUPPRATE(1);
 	REQSUPPRATE(2);
-- 
1.7.10.4

