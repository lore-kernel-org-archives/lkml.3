Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3I0BKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:10:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:8527 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3I0BKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,989,1371106800"; 
   d="scan'208";a="401716165"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH CHAR-MISC-NEXT 1/4] Intel MIC Host Driver Sysfs Cleanups.
Date: Thu, 26 Sep 2013 18:09:51 -0700
Message-Id: <14836f009d68ee2fb29501cc711f31176486e2f0.1380241770.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380241770.git.sudeep.dutt@intel.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Use DEVICE_ATTR_RO/RW instead of DEVICE_ATTR
+ Use ATTRIBUTE_GROUPS

These changes were suggested by Greg Kroah-Hartman during the
code review @ https://lkml.org/lkml/2013/9/6/13

Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/host/mic_sysfs.c | 72 ++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
index aaf8499..bebbae2 100644
--- a/drivers/misc/mic/host/mic_sysfs.c
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -65,7 +65,7 @@ void mic_set_state(struct mic_device *mdev, u8 state)
 }
 
 static ssize_t
-mic_show_family(struct device *dev, struct device_attribute *attr, char *buf)
+family_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	static const char x100[] = "x100";
 	static const char unknown[] = "Unknown";
@@ -85,10 +85,10 @@ mic_show_family(struct device *dev, struct device_attribute *attr, char *buf)
 	}
 	return scnprintf(buf, PAGE_SIZE, "%s\n", card);
 }
-static DEVICE_ATTR(family, S_IRUGO, mic_show_family, NULL);
+static DEVICE_ATTR_RO(family);
 
 static ssize_t
-mic_show_stepping(struct device *dev, struct device_attribute *attr, char *buf)
+stepping_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	char *string = "??";
@@ -114,10 +114,10 @@ mic_show_stepping(struct device *dev, struct device_attribute *attr, char *buf)
 	}
 	return scnprintf(buf, PAGE_SIZE, "%s\n", string);
 }
-static DEVICE_ATTR(stepping, S_IRUGO, mic_show_stepping, NULL);
+static DEVICE_ATTR_RO(stepping);
 
 static ssize_t
-mic_show_state(struct device *dev, struct device_attribute *attr, char *buf)
+state_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 
@@ -129,7 +129,7 @@ mic_show_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static ssize_t
-mic_store_state(struct device *dev, struct device_attribute *attr,
+state_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	int rc = 0;
@@ -160,9 +160,9 @@ mic_store_state(struct device *dev, struct device_attribute *attr,
 done:
 	return count;
 }
-static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mic_show_state, mic_store_state);
+static DEVICE_ATTR_RW(state);
 
-static ssize_t mic_show_shutdown_status(struct device *dev,
+static ssize_t shutdown_status_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -173,11 +173,10 @@ static ssize_t mic_show_shutdown_status(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%s\n",
 		mic_shutdown_status_string[mdev->shutdown_status]);
 }
-static DEVICE_ATTR(shutdown_status, S_IRUGO|S_IWUSR,
-	mic_show_shutdown_status, NULL);
+static DEVICE_ATTR_RO(shutdown_status);
 
 static ssize_t
