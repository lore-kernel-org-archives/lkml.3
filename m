Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LZUo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:44:58 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62538 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3LZUo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:44:56 -0500
From: Derek Perrin <d.roc16@gmail.com>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, Derek Perrin <d.roc16@gmail.com>
Subject: [PATCH v3] drivers: firmware: edd: Fixed coding style errors
Date: Thu, 26 Dec 2013 14:38:16 -0600
Message-Id: <1388090296-4890-1-git-send-email-d.roc16@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1387950721.2259.63.camel@joe-AO722>
References: <1387950721.2259.63.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors. Fixed spacing, tab and parenthesis errors.

Signed-off-by: Derek Perrin <d.roc16@gmail.com>
---
Changes since v2:
*cleaned up more checkpatch.pl warnings
*fixed spacing after return type of function pointer as per Joe Perches
 drivers/firmware/edd.c | 97 +++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 52 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..dae0e7c 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -62,8 +62,8 @@ struct edd_device {
 
 struct edd_attribute {
 	struct attribute attr;
-	ssize_t(*show) (struct edd_device * edev, char *buf);
-	int (*test) (struct edd_device * edev);
+	ssize_t (*show)(struct edd_device *edev, char *buf);
+	int (*test)(struct edd_device *edev);
 };
 
 /* forward declarations */
@@ -72,8 +72,8 @@ static struct pci_dev *edd_get_pci_dev(struct edd_device *edev);
 
 static struct edd_device *edd_devices[EDD_MBR_SIG_MAX];
 
-#define EDD_DEVICE_ATTR(_name,_mode,_show,_test) \
-struct edd_attribute edd_attr_##_name = { 	\
+#define EDD_DEVICE_ATTR(_name, _mode, _show, _test) \
+struct edd_attribute edd_attr_##_name = {	\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,				\
 	.test	= _test,				\
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
@@ -140,11 +140,10 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	for (i = 0; i < 4; i++) {
-		if (isprint(info->params.host_bus_type[i])) {
+		if (isprint(info->params.host_bus_type[i]))
 			p += scnprintf(p, left, "%c", info->params.host_bus_type[i]);
-		} else {
+		else
 			p += scnprintf(p, left, " ");
-		}
 	}
 
 	if (!strncmp(info->params.host_bus_type, "ISA", 3)) {
@@ -169,7 +168,7 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "\tunknown: %llx\n",
 			     info->params.interface_path.unknown.reserved);
 	}
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -186,11 +185,10 @@ edd_show_interface(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	for (i = 0; i < 8; i++) {
-		if (isprint(info->params.interface_type[i])) {
+		if (isprint(info->params.interface_type[i]))
 			p += scnprintf(p, left, "%c", info->params.interface_type[i]);
-		} else {
+		else
 			p += scnprintf(p, left, " ");
-		}
 	}
 	if (!strncmp(info->params.interface_type, "ATAPI", 5)) {
 		p += scnprintf(p, left, "\tdevice: %u  lun: %u\n",
@@ -228,7 +226,7 @@ edd_show_interface(struct edd_device *edev, char *buf)
 			     info->params.device_path.unknown.reserved2);
 	}
 
-	return (p - buf);
+	return p - buf;
 }
 
 /**
@@ -242,7 +240,7 @@ static ssize_t
 edd_show_raw_data(struct edd_device *edev, char *buf)
 {
 	struct edd_info *info;
-	ssize_t len = sizeof (info->params);
+	ssize_t len = sizeof(info->params);
 	if (!edev)
 		return -EINVAL;
 	info = edd_dev_get_info(edev);
@@ -272,7 +270,7 @@ edd_show_version(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "0x%02x\n", info->version);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -280,7 +278,7 @@ edd_show_mbr_signature(struct edd_device *edev, char *buf)
 {
 	char *p = buf;
 	p += scnprintf(p, left, "0x%08x\n", edev->mbr_signature);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -294,19 +292,15 @@ edd_show_extensions(struct edd_device *edev, char *buf)
 	if (!info || !buf)
 		return -EINVAL;
 
-	if (info->interface_support & EDD_EXT_FIXED_DISK_ACCESS) {
+	if (info->interface_support & EDD_EXT_FIXED_DISK_ACCESS)
 		p += scnprintf(p, left, "Fixed disk access\n");
-	}
-	if (info->interface_support & EDD_EXT_DEVICE_LOCKING_AND_EJECTING) {
+	if (info->interface_support & EDD_EXT_DEVICE_LOCKING_AND_EJECTING)
 		p += scnprintf(p, left, "Device locking and ejecting\n");
-	}
-	if (info->interface_support & EDD_EXT_ENHANCED_DISK_DRIVE_SUPPORT) {
+	if (info->interface_support & EDD_EXT_ENHANCED_DISK_DRIVE_SUPPORT)
 		p += scnprintf(p, left, "Enhanced Disk Drive support\n");
-	}
-	if (info->interface_support & EDD_EXT_64BIT_EXTENSIONS) {
+	if (info->interface_support & EDD_EXT_64BIT_EXTENSIONS)
 		p += scnprintf(p, left, "64-bit extensions\n");
-	}
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -336,7 +330,7 @@ edd_show_info_flags(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "no media present\n");
 	if (info->params.info_flags & EDD_INFO_USE_INT13_FN50)
 		p += scnprintf(p, left, "use int13 fn50\n");
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -351,7 +345,7 @@ edd_show_legacy_max_cylinder(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_cylinder);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -366,7 +360,7 @@ edd_show_legacy_max_head(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_head);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -381,7 +375,7 @@ edd_show_legacy_sectors_per_track(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_sectors_per_track);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -396,7 +390,7 @@ edd_show_default_cylinders(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_cylinders);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -411,7 +405,7 @@ edd_show_default_heads(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_heads);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -426,7 +420,7 @@ edd_show_default_sectors_per_track(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.sectors_per_track);
-	return (p - buf);
+	return p - buf;
 }
 
 static ssize_t
@@ -441,7 +435,7 @@ edd_show_sectors(struct edd_device *edev, char *buf)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%llu\n", info->params.number_of_sectors);
-	return (p - buf);
+	return p - buf;
 }
 
 
@@ -540,9 +534,8 @@ edd_has_edd30(struct edd_device *edev)
 	if (!info)
 		return 0;
 
-	if (!(info->params.key == 0xBEDD || info->params.key == 0xDDBE)) {
+	if (!(info->params.key == 0xBEDD || info->params.key == 0xDDBE))
 		return 0;
-	}
 
 
 	/* We support only T13 spec */
