Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaJCWVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:21:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbaJCWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 211/238] media: af9035: new IDs: add support for PCTV 78e and PCTV 79e
Date: Fri,  3 Oct 2014 14:32:06 -0700
Message-Id: <20141003212920.410911504@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit a04646c045cab08a9e62b9be8f01ecbb0632d24e upstream.

add the following IDs
USB_PID_PCTV_78E (0x025a) for PCTV 78e
USB_PID_PCTV_79E (0x0262) for PCTV 79e

For these it9135 devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-core/dvb-usb-ids.h  |    2 ++
 drivers/media/usb/dvb-usb-v2/af9035.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -279,6 +279,8 @@
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E				0x021f
+#define USB_PID_PCTV_78E				0x025a
+#define USB_PID_PCTV_79E				0x0262
 #define USB_PID_REALTEK_RTL2831U			0x2831
 #define USB_PID_REALTEK_RTL2832U			0x2832
 #define USB_PID_TECHNOTREND_CONNECT_S2_3600		0x3007
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1541,6 +1541,10 @@ static const struct usb_device_id af9035
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
 		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_78E,
+		&af9035_props, "PCTV 78e", RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
+		&af9035_props, "PCTV 79e", RC_MAP_IT913X_V2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);


