Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaKZOn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:43:56 -0500
Received: from m50-132.163.com ([123.125.50.132]:37056 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaKZOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:43:54 -0500
Message-ID: <5475E0C7.9020500@163.com>
Date: Wed, 26 Nov 2014 22:16:39 +0800
From: Huang Bo <huangbobupt@163.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] HID: add BETOP game controller force feedback support
References: <3e9f782f.a7fa.149df95fef7.Coremail.huangbobupt@163.com> <alpine.LNX.2.00.1411251534010.23174@pobox.suse.cz> <3497222f.2152a.149ec27f2c1.Coremail.huangbobupt@163.com> <alpine.LNX.2.00.1411261414160.23174@pobox.suse.cz> <5475D7CC.1080606@163.com> <alpine.LNX.2.00.1411261449140.23174@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1411261449140.23174@pobox.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------000809000808060402020709"
X-CM-TRANSID: DNGowED5h1LK4HVU3YPPAQ--.859S3
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ww1kWF4xtw1xGF1rWF1fXrb_yoW3KFy5pF
	Z8JrZ0yrWDAFy7KrW0kw1DZF90van7A340gFW7Cw1Y9Fy5Aa95urn7trWjvrn8JFZ5t3sx
	Wrn8Wa98KFW5taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UyGQgUUUUU=
X-Originating-IP: [123.126.33.253]
X-CM-SenderInfo: xkxd0wpere31rw6rljoofrz/1tbiWB5Q-FEALscJ6AAAsz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000809000808060402020709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/26/2014 09:49 PM, Jiri Kosina wrote:
> On Wed, 26 Nov 2014, Huang Bo wrote:
>
>>> It's unfortunately whitespace damaged again. If it's not possible to set 
>>> up your e-mail client not to cause whitespace damage to patches (please 
>>> see Documentation/email-clients.txt for some hints), attach the patch as 
>>> an e-mail attachment.
>>>
>> From: Huang Bo <huangbobupt@163.com>
>>
>> Adds force feedback support for BETOP USB game controllers.
>> These devices are mass produced in China.
> Alright, so you apparently wrote the code with incorrect formatting, as 
> even the version you attached doesn't have the formatting right.
>
> Please reformat the code according to Documentation/CodingStyle and 
> resubmit.
>
> Thanks,
>
From: Huang Bo <huangbobupt@163.com>

Adds force feedback support for BETOP USB game controllers.
These devices are mass produced in China.

Signed-off-by: Huang Bo <huangbobupt@163.com>
---
 drivers/hid/Kconfig       |   10 +++
 drivers/hid/Makefile      |    1 +
 drivers/hid/hid-betopff.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c    |    4 ++
 drivers/hid/hid-ids.h     |    5 ++
 5 files changed, 188 insertions(+)
 create mode 100644 drivers/hid/hid-betopff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4938bd3..0a8fdc5 100755
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -201,6 +201,16 @@ config DRAGONRISE_FF
     Say Y here if you want to enable force feedback support for DragonRise Inc.
     game controllers.
 
+config HID_BETOP_FF
+    tristate "Betop Production Inc. force feedback support"
+    depends on USB_HID
+    select INPUT_FF_MEMLESS
+    ---help---
+    Say Y here if you want to enable force feedback support for devices by
+    BETOP Production Ltd.
+    Currently the following devices are known to be supported:
+     - BETOP 2185 PC & BFM MODE
+
 config HID_EMS_FF
     tristate "EMS Production Inc. force feedback support"
     depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 4113999..a0546ca 100755
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_HID_CHERRY)    += hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)    += hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)    += hid-cypress.o
 obj-$(CONFIG_HID_DRAGONRISE)    += hid-dr.o