@@ -565,12 +558,12 @@ static EDD_DEVICE_ATTR(extensions, 0444, edd_show_extensions, edd_has_edd_info);
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
@@ -587,12 +580,12 @@ static EDD_DEVICE_ATTR(mbr_signature, 0444, edd_show_mbr_signature, edd_has_mbr_
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
@@ -619,9 +612,9 @@ static struct edd_attribute * edd_attrs[] = {
  *	but just in case, we use the release callback anyway.
  */
 
-static void edd_release(struct kobject * kobj)
+static void edd_release(struct kobject *kobj)
 {
-	struct edd_device * dev = to_edd_device(kobj);
+	struct edd_device *dev = to_edd_device(kobj);
 	kfree(dev);
 }
 
@@ -685,7 +678,7 @@ edd_create_symlink_to_pcidev(struct edd_device *edev)
 	int ret;
 	if (!pci_dev)
 		return 1;
-	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	ret = sysfs_create_link(&edev->kobj, &pci_dev->dev.kobj, "pci_dev");
 	pci_dev_put(pci_dev);
 	return ret;
 }
@@ -696,21 +689,20 @@ edd_device_unregister(struct edd_device *edev)
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
 
-	if (!error) {
+	if (!error)
 		edd_create_symlink_to_pcidev(edev);
-	}
 }
 
 static int
@@ -745,7 +737,7 @@ static int __init
 edd_init(void)
 {
 	int i;
-	int rc=0;
+	int rc = 0;
 	struct edd_device *edev;
 
 	printk(KERN_INFO "BIOS EDD facility v%s %s, %d devices found\n",
@@ -761,7 +753,7 @@ edd_init(void)
 		return -ENOMEM;
 
 	for (i = 0; i < edd_num_devices(); i++) {
-		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
+		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
 		if (!edev) {
 			rc = -ENOMEM;
 			goto out;
@@ -791,7 +783,8 @@ edd_exit(void)
 	struct edd_device *edev;
 
 	for (i = 0; i < edd_num_devices(); i++) {
-		if ((edev = edd_devices[i]))
+		edev = edd_devices[i];
+		if (edev)
 			edd_device_unregister(edev);
 	}
 	kset_unregister(edd_kset);
-- 
1.8.5.2

