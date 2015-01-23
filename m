Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbbAWOBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:01:25 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54598 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbAWOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:01:24 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: platform-driver-x86@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH v3 1/2] asus-laptop: use DEVICE_ATTR_xx macros
Date: Fri, 23 Jan 2015 09:01:10 -0500
Message-Id: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEVICE_ATTR_{RO,WO,RW} macros to simplify sysfs attributes
declaration.

To declare a "foo" attribute, DEVICE_ATTR_RW() requires foo_show() and
foo_store(), so rename a few functions to satisfy this requirement.

Also put the macro below each related show/store functions for clarity.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/platform/x86/asus-laptop.c | 95 ++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 00f5e82..46b2746 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -856,8 +856,8 @@ static void asus_backlight_exit(struct asus_laptop *asus)
  * than count bytes. We set eof to 1 if we handle those 2 values. We return the
  * number of bytes written in page
  */
-static ssize_t show_infos(struct device *dev,
-			  struct device_attribute *attr, char *page)
+static ssize_t infos_show(struct device *dev, struct device_attribute *attr,
+			  char *page)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int len = 0;
@@ -926,6 +926,7 @@ static ssize_t show_infos(struct device *dev,
 
 	return len;
 }
+static DEVICE_ATTR_RO(infos);
 
 static int parse_arg(const char *buf, unsigned long count, int *val)
 {
@@ -957,15 +958,15 @@ static ssize_t sysfs_acpi_set(struct asus_laptop *asus,
 /*
  * LEDD display
  */
-static ssize_t show_ledd(struct device *dev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t ledd_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "0x%08x\n", asus->ledd_status);
 }
 
-static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
+static ssize_t ledd_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
@@ -981,6 +982,7 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 	}
 	return rv;
 }
+static DEVICE_ATTR_RW(ledd);
 
 /*
  * Wireless
@@ -1014,21 +1016,22 @@ static int asus_wlan_set(struct asus_laptop *asus, int status)
 	return 0;
 }
 
-static ssize_t show_wlan(struct device *dev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t wlan_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus_wireless_status(asus, WL_RSTS));
 }
 
-static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
+static ssize_t wlan_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sysfs_acpi_set(asus, buf, count, METHOD_WLAN);
 }
+static DEVICE_ATTR_RW(wlan);
 
 /*e
  * Bluetooth
@@ -1042,15 +1045,15 @@ static int asus_bluetooth_set(struct asus_laptop *asus, int status)
 	return 0;
 }
 
-static ssize_t show_bluetooth(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t bluetooth_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus_wireless_status(asus, BT_RSTS));
 }
 
-static ssize_t store_bluetooth(struct device *dev,
+static ssize_t bluetooth_store(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
 			       size_t count)
 {
@@ -1058,6 +1061,7 @@ static ssize_t store_bluetooth(struct device *dev,
 
 	return sysfs_acpi_set(asus, buf, count, METHOD_BLUETOOTH);
 }
+static DEVICE_ATTR_RW(bluetooth);
 
 /*
  * Wimax
@@ -1071,22 +1075,22 @@ static int asus_wimax_set(struct asus_laptop *asus, int status)
 	return 0;
 }
 
-static ssize_t show_wimax(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t wimax_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus_wireless_status(asus, WM_RSTS));
 }
 
-static ssize_t store_wimax(struct device *dev,
-			       struct device_attribute *attr, const char *buf,
-			       size_t count)
+static ssize_t wimax_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sysfs_acpi_set(asus, buf, count, METHOD_WIMAX);
 }
+static DEVICE_ATTR_RW(wimax);
 
 /*
  * Wwan
@@ -1100,22 +1104,22 @@ static int asus_wwan_set(struct asus_laptop *asus, int status)
 	return 0;
 }
 
-static ssize_t show_wwan(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t wwan_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus_wireless_status(asus, WW_RSTS));
 }
 
-static ssize_t store_wwan(struct device *dev,
-			       struct device_attribute *attr, const char *buf,
-			       size_t count)
+static ssize_t wwan_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sysfs_acpi_set(asus, buf, count, METHOD_WWAN);
 }
+static DEVICE_ATTR_RW(wwan);
 
 /*
  * Display
@@ -1135,8 +1139,8 @@ static void asus_set_display(struct asus_laptop *asus, int value)
  * displays hooked up simultaneously, so be warned. See the acpi4asus README
  * for more info.
  */
