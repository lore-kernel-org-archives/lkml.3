Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799AbaAFXf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:35:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaAFWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kunilov <dmitry.kunilov@gmail.com>
Subject: [PATCH 3.10 016/129] usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option
Date: Mon,  6 Jan 2014 14:37:25 -0800
Message-Id: <20140106223900.057442772@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kunilov <dmitry.kunilov@gmail.com>

commit 52d0dc7597c89b2ab779f3dcb9b9bf0800dd9218 upstream.

ZTE AC2726 EVDO modem drops ppp connection every minute when driven by
zte_ev but works fine when driven by option. Move the support for AC2726
back to option driver.

Signed-off-by: Dmitry Kunilov <dmitry.kunilov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 drivers/usb/serial/zte_ev.c |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -251,6 +251,7 @@ static void option_instat_callback(struc
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_MC2718			0xffe8
+#define ZTE_PRODUCT_AC2726			0xfff1
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -1453,6 +1454,7 @@ static const struct usb_device_id option
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -281,8 +281,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19d2, 0xfffd) },
 	{ USB_DEVICE(0x19d2, 0xfffc) },
 	{ USB_DEVICE(0x19d2, 0xfffb) },
-	/* AC2726, AC8710_V3 */
-	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xfff1, 0xff, 0xff, 0xff) },
+	/* AC8710_V3 */
 	{ USB_DEVICE(0x19d2, 0xfff6) },
 	{ USB_DEVICE(0x19d2, 0xfff7) },
 	{ USB_DEVICE(0x19d2, 0xfff8) },


