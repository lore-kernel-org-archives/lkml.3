Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3J1RwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:52:15 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:37214 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab3J1RwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:52:11 -0400
X-Greylist: Passed host: 88.66.243.220
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net DD5361AB536
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
Subject: [PATCH 3/3] HID: roccat: Added support for Ryos MK keyboards
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Oct 2013 18:52:07 +0100
Message-ID: <1382982727.2453.11.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for 3 keyboards with increasing illumination capabilities

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-ryos       |  178 +++++++++++++++
 drivers/hid/Makefile                               |    2 +-
 drivers/hid/hid-core.c                             |    3 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-roccat-ryos.c                      |  241 ++++++++++++++++++++
 5 files changed, 426 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
 create mode 100644 drivers/hid/hid-roccat-ryos.c

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos b/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
new file mode 100644
index 0000000..1d6a8cf
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
@@ -0,0 +1,178 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/control
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one select which data from which
+		profile will be	read next. The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/profile
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. profile holds index of actual profile.
+		This value is persistent, so its value determines the profile
+		that's active when the device is powered on next time.
+		When written, the device activates the set profile immediately.
+		The data has to be 3 bytes long.
+		The device will reject invalid data.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_primary
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the default of all keys for
+		a specific profile. Profile index is included in written data.
+		The data has to be 125 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_function
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		function keys for a specific profile. Profile index is included
+		in written data. The data has to be 95 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the macro
+		keys for a specific profile. Profile index is included in
+		written data. The data has to be 35 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_thumbster
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		thumbster keys for a specific profile. Profile index is included
+		in written data. The data has to be 23 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_extra
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		capslock and function keys for a specific profile. Profile index
+		is included in written data. The data has to be 8 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/keys_easyzone
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the function of the
+		easyzone keys for a specific profile. Profile index is included
+		in written data. The data has to be 294 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/key_mask
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one deactivate certain keys like
+		windows and application keys, to prevent accidental presses.
+		Profile index for which this settings occur is included in
+		written data. The data has to be 6 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the backlight intensity for
+		a specific profile. Profile index is included in written data.
+		This attribute is only valid for the glow and pro variant.
+		The data has to be 16 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one store macros with max 480
+		keystrokes for a specific button for a specific profile.
+		Button and profile indexes are included in written data.
+		The data has to be 2002 bytes long.
+		Before reading this file, control has to be written to select
+		which profile and key to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/info
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns general data like firmware version.
+		The data is 8 bytes long.
+		This file is readonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/reset
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one reset the device.
+		The data has to be 3 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/talk
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger easyshift functionality
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_control
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one switch between stored and custom
+		light settings.
+		This attribute is only valid for the pro variant.
+		The data has to be 8 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/stored_lights
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set per-key lighting for different
+		layers.
+		This attribute is only valid for the pro variant.
+		The data has to be 1382 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/custom_lights
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set the actual per-key lighting.
+		This attribute is only valid for the pro variant.
+		The data has to be 20 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/ryos/roccatryos<minor>/light_macro
+Date:		October 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one set a light macro that is looped
+		whenever the device gets in dimness mode.
+		This attribute is only valid for the pro variant.
+		The data has to be 2002 bytes long.
+		Before reading this file, control has to be written to select
+		which profile to read.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index a959f4a..30e4431 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -95,7 +95,7 @@ obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o hid-roccat-common.o \
 	hid-roccat-arvo.o hid-roccat-isku.o hid-roccat-kone.o \
 	hid-roccat-koneplus.o hid-roccat-konepure.o hid-roccat-kovaplus.o \
-	hid-roccat-lua.o hid-roccat-pyra.o hid-roccat-savu.o
+	hid-roccat-lua.o hid-roccat-pyra.o hid-roccat-ryos.o hid-roccat-savu.o
 obj-$(CONFIG_HID_SAITEK)	+= hid-saitek.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e80da62..0079422 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1811,6 +1811,9 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_LUA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK_GLOW) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK_PRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f0296a5..768fafc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -726,6 +726,9 @@
 #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
+#define USB_DEVICE_ID_ROCCAT_RYOS_MK	0x3138
+#define USB_DEVICE_ID_ROCCAT_RYOS_MK_GLOW	0x31ce
+#define USB_DEVICE_ID_ROCCAT_RYOS_MK_PRO	0x3232
 #define USB_DEVICE_ID_ROCCAT_SAVU	0x2d5a
 
 #define USB_VENDOR_ID_SAITEK		0x06a3
