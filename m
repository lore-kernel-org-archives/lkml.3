Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3JJVlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:41:44 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60021 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754904Ab3JJVll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:41 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 1/6] drivers: usb: core: {file,hub,sysfs,usb}.c: Whitespace fixes
Date: Thu, 10 Oct 2013 23:41:27 +0200
Message-Id: <1381441292-6145-2-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

including:

- removing of trailing whitespace
- removing spaces before array indexing (foo [] to foo[])
- reindention of a switch-case block
- spaces to tabs

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/file.c  |   6 +--
 drivers/usb/core/hub.c   | 111 +++++++++++++++++++++++------------------------
 drivers/usb/core/sysfs.c |   5 ++-
 drivers/usb/core/usb.c   |   2 +-
 4 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 7421888..903c7ef 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -8,7 +8,7 @@
  * (C) Copyright Deti Fliegl 1999 (new USB architecture)
  * (C) Copyright Randy Dunlap 2000
  * (C) Copyright David Brownell 2000-2001 (kernel hotplug, usb_device_id,
- 	more docs, etc)
+ *	more docs, etc)
  * (C) Copyright Yggdrasil Computing, Inc. 2000
  *     (usb_device_id matching changes by Adam J. Richter)
  * (C) Copyright Greg Kroah-Hartman 2002-2003
@@ -44,7 +44,7 @@ static int usb_open(struct inode * inode, struct file * file)
 	file->f_op = new_fops;
 	/* Curiouser and curiouser... NULL ->open() as "no device" ? */
 	if (file->f_op->open)
-		err = file->f_op->open(inode,file);
+		err = file->f_op->open(inode, file);
 	if (err) {
 		fops_put(file->f_op);
 		file->f_op = fops_get(old_fops);
@@ -166,7 +166,7 @@ int usb_register_dev(struct usb_interface *intf,
 	char *temp;
 
 #ifdef CONFIG_USB_DYNAMIC_MINORS
-	/* 
+	/*
 	 * We don't care what the device tries to start at, we want to start
 	 * at zero to pack the devices into the smallest available space with
 	 * no holes in the minor range.
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e6b682c..e5fdf4b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -120,7 +120,7 @@ static inline char *portspeed(struct usb_hub *hub, int portstatus)
 	if (hub_is_superspeed(hub->hdev))
 		return "5.0 Gb/s";
 	if (portstatus & USB_PORT_STAT_HIGH_SPEED)
-    		return "480 Mb/s";
+		return "480 Mb/s";
 	else if (portstatus & USB_PORT_STAT_LOW_SPEED)
 		return "1.5 Mb/s";
 	else
@@ -857,7 +857,7 @@ static int hub_hub_status(struct usb_hub *hub,
 				"%s failed (err = %d)\n", __func__, ret);
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
-		*change = le16_to_cpu(hub->status->hub.wHubChange); 
+		*change = le16_to_cpu(hub->status->hub.wHubChange);
 		ret = 0;
 	}
 	mutex_unlock(&hub->status_mutex);
@@ -956,7 +956,7 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
 	 */
 
 	set_bit(port1, hub->change_bits);
- 	kick_khubd(hub);
+	kick_khubd(hub);
 }
 
 /**
@@ -1361,7 +1361,7 @@ static int hub_configure(struct usb_hub *hub,
 	if ((wHubCharacteristics & HUB_CHAR_COMPOUND) &&
 			!(hub_is_superspeed(hdev))) {
 		int	i;
-		char	portstr [USB_MAXCHILDREN + 1];
+		char	portstr[USB_MAXCHILDREN + 1];
 
 		for (i = 0; i < hdev->maxchild; i++)
 			portstr[i] = hub->descriptor->u.hs.DeviceRemovable
@@ -1429,32 +1429,32 @@ static int hub_configure(struct usb_hub *hub,
 
 	/* Note 8 FS bit times == (8 bits / 12000000 bps) ~= 666ns */
 	switch (wHubCharacteristics & HUB_CHAR_TTTT) {
-		case HUB_TTTT_8_BITS:
-			if (hdev->descriptor.bDeviceProtocol != 0) {
-				hub->tt.think_time = 666;
-				dev_dbg(hub_dev, "TT requires at most %d "
-						"FS bit times (%d ns)\n",
-					8, hub->tt.think_time);
-			}
-			break;
-		case HUB_TTTT_16_BITS:
-			hub->tt.think_time = 666 * 2;
-			dev_dbg(hub_dev, "TT requires at most %d "
-					"FS bit times (%d ns)\n",
-				16, hub->tt.think_time);
-			break;
-		case HUB_TTTT_24_BITS:
-			hub->tt.think_time = 666 * 3;
-			dev_dbg(hub_dev, "TT requires at most %d "
-					"FS bit times (%d ns)\n",
-				24, hub->tt.think_time);
-			break;
-		case HUB_TTTT_32_BITS:
-			hub->tt.think_time = 666 * 4;
+	case HUB_TTTT_8_BITS:
+		if (hdev->descriptor.bDeviceProtocol != 0) {
+			hub->tt.think_time = 666;
 			dev_dbg(hub_dev, "TT requires at most %d "
 					"FS bit times (%d ns)\n",
-				32, hub->tt.think_time);
-			break;
+				8, hub->tt.think_time);
+		}
+		break;
+	case HUB_TTTT_16_BITS:
+		hub->tt.think_time = 666 * 2;
+		dev_dbg(hub_dev, "TT requires at most %d "
+				"FS bit times (%d ns)\n",
+			16, hub->tt.think_time);
+		break;
+	case HUB_TTTT_24_BITS:
+		hub->tt.think_time = 666 * 3;
+		dev_dbg(hub_dev, "TT requires at most %d "
+				"FS bit times (%d ns)\n",
+			24, hub->tt.think_time);
+		break;
+	case HUB_TTTT_32_BITS:
+		hub->tt.think_time = 666 * 4;
+		dev_dbg(hub_dev, "TT requires at most %d "
+				"FS bit times (%d ns)\n",
+			32, hub->tt.think_time);
+		break;
 	}
 
 	/* probe() zeroes hub->indicator[] */