-mic_show_cmdline(struct device *dev, struct device_attribute *attr, char *buf)
+cmdline_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	char *cmdline;
@@ -193,7 +192,7 @@ mic_show_cmdline(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static ssize_t
-mic_store_cmdline(struct device *dev, struct device_attribute *attr,
+cmdline_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -220,11 +219,10 @@ unlock:
 	mutex_unlock(&mdev->mic_mutex);
 	return count;
 }
-static DEVICE_ATTR(cmdline, S_IRUGO | S_IWUSR,
-	mic_show_cmdline, mic_store_cmdline);
+static DEVICE_ATTR_RW(cmdline);
 
 static ssize_t
-mic_show_firmware(struct device *dev, struct device_attribute *attr, char *buf)
+firmware_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	char *firmware;
@@ -240,7 +238,7 @@ mic_show_firmware(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static ssize_t
-mic_store_firmware(struct device *dev, struct device_attribute *attr,
+firmware_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -266,11 +264,10 @@ unlock:
 	mutex_unlock(&mdev->mic_mutex);
 	return count;
 }
-static DEVICE_ATTR(firmware, S_IRUGO | S_IWUSR,
-	mic_show_firmware, mic_store_firmware);
+static DEVICE_ATTR_RW(firmware);
 
 static ssize_t
-mic_show_ramdisk(struct device *dev, struct device_attribute *attr, char *buf)
+ramdisk_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	char *ramdisk;
@@ -286,7 +283,7 @@ mic_show_ramdisk(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static ssize_t
-mic_store_ramdisk(struct device *dev, struct device_attribute *attr,
+ramdisk_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -313,11 +310,10 @@ unlock:
 	mutex_unlock(&mdev->mic_mutex);
 	return count;
 }
-static DEVICE_ATTR(ramdisk, S_IRUGO | S_IWUSR,
-	mic_show_ramdisk, mic_store_ramdisk);
+static DEVICE_ATTR_RW(ramdisk);
 
 static ssize_t
-mic_show_bootmode(struct device *dev, struct device_attribute *attr, char *buf)
+bootmode_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	char *bootmode;
@@ -333,7 +329,7 @@ mic_show_bootmode(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static ssize_t
-mic_store_bootmode(struct device *dev, struct device_attribute *attr,
+bootmode_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -363,11 +359,10 @@ unlock:
 	mutex_unlock(&mdev->mic_mutex);
 	return count;
 }
-static DEVICE_ATTR(bootmode, S_IRUGO | S_IWUSR,
-	mic_show_bootmode, mic_store_bootmode);
+static DEVICE_ATTR_RW(bootmode);
 
 static ssize_t
-mic_show_log_buf_addr(struct device *dev, struct device_attribute *attr,
+log_buf_addr_show(struct device *dev, struct device_attribute *attr,
 	char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -379,7 +374,7 @@ mic_show_log_buf_addr(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-mic_store_log_buf_addr(struct device *dev, struct device_attribute *attr,
+log_buf_addr_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -398,11 +393,10 @@ mic_store_log_buf_addr(struct device *dev, struct device_attribute *attr,
 exit:
 	return ret;
 }
-static DEVICE_ATTR(log_buf_addr, S_IRUGO | S_IWUSR,
-	mic_show_log_buf_addr, mic_store_log_buf_addr);
+static DEVICE_ATTR_RW(log_buf_addr);
 
 static ssize_t
-mic_show_log_buf_len(struct device *dev, struct device_attribute *attr,
+log_buf_len_show(struct device *dev, struct device_attribute *attr,
 	char *buf)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -414,7 +408,7 @@ mic_show_log_buf_len(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-mic_store_log_buf_len(struct device *dev, struct device_attribute *attr,
+log_buf_len_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -433,8 +427,7 @@ mic_store_log_buf_len(struct device *dev, struct device_attribute *attr,
 exit:
 	return ret;
 }
-static DEVICE_ATTR(log_buf_len, S_IRUGO | S_IWUSR,
-	mic_show_log_buf_len, mic_store_log_buf_len);
+static DEVICE_ATTR_RW(log_buf_len);
 
 static struct attribute *mic_default_attrs[] = {
 	&dev_attr_family.attr,
@@ -451,16 +444,9 @@ static struct attribute *mic_default_attrs[] = {
 	NULL
 };
 
-static struct attribute_group mic_attr_group = {
-	.attrs = mic_default_attrs,
-};
-
-static const struct attribute_group *__mic_attr_group[] = {
-	&mic_attr_group,
-	NULL
-};
+ATTRIBUTE_GROUPS(mic_default);
 
 void mic_sysfs_init(struct mic_device *mdev)
 {
-	mdev->attr_group = __mic_attr_group;
+	mdev->attr_group = mic_default_groups;
 }
-- 
1.8.2.1

