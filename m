Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3CJLcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:32:52 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:44633 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab3CJLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:32:48 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 7A1723DC324
Subject: [PATCH 1/5] HID: roccat: Added support for Roccat Kone Pure gaming
 mouse
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:32:44 +0100
Message-ID: <1362915164.2769.166.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userland-tools can already be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-konepure   |  105 +++++++
 drivers/hid/Makefile                               |    4 +-
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-konepure.c                  |  304 ++++++++++++++++++++
 drivers/hid/hid-roccat-konepure.h                  |   72 +++++
 6 files changed, 485 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
 create mode 100644 drivers/hid/hid-roccat-konepure.c
 create mode 100644 drivers/hid/hid-roccat-konepure.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure b/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
new file mode 100644
index 0000000..41a9b7f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
@@ -0,0 +1,105 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/actual_profile
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. actual_profile holds number of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the mouse is powered on next time.
+		When written, the mouse activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The mouse will reject invalid data.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/control
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/info
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/macro
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store a macro with max 500 key/button strokes
+		internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 2082 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_buttons
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds information about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 59 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/profile_settings
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds information like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 31 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/sensor
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a tracking- and a distance-control-unit. These
+		can be activated/deactivated and the lift-off distance can be
+		set. The data has to be 6 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/talk
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	Used to active some easy* functions of the mouse from outside.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written a calibration process for the tracking control unit
+		can be initiated/cancelled. Also lets one read/write sensor
+		registers.
+		The data has to be 4 bytes long.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/konepure/roccatkonepure<minor>/tcu_image
+Date:		December 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read the mouse returns a 30x30 pixel image of the
+		sampled underground. This works only in the course of a
+		calibration process initiated with tcu.
+		The returned data is 1028 bytes in size.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 72d1b0b..2735151 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -94,8 +94,8 @@ obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
 obj-$(CONFIG_HID_PS3REMOTE)	+= hid-ps3remote.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o hid-roccat-common.o \
 	hid-roccat-arvo.o hid-roccat-isku.o hid-roccat-kone.o \
