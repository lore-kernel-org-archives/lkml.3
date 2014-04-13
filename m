Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaDMQkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 12:40:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38983 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaDMQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 12:40:45 -0400
From: code@slynux.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sarath Lakshman <sarathlakshman@slynux.com>
Subject: [PATCH] staging: wlan-ng: Fix sparse warnings
Date: Sun, 13 Apr 2014 22:09:49 +0530
Message-Id: <1397407189-6648-1-git-send-email-code@slynux.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarath Lakshman <sarathlakshman@slynux.com>

Fixed missed declarations for few non-static functions.

Signed-off-by: Sarath Lakshman <sarathlakshman@slynux.com>
---
 drivers/staging/wlan-ng/cfg80211.c   | 1 +
 drivers/staging/wlan-ng/prism2mgmt.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f76f95c..662581c 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -1,4 +1,5 @@
 /* cfg80211 Interface for prism2_usb module */
+#include "prism2mgmt.h"
 
 
 /* Prism2 channel/frequency/bitrate declarations */
diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
index 190d390..ad049ad 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.h
+++ b/drivers/staging/wlan-ng/prism2mgmt.h
@@ -60,6 +60,8 @@
 #ifndef _PRISM2MGMT_H
 #define _PRISM2MGMT_H
 
+#include "hfa384x.h"
+
 extern int prism2_reset_holdtime;
 extern int prism2_reset_settletime;
 
@@ -109,4 +111,8 @@ void prism2sta_processing_defer(struct work_struct *data);
 void prism2sta_commsqual_defer(struct work_struct *data);
 void prism2sta_commsqual_timer(unsigned long data);
 
+void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
+void prism2_disconnected(wlandevice_t *wlandev);
+void prism2_roamed(wlandevice_t *wlandev);
+
 #endif
-- 
1.8.3.2

