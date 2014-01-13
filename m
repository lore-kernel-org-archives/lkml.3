Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaAMQCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaAMQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kunilov <dmitry.kunilov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/208] usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option
Date: Mon, 13 Jan 2014 15:57:58 +0000
Message-Id: <1389628849-1614-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kunilov <dmitry.kunilov@gmail.com>

commit 52d0dc7597c89b2ab779f3dcb9b9bf0800dd9218 upstream.

ZTE AC2726 EVDO modem drops ppp connection every minute when driven by
zte_ev but works fine when driven by option. Move the support for AC2726
back to option driver.

Signed-off-by: Dmitry Kunilov <dmitry.kunilov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 drivers/usb/serial/zte_ev.c | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 496b7e39..cc7a241 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -251,6 +251,7 @@ static void option_instat_callback(struct urb *urb);
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_MC2718			0xffe8
+#define ZTE_PRODUCT_AC2726			0xfff1
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -1453,6 +1454,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index fca4c75..eae2c87 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -281,8 +281,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x19d2, 0xfffd) },
 	{ USB_DEVICE(0x19d2, 0xfffc) },
 	{ USB_DEVICE(0x19d2, 0xfffb) },
-	/* AC2726, AC8710_V3 */
-	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xfff1, 0xff, 0xff, 0xff) },
+	/* AC8710_V3 */
 	{ USB_DEVICE(0x19d2, 0xfff6) },
 	{ USB_DEVICE(0x19d2, 0xfff7) },
 	{ USB_DEVICE(0x19d2, 0xfff8) },
-- 
1.8.3.2