diff --git a/drivers/hid/hid-roccat-ryos.c b/drivers/hid/hid-roccat-ryos.c
new file mode 100644
index 0000000..47cc8f3
--- /dev/null
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -0,0 +1,241 @@
+/*
+ * Roccat Ryos driver for Linux
+ *
+ * Copyright (c) 2013 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/hid-roccat.h>
+#include "hid-ids.h"
+#include "hid-roccat-common.h"
+
+enum {
+	RYOS_REPORT_NUMBER_SPECIAL = 3,
+	RYOS_USB_INTERFACE_PROTOCOL = 0,
+};
+
+struct ryos_report_special {
+	uint8_t number; /* RYOS_REPORT_NUMBER_SPECIAL */
+	uint8_t data[4];
+} __packed;
+
+static struct class *ryos_class;
+
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(control, 0x04, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(profile, 0x05, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_primary, 0x06, 0x7d);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_function, 0x07, 0x5f);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_macro, 0x08, 0x23);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_thumbster, 0x09, 0x17);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_extra, 0x0a, 0x08);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(keys_easyzone, 0x0b, 0x126);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(key_mask, 0x0c, 0x06);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(light, 0x0d, 0x10);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(macro, 0x0e, 0x7d2);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_R(info, 0x0f, 0x08);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(reset, 0x11, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(light_control, 0x13, 0x08);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(talk, 0x16, 0x10);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(stored_lights, 0x17, 0x0566);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(custom_lights, 0x18, 0x14);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(light_macro, 0x19, 0x07d2);
+
+static struct bin_attribute *ryos_bin_attrs[] = {
+	&bin_attr_control,
+	&bin_attr_profile,
+	&bin_attr_keys_primary,
+	&bin_attr_keys_function,
+	&bin_attr_keys_macro,
+	&bin_attr_keys_thumbster,
+	&bin_attr_keys_extra,
+	&bin_attr_keys_easyzone,
+	&bin_attr_key_mask,
+	&bin_attr_light,
+	&bin_attr_macro,
+	&bin_attr_info,
+	&bin_attr_reset,
+	&bin_attr_light_control,
+	&bin_attr_talk,
+	&bin_attr_stored_lights,
+	&bin_attr_custom_lights,
+	&bin_attr_light_macro,
+	NULL,
+};
+
+static const struct attribute_group ryos_group = {
+	.bin_attrs = ryos_bin_attrs,
+};
+
+static const struct attribute_group *ryos_groups[] = {
+	&ryos_group,
+	NULL,
+};
+
+static int ryos_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct roccat_common2_device *ryos;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= RYOS_USB_INTERFACE_PROTOCOL) {
+		hid_set_drvdata(hdev, NULL);
+		return 0;
+	}
+
+	ryos = kzalloc(sizeof(*ryos), GFP_KERNEL);
+	if (!ryos) {
+		hid_err(hdev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, ryos);
+
+	retval = roccat_common2_device_init_struct(usb_dev, ryos);
+	if (retval) {
+		hid_err(hdev, "couldn't init Ryos device\n");
+		goto exit_free;
+	}
+
+	retval = roccat_connect(ryos_class, hdev,
+			sizeof(struct ryos_report_special));
+	if (retval < 0) {
+		hid_err(hdev, "couldn't init char dev\n");
+	} else {
+		ryos->chrdev_minor = retval;
+		ryos->roccat_claimed = 1;
+	}
+
+	return 0;
+exit_free:
+	kfree(ryos);
+	return retval;
+}
+
+static void ryos_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct roccat_common2_device *ryos;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= RYOS_USB_INTERFACE_PROTOCOL)
+		return;
+
+	ryos = hid_get_drvdata(hdev);
+	if (ryos->roccat_claimed)
+		roccat_disconnect(ryos->chrdev_minor);
+	kfree(ryos);
+}
+
+static int ryos_probe(struct hid_device *hdev,
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
+	retval = ryos_init_specials(hdev);
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
+static void ryos_remove(struct hid_device *hdev)
+{
+	ryos_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static int ryos_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct roccat_common2_device *ryos = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= RYOS_USB_INTERFACE_PROTOCOL)
+		return 0;
+
+	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
+		return 0;
+
+	if (ryos != NULL && ryos->roccat_claimed)
+		roccat_report_event(ryos->chrdev_minor, data);
+
+	return 0;
+}
+
+static const struct hid_device_id ryos_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK_GLOW) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK_PRO) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, ryos_devices);
+
+static struct hid_driver ryos_driver = {
+		.name = "ryos",
+		.id_table = ryos_devices,
+		.probe = ryos_probe,
+		.remove = ryos_remove,
+		.raw_event = ryos_raw_event
+};
+
+static int __init ryos_init(void)
+{
+	int retval;
+
+	ryos_class = class_create(THIS_MODULE, "ryos");
+	if (IS_ERR(ryos_class))
+		return PTR_ERR(ryos_class);
+	ryos_class->dev_groups = ryos_groups;
+
+	retval = hid_register_driver(&ryos_driver);
+	if (retval)
+		class_destroy(ryos_class);
+	return retval;
+}
+
+static void __exit ryos_exit(void)
+{
+	hid_unregister_driver(&ryos_driver);
+	class_destroy(ryos_class);
+}
+
+module_init(ryos_init);
+module_exit(ryos_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Ryos MK/Glow/Pro driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.3.4



