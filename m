Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaDNLte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:49:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30029 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaDNLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:49:23 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-e8-534bcb418fcc
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 09/13] extcon: extcon-class: move example to Documentation
Date: Mon, 14 Apr 2014 13:46:20 +0200
Message-id: <1397475984-28001-10-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV2n097BBsf6+SzWvHCwOLhV0+Lg
	/XqL61+es1pMevKe2WL+kXOsFhNXTma26H+zkNWif4uLxYE/OxgtmhevZ7M492olo0Xn2SfM
	Fhee9rBZLN23msViYdsSFovLu+awWcxe0s9isWhZK7PFk4VnmCzWHrnLbrH0+kUmi9uNK9gs
	lr/9z2YxYfpaFosHh3eyW6x7OZ3FonXvEXaLfRf+sFqsn/GaxUHOY828NYwel/t6mTx27ZzD
	6jGh/xOjx85Zd9k9Vi7/wuZx+OtCFo/NK7Q8Nq3qZPN4tXomq8eda3vYPPbPXcPu0dv8js3j
	5cTfbB47vzewe/RtWcUYIBzFZZOSmpNZllqkb5fAlfF1AkfBPOuKSx8PsDQwfjLoYuTkkBAw
	kfg+rY0RwhaTuHBvPVsXIxeHkMAiRokzT1ZCOe1MEgf/7GQBqWIT0JHY8n0CWIeIALPEgqnn
	wWxmgaesEtt/2ILYwgK+Euc2L2AGsVkEVCXO7bwKZvMKuElM29cKNIcDaJuCxJxJNiBhTqDw
	wZl/wUqEBFwlDjTfZp7AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnB8PpPawbiy
	weIQowAHoxIPb8cc72Ah1sSy4srcQ4wSHMxKIryuW4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGGcubOR7Yd4uL6vkcLrsqLCQiNcstfC2/SlPa1Ri
	558P7H4/XSgs9IbEs7LE8o+fTUov8n05evXmnzO6TH2WWyXSz3Pu3MW6VDx7fdeeGdEPsnrF
	glhDoq46fn/P2WKibrPK6LvutLNNpYJKPH3tM21vXJiaJMVzeDNL5poTU3qt6sqKjmzcpMRS
	nJFoqMVcVJwIAJVIvk/LAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes cable array example form extcon code, to avoid
littering driver namespace. Now it's located in extcon documentation.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 Documentation/extcon/extcon.txt |  112 +++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-class.c   |   32 -----------
 include/linux/extcon.h          |   42 ---------------
 3 files changed, 112 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/extcon/extcon.txt

diff --git a/Documentation/extcon/extcon.txt b/Documentation/extcon/extcon.txt
new file mode 100644
index 0000000..1d5be2f
--- /dev/null
+++ b/Documentation/extcon/extcon.txt
@@ -0,0 +1,112 @@
+Extcon - external connector
+===========================
+
+Extcon is generic framework used for notifying client drivers
+about specific cable connections and disconnections.
+
+Provider API
+============
+
+Providers API consists of very few functions:
+
+extcon_dev_register() - register new extcon provider
+extcon_dev_unregister() - unregister extcon provider
+
+extcon_get_cable_state_() - get specific cable state
+extcon_set_cable_state_() - set specific cable state
+
+extcon_update_state() - update entire extcon state
+extcon_set_state() - set entire extcon state
+
+There are few fields in struct extcon_dev to be filled before passing it
+to extcon_dev_register() functions:
+
+name - name of extcon controller
+node - devicetree node of parent device
+supported_cable - array of strings with cable names ended with NULL pointer
+
+Example of cable array definition example can be found below:
+
+	enum extcon_cable_name {
+		EXTCON_USB = 0,
+		EXTCON_USB_HOST,
+		EXTCON_TA,
+		EXTCON_FAST_CHARGER,
+		EXTCON_SLOW_CHARGER,
+		EXTCON_CHARGE_DOWNSTREAM,
+		EXTCON_HDMI,
+		EXTCON_MHL,
+		EXTCON_DVI,
+		EXTCON_VGA,
+		EXTCON_DOCK,
+		EXTCON_LINE_IN,
+		EXTCON_LINE_OUT,
+		EXTCON_MIC_IN,
+		EXTCON_HEADPHONE_OUT,
+		EXTCON_SPDIF_IN,
+		EXTCON_SPDIF_OUT,
+		EXTCON_VIDEO_IN,
+		EXTCON_VIDEO_OUT,
+		EXTCON_MECHANICAL,
+	};
+
+	const char *extcon_cable_name[] = {
+		[EXTCON_USB]		= "USB",
+		[EXTCON_USB_HOST]	= "USB-Host",
+		[EXTCON_TA]		= "TA",
+		[EXTCON_FAST_CHARGER]	= "Fast-charger",
+		[EXTCON_SLOW_CHARGER]	= "Slow-charger",
+		[EXTCON_CHARGE_DOWNSTREAM]	= "Charge-downstream",
+		[EXTCON_HDMI]		= "HDMI",
+		[EXTCON_MHL]		= "MHL",
+		[EXTCON_DVI]		= "DVI",
+		[EXTCON_VGA]		= "VGA",
+		[EXTCON_DOCK]		= "Dock",
+		[EXTCON_LINE_IN]	= "Line-in",
+		[EXTCON_LINE_OUT]	= "Line-out",
+		[EXTCON_MIC_IN]		= "Microphone",
+		[EXTCON_HEADPHONE_OUT]	= "Headphone",
+		[EXTCON_SPDIF_IN]	= "SPDIF-in",
+		[EXTCON_SPDIF_OUT]	= "SPDIF-out",
+		[EXTCON_VIDEO_IN]	= "Video-in",
+		[EXTCON_VIDEO_OUT]	= "Video-out",
+		[EXTCON_MECHANICAL]	= "Mechanical",
+	};
+
+Cable name strings are used for debug messages and sysfs.
+
+After extcon device registration you can use functions modifying extcon state.
+If any extcon clients will register their interests in some cables, they will
+recieve notifications about cable state changes.
+
+Client API
+==========
+
+Extcon client API is also pretty simple. It consists of funtions:
+
+of_extcon_get_cable_by_index() - returns extcon_cable at selected index
+of_extcon_get_cable() - returns extcon_cable associated with
+			selected name
+extcon_get_cable() - the same as above, but takes struct device
+		     instead of struct device_node
+extcon_det_cable_by_name() - return specified cable form extcon device
+			     found by name. It's for use in drivers without
+			     devicetree support, and shouldn't be used in
+			     new drivers.
+
+extcon_register_interest() - register interest in selected cable
+extcon_unregister_interest() - unregister cable interest
+
+extcon_get_cable_state() - get state of given cable
+
+The extcon_register_interest() function takes three parameters,
+struct extcon_cable, struct extcon_cable_nb and extcon_notifier_fn_t
+which is pointer to callback function called when cable state changes.
+
+There are also two functions:
+
+extcon_register_notifier() - register notifier for entire extcon state
+extcon_unregister_notifier() - unregister such notifier
+
+But they should be used only for debug, and use of them in client drivers
+is not recommended.
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 13993c6..2ef86c1 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -33,38 +33,6 @@
 #include <linux/sysfs.h>
 #include <linux/of.h>
 
