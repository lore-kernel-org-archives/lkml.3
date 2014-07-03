Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaGCJVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbaGCJVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/198] [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE
Date: Thu,  3 Jul 2014 10:17:46 +0100
Message-Id: <1404379241-8590-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

commit c859e6ef33ac0c9a5e9e934fe11a2232752b4e96 upstream.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h        |  2 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 143d90819ec3..4cfb9624d69c 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -371,4 +371,6 @@
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
 #define USB_PID_CPYTO_REDI_PC50A			0xa803
 #define USB_PID_CTVDIGDUAL_V2				0xe410
+#define USB_PID_PCTV_2002E                              0x025c
+#define USB_PID_PCTV_2002E_SE                           0x025d
 #endif
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index f08136052f9c..829323e42ca0 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3589,6 +3589,8 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7790P) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE8096P) },
 /* 80 */{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
+	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E) },
+	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3993,12 +3995,20 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.num_device_descs = 1,
+		.num_device_descs = 3,
 		.devices = {
 			{   "Hauppauge Nova-TD Stick (52009)",
 				{ &dib0700_usb_id_table[35], NULL },
 				{ NULL },
 			},
+			{   "PCTV 2002e",
+				{ &dib0700_usb_id_table[81], NULL },
+				{ NULL },
+			},
+			{   "PCTV 2002e SE",
+				{ &dib0700_usb_id_table[82], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc.core = {
-- 
1.9.1

