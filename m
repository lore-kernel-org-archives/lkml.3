Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3AYGou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:44:50 -0500
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:34471 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3AYGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:44:47 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 01:44:46 EST
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=3f4U5fHrZLLPCzJ96ldNbjtja1zQ0ih230F6vdsLr5s= c=1 sm=1
 a=cqZlwJiDfgUA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=auE1FfZpAAAA:8
 a=wmEOgL5qGPie-FilO6oA:9 a=QhNQsjeWOoAA:10 a=Ux_uGsAPmqgA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 1/4] USB: HID: SRW-S1 Gaming Wheel Driver
Date: Thu, 24 Jan 2013 23:34:44 -0700
Message-Id: <1359095687-13398-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: simon <simon@simon-virtual-machine.(none)>

Add support the SRW-S1 by patching HID descriptor to read axis
as Generic Desktop X, Y and Z (rather than Usage page being
'Simulation').

Signed-off-by: Simon Wood <simon@mungewell.org>
tested-by: John Murphy <rosegardener@freeode.co.uk>

---
 drivers/hid/Kconfig     |    6 +++++
 drivers/hid/Makefile    |    1 +
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    3 +++
 drivers/hid/hid-srws1.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+)
 create mode 100644 drivers/hid/hid-srws1.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e7d6a13..3c98517 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -596,6 +596,12 @@ config HID_SPEEDLINK
 	---help---
 	Support for Speedlink Vicious and Divine Cezanne mouse.
 
+config HID_SRWS1
+	tristate "Steelseries SRW-S1 steering wheel support"
+	depends on USB_HID
+	---help---
+	Support for Steelseries SRW-S1 steering wheel
+
 config HID_SUNPLUS
 	tristate "Sunplus wireless desktop"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b622157..d3102e2 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SPEEDLINK)	+= hid-speedlink.o
+obj-$(CONFIG_HID_SRWS1)    	+= hid-srws1.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb2ee11..65cda7f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1697,6 +1697,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4dfa605..f5976f3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -723,6 +723,9 @@
 #define USB_VENDOR_ID_STANTUM_SITRONIX		0x1403
 #define USB_DEVICE_ID_MTP_SITRONIX		0x5001
 
+#define USB_VENDOR_ID_STEELSERIES	0x1038
+#define USB_DEVICE_ID_STEELSERIES_SRWS1	0x1410
+
 #define USB_VENDOR_ID_SUN		0x0430
 #define USB_DEVICE_ID_RARITAN_KVM_DONGLE	0xcdab
 
diff --git a/drivers/hid/hid-srws1.c b/drivers/hid/hid-srws1.c
new file mode 100644
index 0000000..7776d74
--- /dev/null
+++ b/drivers/hid/hid-srws1.c
@@ -0,0 +1,58 @@
+/*
+ *  HID driver for Steelseries SRW-S1
+ *
+ *  Copyright (c) 2013 Simon Wood
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+static __u8 *srws1_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int *rsize)
+{
+	if (*rsize >= 115 && rdesc[11] == 0x02 && rdesc[13] == 0xc8
+			&& rdesc[29] == 0xbb && rdesc[40] == 0xc5) {
+		hid_info(hdev, "Fixing up Steelseries SRW-S1 report descriptor\n");
+		rdesc[11] = 0x01;
+		rdesc[13] = 0x30;
+		rdesc[29] = 0x31;
+		rdesc[40] = 0x32;
+	}
+	return rdesc;
+}
+
+static const struct hid_device_id srws1_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, srws1_devices);
+
+static struct hid_driver srws1_driver = {
+	.name = "srws1",
+	.id_table = srws1_devices,
+	.report_fixup = srws1_report_fixup
+};
+
+static int __init srws1_init(void)
+{
+	return hid_register_driver(&srws1_driver);
+}
+
+static void __exit srws1_exit(void)
+{
+	hid_unregister_driver(&srws1_driver);
+}
+
+module_init(srws1_init);
+module_exit(srws1_exit);
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