-static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t count)
+static ssize_t display_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
@@ -1146,6 +1150,7 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
 		asus_set_display(asus, value);
 	return rv;
 }
+static DEVICE_ATTR_WO(display);
 
 /*
  * Light Sens
@@ -1167,16 +1172,17 @@ static void asus_als_switch(struct asus_laptop *asus, int value)
 	asus->light_switch = value;
 }
 
-static ssize_t show_lssw(struct device *dev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t ls_switch_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus->light_switch);
 }
 
-static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t count)
+static ssize_t ls_switch_store(struct device *dev,
+			       struct device_attribute *attr, const char *buf,
+			       size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
@@ -1187,6 +1193,7 @@ static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
 
 	return rv;
 }
+static DEVICE_ATTR_RW(ls_switch);
 
 static void asus_als_level(struct asus_laptop *asus, int value)
 {
@@ -1195,16 +1202,16 @@ static void asus_als_level(struct asus_laptop *asus, int value)
 	asus->light_level = value;
 }
 
-static ssize_t show_lslvl(struct device *dev,
-			  struct device_attribute *attr, char *buf)
+static ssize_t ls_level_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus->light_level);
 }
 
-static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
+static ssize_t ls_level_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
@@ -1218,6 +1225,7 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 
 	return rv;
 }
+static DEVICE_ATTR_RW(ls_level);
 
 static int pega_int_read(struct asus_laptop *asus, int arg, int *result)
 {
@@ -1234,8 +1242,8 @@ static int pega_int_read(struct asus_laptop *asus, int arg, int *result)
 	return err;
 }
 
-static ssize_t show_lsvalue(struct device *dev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t ls_value_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int err, hi, lo;
@@ -1247,6 +1255,7 @@ static ssize_t show_lsvalue(struct device *dev,
 		return sprintf(buf, "%d\n", 10 * hi + lo);
 	return err;
 }
+static DEVICE_ATTR_RO(ls_value);
 
 /*
  * GPS
@@ -1274,15 +1283,15 @@ static int asus_gps_switch(struct asus_laptop *asus, int status)
 	return 0;
 }
 
-static ssize_t show_gps(struct device *dev,
-			struct device_attribute *attr, char *buf)
+static ssize_t gps_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", asus_gps_status(asus));
 }
 
-static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
+static ssize_t gps_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
@@ -1298,6 +1307,7 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 	rfkill_set_sw_state(asus->gps.rfkill, !value);
 	return rv;
 }
+static DEVICE_ATTR_RW(gps);
 
 /*
  * rfkill
@@ -1569,19 +1579,6 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	asus_input_notify(asus, event);
 }
 
-static DEVICE_ATTR(infos, S_IRUGO, show_infos, NULL);
-static DEVICE_ATTR(wlan, S_IRUGO | S_IWUSR, show_wlan, store_wlan);
-static DEVICE_ATTR(bluetooth, S_IRUGO | S_IWUSR,
-		   show_bluetooth, store_bluetooth);
-static DEVICE_ATTR(wimax, S_IRUGO | S_IWUSR, show_wimax, store_wimax);
-static DEVICE_ATTR(wwan, S_IRUGO | S_IWUSR, show_wwan, store_wwan);
-static DEVICE_ATTR(display, S_IWUSR, NULL, store_disp);
-static DEVICE_ATTR(ledd, S_IRUGO | S_IWUSR, show_ledd, store_ledd);
-static DEVICE_ATTR(ls_value, S_IRUGO, show_lsvalue, NULL);
-static DEVICE_ATTR(ls_level, S_IRUGO | S_IWUSR, show_lslvl, store_lslvl);
-static DEVICE_ATTR(ls_switch, S_IRUGO | S_IWUSR, show_lssw, store_lssw);
-static DEVICE_ATTR(gps, S_IRUGO | S_IWUSR, show_gps, store_gps);
-
 static struct attribute *asus_attributes[] = {
 	&dev_attr_infos.attr,
 	&dev_attr_wlan.attr,
-- 
2.2.2

