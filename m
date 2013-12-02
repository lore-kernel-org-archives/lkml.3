Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3LBTOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3LBTON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        KaiChung Cheng <kenny_cheng@wistron.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 131/173] HID: multicouh: add PID VID to support 1 new Wistron optical touch device
Date: Mon,  2 Dec 2013 11:11:54 -0800
Message-Id: <20131202191158.481750990@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaiChung Cheng <kenny_cheng@wistron.com>

commit bf9d121efc18c30caa2caad85358cf9408eca117 upstream.

This patch adds PID VID to support for the Wistron Inc. Optical touch panel.

Signed-off-by: KaiChung Cheng <kenny_cheng@wistron.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    6 ++++++
 3 files changed, 10 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -442,6 +442,7 @@ config HID_MULTITOUCH
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
+	  - Wistron optical touch panels
 	  - XAT optical touch panels
 	  - Xiroku optical touch panels
 	  - Zytronic touch panels
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -879,6 +879,9 @@
 #define USB_DEVICE_ID_SUPER_DUAL_BOX_PRO 0x8802
 #define USB_DEVICE_ID_SUPER_JOY_BOX_5_PRO 0x8804
 
+#define USB_VENDOR_ID_WISTRON		0x0fb8
+#define USB_DEVICE_ID_WISTRON_OPTICAL_TOUCH		0x1109
+
 #define USB_VENDOR_ID_X_TENSIONS               0x1ae7
 #define USB_DEVICE_ID_SPEEDLINK_VAD_CEZANNE    0x9001
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1353,6 +1353,12 @@ static const struct hid_device_id mt_dev
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
+
+	/* Wistron panels */
+	{ .driver_data = MT_CLS_NSMU,
+		MT_USB_DEVICE(USB_VENDOR_ID_WISTRON,
+			USB_DEVICE_ID_WISTRON_OPTICAL_TOUCH) },
+
 	/* XAT */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XAT,