-	hid-roccat-koneplus.o hid-roccat-kovaplus.o hid-roccat-lua.o \
-	hid-roccat-pyra.o hid-roccat-savu.o
+	hid-roccat-koneplus.o hid-roccat-konepure.o hid-roccat-kovaplus.o \
+	hid-roccat-lua.o hid-roccat-pyra.o hid-roccat-savu.o
 obj-$(CONFIG_HID_SAITEK)	+= hid-saitek.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 512b01c..733d7e0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1687,6 +1687,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_LUA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92e47e5..007ee74 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -689,6 +689,7 @@
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
+#define USB_DEVICE_ID_ROCCAT_KONEPURE	0x2dbe
 #define USB_DEVICE_ID_ROCCAT_KONEXTD	0x2e22
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
diff --git a/drivers/hid/hid-roccat-konepure.c b/drivers/hid/hid-roccat-konepure.c
new file mode 100644
index 0000000..c79d0b0
--- /dev/null
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -0,0 +1,304 @@
+/*
+ * Roccat KonePure driver for Linux
+ *
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * Roccat KonePure is a smaller version of KoneXTD with less buttons and lights.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/hid-roccat.h>
+#include "hid-ids.h"
+#include "hid-roccat-common.h"
+#include "hid-roccat-konepure.h"
+
+static struct class *konepure_class;
+
+static ssize_t konepure_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct konepure_device *konepure = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&konepure->konepure_lock);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&konepure->konepure_lock);
+
+	return retval ? retval : real_size;
+}
+
+static ssize_t konepure_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct konepure_device *konepure = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&konepure->konepure_lock);
+	retval = roccat_common2_send_with_status(usb_dev, command,
+			(void *)buf, real_size);
+	mutex_unlock(&konepure->konepure_lock);
+
+	return retval ? retval : real_size;
+}
+
+#define KONEPURE_SYSFS_W(thingy, THINGY) \
+static ssize_t konepure_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return konepure_sysfs_write(fp, kobj, buf, off, count, \
+			KONEPURE_SIZE_ ## THINGY, KONEPURE_COMMAND_ ## THINGY); \
+}
+
+#define KONEPURE_SYSFS_R(thingy, THINGY) \
+static ssize_t konepure_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return konepure_sysfs_read(fp, kobj, buf, off, count, \
+			KONEPURE_SIZE_ ## THINGY, KONEPURE_COMMAND_ ## THINGY); \
+}
+
+#define KONEPURE_SYSFS_RW(thingy, THINGY) \
+KONEPURE_SYSFS_W(thingy, THINGY) \
+KONEPURE_SYSFS_R(thingy, THINGY)
+
+#define KONEPURE_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = KONEPURE_SIZE_ ## THINGY, \
+	.read = konepure_sysfs_read_ ## thingy, \
+	.write = konepure_sysfs_write_ ## thingy \
+}
+
+#define KONEPURE_BIN_ATTRIBUTE_R(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = KONEPURE_SIZE_ ## THINGY, \
+	.read = konepure_sysfs_read_ ## thingy, \
+}
+
+#define KONEPURE_BIN_ATTRIBUTE_W(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = KONEPURE_SIZE_ ## THINGY, \
+	.write = konepure_sysfs_write_ ## thingy \
+}
+
+KONEPURE_SYSFS_RW(actual_profile, ACTUAL_PROFILE)
+KONEPURE_SYSFS_W(control, CONTROL)
+KONEPURE_SYSFS_RW(info, INFO)
+KONEPURE_SYSFS_W(talk, TALK)
+KONEPURE_SYSFS_W(macro, MACRO)
+KONEPURE_SYSFS_RW(sensor, SENSOR)
+KONEPURE_SYSFS_RW(tcu, TCU)
+KONEPURE_SYSFS_R(tcu_image, TCU_IMAGE)
+KONEPURE_SYSFS_RW(profile_settings, PROFILE_SETTINGS)
+KONEPURE_SYSFS_RW(profile_buttons, PROFILE_BUTTONS)
+
+static struct bin_attribute konepure_bin_attributes[] = {
+	KONEPURE_BIN_ATTRIBUTE_RW(actual_profile, ACTUAL_PROFILE),
+	KONEPURE_BIN_ATTRIBUTE_W(control, CONTROL),
+	KONEPURE_BIN_ATTRIBUTE_RW(info, INFO),
+	KONEPURE_BIN_ATTRIBUTE_W(talk, TALK),
+	KONEPURE_BIN_ATTRIBUTE_W(macro, MACRO),
+	KONEPURE_BIN_ATTRIBUTE_RW(sensor, SENSOR),
+	KONEPURE_BIN_ATTRIBUTE_RW(tcu, TCU),
+	KONEPURE_BIN_ATTRIBUTE_R(tcu_image, TCU_IMAGE),
+	KONEPURE_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS),
+	KONEPURE_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS),
+	__ATTR_NULL
+};
+
+static int konepure_init_konepure_device_struct(struct usb_device *usb_dev,
+		struct konepure_device *konepure)
+{
+	mutex_init(&konepure->konepure_lock);
+
+	return 0;
+}
+
+static int konepure_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct konepure_device *konepure;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE) {
+		hid_set_drvdata(hdev, NULL);
+		return 0;
+	}
+
+	konepure = kzalloc(sizeof(*konepure), GFP_KERNEL);
+	if (!konepure) {
+		hid_err(hdev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, konepure);
+
+	retval = konepure_init_konepure_device_struct(usb_dev, konepure);
+	if (retval) {
+		hid_err(hdev, "couldn't init struct konepure_device\n");
+		goto exit_free;
+	}
+
+	retval = roccat_connect(konepure_class, hdev,
+			sizeof(struct konepure_mouse_report_button));
+	if (retval < 0) {
+		hid_err(hdev, "couldn't init char dev\n");
+	} else {
+		konepure->chrdev_minor = retval;
+		konepure->roccat_claimed = 1;
+	}
+
+	return 0;
+exit_free:
+	kfree(konepure);
+	return retval;
+}
+
+static void konepure_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct konepure_device *konepure;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return;
+
+	konepure = hid_get_drvdata(hdev);
+	if (konepure->roccat_claimed)
+		roccat_disconnect(konepure->chrdev_minor);
+	kfree(konepure);
+}
+
+static int konepure_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	int retval;
+
+	retval = hid_parse(hdev);
+	if (retval) {
+		hid_err(hdev, "parse failed\n");
+		goto exit;
+	}
+
+	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (retval) {
+		hid_err(hdev, "hw start failed\n");
+		goto exit;
+	}
+
+	retval = konepure_init_specials(hdev);
+	if (retval) {
+		hid_err(hdev, "couldn't install mouse\n");
+		goto exit_stop;
+	}
+
+	return 0;
+
+exit_stop:
+	hid_hw_stop(hdev);
+exit:
+	return retval;
+}
+
+static void konepure_remove(struct hid_device *hdev)
+{
+	konepure_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static int konepure_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct konepure_device *konepure = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return 0;
+
+	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
+		return 0;
+
+	if (konepure != NULL && konepure->roccat_claimed)
+		roccat_report_event(konepure->chrdev_minor, data);
+
+	return 0;
+}
+
+static const struct hid_device_id konepure_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, konepure_devices);
+
+static struct hid_driver konepure_driver = {
+		.name = "konepure",
+		.id_table = konepure_devices,
+		.probe = konepure_probe,
+		.remove = konepure_remove,
+		.raw_event = konepure_raw_event
+};
+
+static int __init konepure_init(void)
+{
+	int retval;
+
+	konepure_class = class_create(THIS_MODULE, "konepure");
+	if (IS_ERR(konepure_class))
+		return PTR_ERR(konepure_class);
+	konepure_class->dev_bin_attrs = konepure_bin_attributes;
+
+	retval = hid_register_driver(&konepure_driver);
+	if (retval)
+		class_destroy(konepure_class);
+	return retval;
+}
+
+static void __exit konepure_exit(void)
+{
+	hid_unregister_driver(&konepure_driver);
+	class_destroy(konepure_class);
+}
+
+module_init(konepure_init);
+module_exit(konepure_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat KonePure driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-konepure.h b/drivers/hid/hid-roccat-konepure.h
new file mode 100644
index 0000000..2cd24e9
--- /dev/null
+++ b/drivers/hid/hid-roccat-konepure.h
@@ -0,0 +1,72 @@
+#ifndef __HID_ROCCAT_KONEPURE_H
+#define __HID_ROCCAT_KONEPURE_H
+
+/*
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/types.h>
+
+enum {
+	KONEPURE_SIZE_ACTUAL_PROFILE = 0x03,
+	KONEPURE_SIZE_CONTROL = 0x03,
+	KONEPURE_SIZE_FIRMWARE_WRITE = 0x0402,
+	KONEPURE_SIZE_INFO = 0x06,
+	KONEPURE_SIZE_MACRO = 0x0822,
+	KONEPURE_SIZE_PROFILE_SETTINGS = 0x1f,
+	KONEPURE_SIZE_PROFILE_BUTTONS = 0x3b,
+	KONEPURE_SIZE_SENSOR = 0x06,
+	KONEPURE_SIZE_TALK = 0x10,
+	KONEPURE_SIZE_TCU = 0x04,
+	KONEPURE_SIZE_TCU_IMAGE = 0x0404,
+};
+
+enum konepure_control_requests {
+	KONEPURE_CONTROL_REQUEST_GENERAL = 0x80,
+	KONEPURE_CONTROL_REQUEST_BUTTONS = 0x90,
+};
+
+enum konepure_commands {
+	KONEPURE_COMMAND_CONTROL = 0x04,
+	KONEPURE_COMMAND_ACTUAL_PROFILE = 0x05,
+	KONEPURE_COMMAND_PROFILE_SETTINGS = 0x06,
+	KONEPURE_COMMAND_PROFILE_BUTTONS = 0x07,
+	KONEPURE_COMMAND_MACRO = 0x08,
+	KONEPURE_COMMAND_INFO = 0x09,
+	KONEPURE_COMMAND_TCU = 0x0c,
+	KONEPURE_COMMAND_TCU_IMAGE = 0x0c,
+	KONEPURE_COMMAND_E = 0x0e,
+	KONEPURE_COMMAND_SENSOR = 0x0f,
+	KONEPURE_COMMAND_TALK = 0x10,
+	KONEPURE_COMMAND_FIRMWARE_WRITE = 0x1b,
+	KONEPURE_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
+};
+
+enum {
+	KONEPURE_MOUSE_REPORT_NUMBER_BUTTON = 3,
+};
+
+struct konepure_mouse_report_button {
+	uint8_t report_number; /* always KONEPURE_MOUSE_REPORT_NUMBER_BUTTON */
+	uint8_t zero;
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+	uint8_t zero2;
+	uint8_t unknown[2];
+} __packed;
+
+struct konepure_device {
+	int roccat_claimed;
+	int chrdev_minor;
+	struct mutex konepure_lock;
+};
+
+#endif
-- 
1.7.3.4



