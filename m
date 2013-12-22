Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3LVVRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:17:37 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54189 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3LVVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:17:35 -0500
From: Derek Perrin <d.roc16@gmail.com>
To: d.roc16@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: firmware: edd: fixed coding style errors
Date: Sun, 22 Dec 2013 15:17:19 -0600
Message-Id: <1387747039-14098-1-git-send-email-d.roc16@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors. Spaces, tab and parenthesis errors.

Signed-off-by: Derek Perrin <d.roc16@gmail.com>
---
 drivers/firmware/edd.c | 62 +++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..c3540d6 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -62,8 +62,8 @@ struct edd_device {
 
 struct edd_attribute {
 	struct attribute attr;
-	ssize_t(*show) (struct edd_device * edev, char *buf);
-	int (*test) (struct edd_device * edev);
+	ssize_t(*show) (struct edd_device *edev, char *buf);
+	int (*test) (struct edd_device *edev);
 };
 
 /* forward declarations */
@@ -72,7 +72,7 @@ static struct pci_dev *edd_get_pci_dev(struct edd_device *edev);
 
 static struct edd_device *edd_devices[EDD_MBR_SIG_MAX];
 
-#define EDD_DEVICE_ATTR(_name,_mode,_show,_test) \
+#define EDD_DEVICE_ATTR(_name, _mode, _show, _test) \
 struct edd_attribute edd_attr_##_name = { 	\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,				\
@@ -107,11 +107,11 @@ edd_dev_set_info(struct edd_device *edev, int i)
 		edev->info = &edd.edd_info[i];
 }
 
-#define to_edd_attr(_attr) container_of(_attr,struct edd_attribute,attr)
-#define to_edd_device(obj) container_of(obj,struct edd_device,kobj)
+#define to_edd_attr(_attr) container_of(_attr, struct edd_attribute, attr)
+#define to_edd_device(obj) container_of(obj, struct edd_device, kobj)
 
 static ssize_t
-edd_attr_show(struct kobject * kobj, struct attribute *attr, char *buf)
+edd_attr_show(struct kobject *kobj, struct attribute *attr, char *buf)
 {
 	struct edd_device *dev = to_edd_device(kobj);
 	struct edd_attribute *edd_attr = to_edd_attr(attr);
@@ -169,7 +169,7 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "\tunknown: %llx\n",
 			     info->params.interface_path.unknown.reserved);
 	}
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -228,7 +228,7 @@ edd_show_interface(struct edd_device *edev, char *buf)
 			     info->params.device_path.unknown.reserved2);
 	}
 