@@ -1560,7 +1560,7 @@ static int hub_configure(struct usb_hub *hub,
 
 	/* maybe cycle the hub leds */
 	if (hub->has_indicators && blinkenlights)
-		hub->indicator [0] = INDICATOR_CYCLE;
+		hub->indicator[0] = INDICATOR_CYCLE;
 
 	for (i = 0; i < hdev->maxchild; i++) {
 		ret = usb_hub_create_port_device(hub, i + 1);
@@ -1978,7 +1978,7 @@ static void choose_devnum(struct usb_device *udev)
 		if (devnum >= 128)
 			devnum = find_next_zero_bit(bus->devmap.devicemap,
 						    128, 1);
-		bus->devnum_next = ( devnum >= 127 ? 1 : devnum + 1);
+		bus->devnum_next = (devnum >= 127 ? 1 : devnum + 1);
 	}
 	if (devnum < 128) {
 		set_bit(devnum, bus->devmap.devicemap);
@@ -2232,8 +2232,7 @@ static int usb_enumerate_device(struct usb_device *udev)
 		udev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
 		udev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
 		udev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	}
-	else {
+	} else {
 		/* read the standard strings and cache them if present */
 		udev->product = usb_cache_string(udev, udev->descriptor.iProduct);
 		udev->manufacturer = usb_cache_string(udev,
@@ -3108,8 +3107,8 @@ static int finish_port_resume(struct usb_device *udev)
  retry_reset_resume:
 		status = usb_reset_and_verify_device(udev);
 
- 	/* 10.5.4.5 says be sure devices in the tree are still there.
- 	 * For now let's assume the device didn't go crazy on resume,
+	/* 10.5.4.5 says be sure devices in the tree are still there.
+	 * For now let's assume the device didn't go crazy on resume,
 	 * and device drivers will know about any resume quirks.
 	 */
 	if (status == 0) {
@@ -3855,7 +3854,7 @@ EXPORT_SYMBOL_GPL(usb_enable_ltm);
  * Between connect detection and reset signaling there must be a delay
  * of 100ms at least for debounce and power-settling.  The corresponding
  * timer shall restart whenever the downstream port detects a disconnect.
- * 
+ *
  * Apparently there are some bluetooth and irda-dongles and a number of
  * low-speed devices for which this debounce period may last over a second.
  * Not covered by the spec - but easy to deal with.
@@ -4055,7 +4054,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
- 
+
 	/* Why interleave GET_DESCRIPTOR and SET_ADDRESS this way?
 	 * Because device hardware and firmware is sometimes buggy in
 	 * this area, and this is how Linux has done it for ages.
@@ -4130,11 +4129,11 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 #undef GET_DESCRIPTOR_BUFSIZE
 		}
 
- 		/*
- 		 * If device is WUSB, we already assigned an
- 		 * unauthorized address in the Connect Ack sequence;
- 		 * authorization will assign the final address.
- 		 */
+		/*
+		 * If device is WUSB, we already assigned an
+		 * unauthorized address in the Connect Ack sequence;
+		 * authorization will assign the final address.
+		 */
 		if (udev->wusb == 0) {
 			for (j = 0; j < SET_ADDRESS_TRIES; ++j) {
 				retval = hub_set_address(udev, devnum);
@@ -4163,7 +4162,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 			msleep(10);
 			if (USE_NEW_SCHEME(retry_counter) && !(hcd->driver->flags & HCD_USB3))
 				break;
-  		}
+		}
 
 		retval = usb_get_device_descriptor(udev, 8);
 		if (retval < 8) {
@@ -4219,7 +4218,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 		udev->ep0.desc.wMaxPacketSize = cpu_to_le16(i);
 		usb_ep0_reinit(udev);
 	}
-  
+
 	retval = usb_get_device_descriptor(udev, USB_DT_DEVICE_SIZE);
 	if (retval < (signed)sizeof(udev->descriptor)) {
 		if (retval != -ENODEV)
@@ -4316,7 +4315,7 @@ hub_power_remaining (struct usb_hub *hub)
 	}
 	if (remaining < 0) {
 		dev_warn(hub->intfdev, "%dmA over power budget!\n",
-			- remaining);
+			-remaining);
 		remaining = 0;
 	}
 	return remaining;
@@ -4427,7 +4426,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 			set_port_feature(hdev, port1, USB_PORT_FEAT_POWER);
 
 		if (portstatus & USB_PORT_STAT_ENABLE)
-  			goto done;
+			goto done;
 		return;
 	}
 	if (hub_is_superspeed(hub->hdev))
@@ -4450,7 +4449,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 		}
 
 		usb_set_device_state(udev, USB_STATE_POWERED);
- 		udev->bus_mA = hub->mA_per_port;
+		udev->bus_mA = hub->mA_per_port;
 		udev->level = hdev->level + 1;
 		udev->wusb = hub_is_wusb(hub);
 
@@ -4504,7 +4503,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 				goto loop_disable;
 			}
 		}
