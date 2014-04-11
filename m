Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaDKNA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:00:57 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53316 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaDKNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:00:51 -0400
Message-ID: <5347E781.3030309@gmail.com>
Date: Fri, 11 Apr 2014 15:00:49 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Tugce Sirin <ztugcesirin@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: fix bad symbol declaration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With sparse, the following error appears :
  CHECK   drivers/staging/wlan-ng/p80211netdev.c
drivers/staging/wlan-ng/cfg80211.c:710:6: warning: symbol 'prism2_connect_result' was not declared. Should it be static?
drivers/staging/wlan-ng/cfg80211.c:719:6: warning: symbol 'prism2_disconnected' was not declared. Should it be static?
drivers/staging/wlan-ng/cfg80211.c:725:6: warning: symbol 'prism2_roamed' was not declared. Should it be static?

Move functions declaration to coherent internal header file.

Signed-off-by: Neil 'Superna' Armstrong <superna9999@gmail.com>
---
 drivers/staging/wlan-ng/prism2mgmt.h |    5 +++++
 drivers/staging/wlan-ng/prism2sta.c  |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
index 190d390..b62fdcb 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.h
+++ b/drivers/staging/wlan-ng/prism2mgmt.h
@@ -109,4 +109,9 @@ void prism2sta_processing_defer(struct work_struct *data);
 void prism2sta_commsqual_defer(struct work_struct *data);
 void prism2sta_commsqual_timer(unsigned long data);
 
+/* Interface callback functions, passing data back up to the cfg80211 layer */
+void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
+void prism2_disconnected(wlandevice_t *wlandev);
+void prism2_roamed(wlandevice_t *wlandev);
+
 #endif
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index f9ccf23..3fd4538 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -120,10 +120,6 @@ MODULE_PARM_DESC(prism2_reset_settletime, "reset settle time in ms");
 
 MODULE_LICENSE("Dual MPL/GPL");
 
-void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
-void prism2_disconnected(wlandevice_t *wlandev);
-void prism2_roamed(wlandevice_t *wlandev);
-
 static int prism2sta_open(wlandevice_t *wlandev);
 static int prism2sta_close(wlandevice_t *wlandev);
 static void prism2sta_reset(wlandevice_t *wlandev);
-- 
1.7.10.4