-	return (p - buf);
+	return p - buf;
 }
 
 /**
@@ -272,7 +272,7 @@ edd_show_version(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "0x%02x\n", info->version);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -280,7 +280,7 @@ edd_show_mbr_signature(struct edd_device *edev, char *buf)
 {
 	char *p = buf;
 	p += scnprintf(p, left, "0x%08x\n", edev->mbr_signature);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -306,7 +306,7 @@ edd_show_extensions(struct edd_device *edev, char *buf)
 	if (info->interface_support & EDD_EXT_64BIT_EXTENSIONS) {
 		p += scnprintf(p, left, "64-bit extensions\n");
 	}
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -336,7 +336,7 @@ edd_show_info_flags(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "no media present\n");
 	if (info->params.info_flags & EDD_INFO_USE_INT13_FN50)
 		p += scnprintf(p, left, "use int13 fn50\n");
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -351,7 +351,7 @@ edd_show_legacy_max_cylinder(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_cylinder);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -366,7 +366,7 @@ edd_show_legacy_max_head(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_head);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -381,7 +381,7 @@ edd_show_legacy_sectors_per_track(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_sectors_per_track);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -396,7 +396,7 @@ edd_show_default_cylinders(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_cylinders);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -411,7 +411,7 @@ edd_show_default_heads(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_heads);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -426,7 +426,7 @@ edd_show_default_sectors_per_track(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.sectors_per_track);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -441,7 +441,7 @@ edd_show_sectors(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%llu\n", info->params.number_of_sectors);
-	return (p - buf);
+	return p - buf;
 }
 
 
@@ -565,12 +565,12 @@ static EDD_DEVICE_ATTR(extensions, 0444, edd_show_extensions, edd_has_edd_info);
 static EDD_DEVICE_ATTR(info_flags, 0444, edd_show_info_flags, edd_has_edd_info);
 static EDD_DEVICE_ATTR(sectors, 0444, edd_show_sectors, edd_has_edd_info);
 static EDD_DEVICE_ATTR(legacy_max_cylinder, 0444,
-                       edd_show_legacy_max_cylinder,
+		       edd_show_legacy_max_cylinder,
 		       edd_has_legacy_max_cylinder);
 static EDD_DEVICE_ATTR(legacy_max_head, 0444, edd_show_legacy_max_head,
 		       edd_has_legacy_max_head);
 static EDD_DEVICE_ATTR(legacy_sectors_per_track, 0444,
-                       edd_show_legacy_sectors_per_track,
+		       edd_show_legacy_sectors_per_track,
 		       edd_has_legacy_sectors_per_track);
 static EDD_DEVICE_ATTR(default_cylinders, 0444, edd_show_default_cylinders,
 		       edd_has_default_cylinders);
@@ -587,12 +587,12 @@ static EDD_DEVICE_ATTR(mbr_signature, 0444, edd_show_mbr_signature, edd_has_mbr_
 /* These are default attributes that are added for every edd
  * device discovered.  There are none.
  */
-static struct attribute * def_attrs[] = {
+static struct attribute *def_attrs[] = {
 	NULL,
 };
 
 /* These attributes are conditional and only added for some devices. */
-static struct edd_attribute * edd_attrs[] = {
+static struct edd_attribute *edd_attrs[] = {
 	&edd_attr_raw_data,
 	&edd_attr_version,
 	&edd_attr_extensions,
@@ -619,9 +619,9 @@ static struct edd_attribute * edd_attrs[] = {
  *	but just in case, we use the release callback anyway.
  */
 
-static void edd_release(struct kobject * kobj)
+static void edd_release(struct kobject *kobj)
 {
-	struct edd_device * dev = to_edd_device(kobj);
+	struct edd_device *dev = to_edd_device(kobj);
 	kfree(dev);
 }
 
@@ -685,7 +685,7 @@ edd_create_symlink_to_pcidev(struct edd_device *edev)
 	int ret;
 	if (!pci_dev)
 		return 1;
-	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	ret = sysfs_create_link(&edev->kobj, &pci_dev->dev.kobj, "pci_dev");
 	pci_dev_put(pci_dev);
 	return ret;
 }
@@ -696,16 +696,16 @@ edd_device_unregister(struct edd_device *edev)
 	kobject_put(&edev->kobj);
 }
 
-static void edd_populate_dir(struct edd_device * edev)
+static void edd_populate_dir(struct edd_device *edev)
 {
-	struct edd_attribute * attr;
+	struct edd_attribute *attr;
 	int error = 0;
 	int i;
 
 	for (i = 0; (attr = edd_attrs[i]) && !error; i++) {
 		if (!attr->test ||
 		    (attr->test && attr->test(edev)))
-			error = sysfs_create_file(&edev->kobj,&attr->attr);
+			error = sysfs_create_file(&edev->kobj, &attr->attr);
 	}
 
 	if (!error) {
@@ -745,7 +745,7 @@ static int __init
 edd_init(void)
 {
 	int i;
-	int rc=0;
+	int rc = 0;
 	struct edd_device *edev;
 
 	printk(KERN_INFO "BIOS EDD facility v%s %s, %d devices found\n",
@@ -791,7 +791,7 @@ edd_exit(void)
 	struct edd_device *edev;
 
 	for (i = 0; i < edd_num_devices(); i++) {
-		if ((edev = edd_devices[i]))
+		if ((edev == edd_devices[i]))
 			edd_device_unregister(edev);
 	}
 	kset_unregister(edd_kset);
-- 
1.8.5.2