- 
+
 		/* check for devices running slower than they could */
 		if (le16_to_cpu(udev->descriptor.bcdUSB) >= 0x0200
 				&& udev->speed == USB_SPEED_FULL
@@ -4564,7 +4563,7 @@ loop:
 			dev_err(hub_dev, "unable to enumerate USB device on port %d\n",
 					port1);
 	}
- 
+
 done:
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent)
@@ -4729,7 +4728,7 @@ static void hub_events(void)
 				 * EM interference sometimes causes badly
 				 * shielded USB devices to be shutdown by
 				 * the hub, this hack enables them again.
-				 * Works at least with mouse driver. 
+				 * Works at least with mouse driver.
 				 */
 				if (!(portstatus & USB_PORT_STAT_ENABLE)
 				    && !connect_change
@@ -4841,7 +4840,7 @@ static void hub_events(void)
 				dev_dbg(hub_dev, "over-current change\n");
 				clear_hub_feature(hdev, C_HUB_OVER_CURRENT);
 				msleep(500);	/* Cool down */
-                        	hub_power_on(hub, true);
+				hub_power_on(hub, true);
 				hub_hub_status(hub, &status, &unused);
 				if (status & HUB_STATUS_OVERCURRENT)
 					dev_err(hub_dev, "over-current "
@@ -4861,7 +4860,7 @@ static void hub_events(void)
 		usb_unlock_device(hdev);
 		kref_put(&hub->kref, hub_release);
 
-        } /* end while (1) */
+	} /* end while (1) */
 }
 
 static int hub_thread(void *__unused)
@@ -4886,7 +4885,7 @@ static int hub_thread(void *__unused)
 
 static const struct usb_device_id hub_id_table[] = {
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
-	           | USB_DEVICE_ID_MATCH_INT_CLASS,
+			| USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_CHECK_PORT_AUTOSUSPEND},
@@ -5120,13 +5119,13 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 
 	if (ret < 0)
 		goto re_enumerate;
- 
+
 	/* Device might have changed firmware (DFU or similar) */
 	if (descriptors_changed(udev, &descriptor, bos)) {
 		dev_info(&udev->dev, "device firmware changed\n");
 		udev->descriptor = descriptor;	/* for disconnect() calls */
 		goto re_enumerate;
-  	}
+	}
 
 	/* Restore the device's previous configuration */
 	if (!udev->actconfig)
@@ -5151,7 +5150,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 			udev->actconfig->desc.bConfigurationValue, ret);
 		mutex_unlock(hcd->bandwidth_mutex);
 		goto re_enumerate;
-  	}
+	}
 	mutex_unlock(hcd->bandwidth_mutex);
 	usb_set_device_state(udev, USB_STATE_CONFIGURED);
 
@@ -5198,7 +5197,7 @@ done:
 	usb_release_bos_descriptor(udev);
 	udev->bos = bos;
 	return 0;
- 
+
 re_enumerate:
 	/* LPM state doesn't matter when we're about to destroy the device. */
 	hub_port_logical_disconnect(parent_hub, port1);
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6d2c8ed..da74740 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -390,7 +390,8 @@ static DEVICE_ATTR_RW(autosuspend);
 static const char on_string[] = "on";
 static const char auto_string[] = "auto";
 
-static void warn_level(void) {
+static void warn_level(void)
+{
 	static int level_warned;
 
 	if (!level_warned) {
@@ -644,7 +645,7 @@ static ssize_t authorized_store(struct device *dev,
 		result = usb_deauthorize_device(usb_dev);
 	else
 		result = usb_authorize_device(usb_dev);
-	return result < 0? result : size;
+	return result < 0 ? result : size;
 }
 static DEVICE_ATTR_IGNORE_LOCKDEP(authorized, S_IRUGO | S_IWUSR,
 				  authorized_show, authorized_store);
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 0a6ee2e..4d11449 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -497,7 +497,7 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 		dev->authorized = 1;
 	else {
 		dev->authorized = usb_hcd->authorized_default;
-		dev->wusb = usb_bus_is_wusb(bus)? 1 : 0;
+		dev->wusb = usb_bus_is_wusb(bus) ? 1 : 0;
 	}
 	return dev;
 }
-- 
1.8.4