+obj-$(CONFIG_HID_BETOP_FF)    += hid-betopff.o
 obj-$(CONFIG_HID_EMS_FF)    += hid-emsff.o
 obj-$(CONFIG_HID_ELECOM)    += hid-elecom.o
 obj-$(CONFIG_HID_EZKEY)        += hid-ezkey.o
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
new file mode 100644
index 0000000..447d6ba
--- /dev/null
+++ b/drivers/hid/hid-betopff.c
@@ -0,0 +1,168 @@
+/*
+ *  Force feedback support for Betop based devices
+ *
+ *  The devices are distributed under various names and the same USB device ID
+ *  can be used in both adapters and actual game controllers.
+ *
+ *  0x11C0:0x5506 "BTP2185 PC mode Joystick"
+ *   - tested with BTP2185 PC Mode.
+ *
+ *  0x11c2:0x2208 "BTP2185 BFM mode Joystick"
+ *   - tested with BTP2185 BFM Mode.
+ *
+ *  0x8380:0x1850 "BTP2185 V2 PC mode USB Gamepad"
+ *   - tested with BTP2185 PC Mode with another version.
+ *
+ *  0x20bc:0x5500 "BTP2185 V2 BFM mode Joystick"
+ *   - tested with BTP2171s.
+ *  Copyright (c) 2014 Huang Bo <huangbobupt@163.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/hid.h>
+
+#include "hid-ids.h"
+
+struct betopff_device {
+    struct hid_report *report;
+};
+
+static int hid_betopff_play(struct input_dev *dev, void *data,
+             struct ff_effect *effect)
+{
+    struct hid_device *hid = input_get_drvdata(dev);
+    struct betopff_device *betopff = data;
+    __u16 left, right;
+
+    left = effect->u.rumble.strong_magnitude;
+    right = effect->u.rumble.weak_magnitude;
+
+    betopff->report->field[2]->value[0] = left / 256;
+    betopff->report->field[3]->value[0] = right / 256;
+
+    hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+    return 0;
+}
+
+static int betopff_init(struct hid_device *hid)
+{
+    struct betopff_device *betopff;
+    struct hid_report *report;
+    struct hid_input *hidinput;
+    struct list_head *report_list =
+            &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+    struct list_head *report_ptr = report_list;
+    struct input_dev *dev;
+    int error;
+    int i, j;
+    int field_count = 0;
+
+    if (list_empty(report_list)) {
+        hid_err(hid, "no output reports found\n");
+        return -ENODEV;
+    }
+
+    list_for_each_entry(hidinput, &hid->inputs, list) {
+
+        report_ptr = report_ptr->next;
+
+        if (report_ptr == report_list) {
+            hid_err(hid, "required output report is missing\n");
+            return -ENODEV;
+        }
+
+        report = list_entry(report_ptr, struct hid_report, list);
+        if (report->maxfield < 1) {
+            hid_err(hid, "no fields in the report\n");
+            return -ENODEV;
+        }
+
+        for (i = 0; i < report->maxfield; i++) {
+            for (j = 0; j < report->field[i]->report_count; j++) {
+                report->field[i]->value[j] = 0x00;
+                field_count++;
+            }
+        }
+
+        if (field_count < 4) {
+            hid_err(hid, "not enough fields in the report: %d\n",
+                    field_count);
+            return -ENODEV;
+        }
+
+        betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
+        if (!betopff)
+            return -ENOMEM;
+
+        dev = hidinput->input;
+        set_bit(FF_RUMBLE, dev->ffbit);
+
+        error = input_ff_create_memless(dev, betopff, hid_betopff_play);
+        if (error) {
+            kfree(betopff);
+            return error;
+        }
+
+        betopff->report = report;
+        hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+    }
+
+    hid_info(hid, "Force feedback for betop devices by huangbo <huangbobupt@163.com>\n");
+
+    return 0;
+}
+
+static int betop_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+    int ret;
+
+    if (id->driver_data)
+        hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+
+    ret = hid_parse(hdev);
+    if (ret) {
+        hid_err(hdev, "parse failed\n");
+        goto err;
+    }
+
+    ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+    if (ret) {
+        hid_err(hdev, "hw start failed\n");
+        goto err;
+    }
+
+    betopff_init(hdev);
+
+    return 0;
+err:
+    return ret;
+}
+
+static const struct hid_device_id betop_devices[] = {
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
+    { }
+};
+MODULE_DEVICE_TABLE(hid, betop_devices);
+
+static struct hid_driver betop_driver = {
+    .name = "betop",
+    .id_table = betop_devices,
+    .probe = betop_probe,
+};
+module_hid_driver(betop_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a622590..5ae554e 100755
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1820,6 +1820,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
     { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
     { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
     { HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
 
     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 161ee89..dce26bb 100755
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -907,6 +907,11 @@
 #define USB_VENDOR_ID_ZYDACRON    0x13EC
 #define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL    0x0006
 
+#define USB_VENDOR_ID_BETOP_2185PC    0x11c0
+#define USB_VENDOR_ID_BETOP_2185BFM    0x11c2
+#define USB_VENDOR_ID_BETOP_2185V2PC    0x8380
+#define USB_VENDOR_ID_BETOP_2185V2BFM    0x20bc
+
 #define USB_VENDOR_ID_ZYTRONIC        0x14c8
 #define USB_DEVICE_ID_ZYTRONIC_ZXY100    0x0005
 
-- 
1.7.9.5


--------------000809000808060402020709
Content-Type: text/x-patch;
 name="0001-HID-add-BETOP-game-controller-force-feedback-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-HID-add-BETOP-game-controller-force-feedback-support.pa";
 filename*1="tch"

>From ce4bd236f4fc23c7c8540d122c8ffc4327dab893 Mon Sep 17 00:00:00 2001
From: Huang Bo <huangbobupt@163.com>
Date: Wed, 26 Nov 2014 18:21:03 +0800
Subject: [PATCH] HID: add BETOP game controller force feedback support

Adds force feedback support for BETOP USB game controllers.
These devices are mass produced in China.

Signed-off-by: Huang Bo <huangbobupt@163.com>
---
 drivers/hid/Kconfig       |   10 +++
 drivers/hid/Makefile      |    1 +
 drivers/hid/hid-betopff.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c    |    4 ++
 drivers/hid/hid-ids.h     |    5 ++
 5 files changed, 188 insertions(+)
 create mode 100644 drivers/hid/hid-betopff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4938bd3..0a8fdc5 100755
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -201,6 +201,16 @@ config DRAGONRISE_FF
 	Say Y here if you want to enable force feedback support for DragonRise Inc.
 	game controllers.
 
+config HID_BETOP_FF
+	tristate "Betop Production Inc. force feedback support"
+	depends on USB_HID
+	select INPUT_FF_MEMLESS
+	---help---
+	Say Y here if you want to enable force feedback support for devices by
+	BETOP Production Ltd.
+	Currently the following devices are known to be supported:
+	 - BETOP 2185 PC & BFM MODE
+
 config HID_EMS_FF
 	tristate "EMS Production Inc. force feedback support"
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 4113999..a0546ca 100755
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
 obj-$(CONFIG_HID_DRAGONRISE)	+= hid-dr.o
+obj-$(CONFIG_HID_BETOP_FF)	+= hid-betopff.o
 obj-$(CONFIG_HID_EMS_FF)	+= hid-emsff.o
 obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
 obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
new file mode 100644
index 0000000..447d6ba
--- /dev/null
+++ b/drivers/hid/hid-betopff.c
@@ -0,0 +1,168 @@
+/*
+ *  Force feedback support for Betop based devices
+ *
+ *  The devices are distributed under various names and the same USB device ID
+ *  can be used in both adapters and actual game controllers.
+ *
+ *  0x11C0:0x5506 "BTP2185 PC mode Joystick"
+ *   - tested with BTP2185 PC Mode.
+ *
+ *  0x11c2:0x2208 "BTP2185 BFM mode Joystick"
+ *   - tested with BTP2185 BFM Mode.
+ *
+ *  0x8380:0x1850 "BTP2185 V2 PC mode USB Gamepad"
+ *   - tested with BTP2185 PC Mode with another version.
+ *
+ *  0x20bc:0x5500 "BTP2185 V2 BFM mode Joystick"
+ *   - tested with BTP2171s.
+ *  Copyright (c) 2014 Huang Bo <huangbobupt@163.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/hid.h>
+
+#include "hid-ids.h"
+
+struct betopff_device {
+	struct hid_report *report;
+};
+
+static int hid_betopff_play(struct input_dev *dev, void *data,
+			 struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct betopff_device *betopff = data;
+	__u16 left, right;
+
+	left = effect->u.rumble.strong_magnitude;
+	right = effect->u.rumble.weak_magnitude;
+
+	betopff->report->field[2]->value[0] = left / 256;
+	betopff->report->field[3]->value[0] = right / 256;
+
+	hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+	return 0;
+}
+
+static int betopff_init(struct hid_device *hid)
+{
+	struct betopff_device *betopff;
+	struct hid_report *report;
+	struct hid_input *hidinput;
+	struct list_head *report_list =
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct list_head *report_ptr = report_list;
+	struct input_dev *dev;
+	int error;
+	int i, j;
+	int field_count = 0;
+
+	if (list_empty(report_list)) {
+		hid_err(hid, "no output reports found\n");
+		return -ENODEV;
+	}
+
+	list_for_each_entry(hidinput, &hid->inputs, list) {
+
+		report_ptr = report_ptr->next;
+
+		if (report_ptr == report_list) {
+			hid_err(hid, "required output report is missing\n");
+			return -ENODEV;
+		}
+
+		report = list_entry(report_ptr, struct hid_report, list);
+		if (report->maxfield < 1) {
+			hid_err(hid, "no fields in the report\n");
+			return -ENODEV;
+		}
+
+		for (i = 0; i < report->maxfield; i++) {
+			for (j = 0; j < report->field[i]->report_count; j++) {
+				report->field[i]->value[j] = 0x00;
+				field_count++;
+			}
+		}
+
+		if (field_count < 4) {
+			hid_err(hid, "not enough fields in the report: %d\n",
+					field_count);
+			return -ENODEV;
+		}
+
+		betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
+		if (!betopff)
+			return -ENOMEM;
+
+		dev = hidinput->input;
+		set_bit(FF_RUMBLE, dev->ffbit);
+
+		error = input_ff_create_memless(dev, betopff, hid_betopff_play);
+		if (error) {
+			kfree(betopff);
+			return error;
+		}
+
+		betopff->report = report;
+		hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+	}
+
+	hid_info(hid, "Force feedback for betop devices by huangbo <huangbobupt@163.com>\n");
+
+	return 0;
+}
+
+static int betop_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	if (id->driver_data)
+		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "parse failed\n");
+		goto err;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+	if (ret) {
+		hid_err(hdev, "hw start failed\n");
+		goto err;
+	}
+
+	betopff_init(hdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id betop_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, betop_devices);
+
+static struct hid_driver betop_driver = {
+	.name = "betop",
+	.id_table = betop_devices,
+	.probe = betop_probe,
+};
+module_hid_driver(betop_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a622590..5ae554e 100755
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1820,6 +1820,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 161ee89..dce26bb 100755
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -907,6 +907,11 @@
 #define USB_VENDOR_ID_ZYDACRON	0x13EC
 #define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL	0x0006
 
+#define USB_VENDOR_ID_BETOP_2185PC	0x11c0
+#define USB_VENDOR_ID_BETOP_2185BFM	0x11c2
+#define USB_VENDOR_ID_BETOP_2185V2PC	0x8380
+#define USB_VENDOR_ID_BETOP_2185V2BFM	0x20bc
+
 #define USB_VENDOR_ID_ZYTRONIC		0x14c8
 #define USB_DEVICE_ID_ZYTRONIC_ZXY100	0x0005
 
-- 
1.7.9.5


--------------000809000808060402020709--