-/*
- * extcon_cable_name suggests the standard cable names for commonly used
- * cable types.
- *
- * However, please do not use extcon_cable_name directly for extcon_dev
- * struct's supported_cable pointer unless your device really supports
- * every single port-type of the following cable names. Please choose cable
- * names that are actually used in your extcon device.
- */
-const char extcon_cable_name[][CABLE_NAME_MAX + 1] = {
-	[EXTCON_USB]		= "USB",
-	[EXTCON_USB_HOST]	= "USB-Host",
-	[EXTCON_TA]		= "TA",
-	[EXTCON_FAST_CHARGER]	= "Fast-charger",
-	[EXTCON_SLOW_CHARGER]	= "Slow-charger",
-	[EXTCON_CHARGE_DOWNSTREAM]	= "Charge-downstream",
-	[EXTCON_HDMI]		= "HDMI",
-	[EXTCON_MHL]		= "MHL",
-	[EXTCON_DVI]		= "DVI",
-	[EXTCON_VGA]		= "VGA",
-	[EXTCON_DOCK]		= "Dock",
-	[EXTCON_LINE_IN]	= "Line-in",
-	[EXTCON_LINE_OUT]	= "Line-out",
-	[EXTCON_MIC_IN]		= "Microphone",
-	[EXTCON_HEADPHONE_OUT]	= "Headphone",
-	[EXTCON_SPDIF_IN]	= "SPDIF-in",
-	[EXTCON_SPDIF_OUT]	= "SPDIF-out",
-	[EXTCON_VIDEO_IN]	= "Video-in",
-	[EXTCON_VIDEO_OUT]	= "Video-out",
-	[EXTCON_MECHANICAL]	= "Mechanical",
-};
-
 static struct class *extcon_class;
 #if defined(CONFIG_ANDROID)
 static struct class_compat *switch_class;
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 8792ca2..572e53a 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -31,48 +31,6 @@
 #define SUPPORTED_CABLE_MAX	32
 #define CABLE_NAME_MAX		30
 
-/*
- * The standard cable name is to help support general notifier
- * and notifiee device drivers to share the common names.
- * Please use standard cable names unless your notifier device has
- * a very unique and abnormal cable or
- * the cable type is supposed to be used with only one unique
- * pair of notifier/notifiee devices.
- *
- * Please add any other "standard" cables used with extcon dev.
- *
- * You may add a dot and number to specify version or specification
- * of the specific cable if it is required. (e.g., "Fast-charger.18"
- * and "Fast-charger.10" for 1.8A and 1.0A chargers)
- * However, the notifiee and notifier should be able to handle such
- * string and if the notifiee can negotiate the protocol or identify,
- * you don't need such convention. This convention is helpful when
- * notifier can distinguish but notifiee cannot.
- */
-enum extcon_cable_name {
-	EXTCON_USB = 0,
-	EXTCON_USB_HOST,
-	EXTCON_TA,			/* Travel Adaptor */
-	EXTCON_FAST_CHARGER,
-	EXTCON_SLOW_CHARGER,
-	EXTCON_CHARGE_DOWNSTREAM,	/* Charging an external device */
-	EXTCON_HDMI,
-	EXTCON_MHL,
-	EXTCON_DVI,
-	EXTCON_VGA,
-	EXTCON_DOCK,
-	EXTCON_LINE_IN,
-	EXTCON_LINE_OUT,
-	EXTCON_MIC_IN,
-	EXTCON_HEADPHONE_OUT,
-	EXTCON_SPDIF_IN,
-	EXTCON_SPDIF_OUT,
-	EXTCON_VIDEO_IN,
-	EXTCON_VIDEO_OUT,
-	EXTCON_MECHANICAL,
-};
-extern const char extcon_cable_name[][CABLE_NAME_MAX + 1];
-
 struct extcon_cable;
 
 /**
-- 
1.7.9.5

