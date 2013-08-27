Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3H0PyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:54:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:27774 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3H0PyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:54:05 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] staging: ozwpan: Add debounce time before unregistering.
Date: Tue, 27 Aug 2013 16:53:42 +0100
Message-ID: <1377618823-12246-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes following error caused during unloading driver.

[ 1127.542888] usb 5-1: USB disconnect, device number 2
[ 1127.542909] ozwpan ozwpan: remove, state 1
[ 1127.542933] usb usb5: USB disconnect, device number 1
[ 1127.618634] hub 5-0:1.0: hub_port_status failed (err = -19)
[ 1127.618647] hub_port_connect_change: 45 callbacks suppressed
[ 1127.618657] hub 5-0:1.0: connect-debounce failed, port 1 disabled
[ 1127.618668] hub 5-0:1.0: cannot disable port 1 (err = -19)

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 39f5066..d9c43c3 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -57,6 +57,10 @@
  */
 #define EP0_TIMEOUT_COUNTER 13
 
+/* Debounce time HCD driver should wait before unregistering.
+ */
+#define OZ_HUB_DEBOUNCE_TIMEOUT 1500
+
 /*
  * Used to link urbs together and also store some status information for each
  * urb.
@@ -2355,6 +2359,7 @@ error:
  */
 void oz_hcd_term(void)
 {
+	msleep(OZ_HUB_DEBOUNCE_TIMEOUT);
 	tasklet_kill(&g_urb_process_tasklet);
 	tasklet_kill(&g_urb_cancel_tasklet);
 	platform_device_unregister(g_plat_dev);
-- 
1.7.9.5

