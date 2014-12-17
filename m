Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaLQVls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:41:48 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51811
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbaLQVlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:41:46 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Add device and vendor ID to vmbus devices
Date: Wed, 17 Dec 2014 14:52:24 -0800
Message-Id: <1418856744-16359-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vendor and device ID attributes to vmbus devices. This would allow us to
support vmbus based devices that can support guest RDMA.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/vmbus_drv.c |   20 ++++++++++++++++++++
 include/linux/hyperv.h |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4d6b269..215aac9 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -385,6 +385,24 @@ static ssize_t in_write_bytes_avail_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(in_write_bytes_avail);
 
+static ssize_t vendor_show(struct device *dev,
+			   struct device_attribute *dev_atttr,
+			   char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+	return sprintf(buf, "0x%x\n", hv_dev->vendor_id);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t device_show(struct device *dev,
+			   struct device_attribute *dev_atttr,
+			   char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+	return sprintf(buf, "0x%x\n", hv_dev->device_id);
+}
+static DEVICE_ATTR_RO(device);
+
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct attribute *vmbus_attrs[] = {
 	&dev_attr_id.attr,
@@ -409,6 +427,8 @@ static struct attribute *vmbus_attrs[] = {
 	&dev_attr_in_write_index.attr,
 	&dev_attr_in_read_bytes_avail.attr,
 	&dev_attr_in_write_bytes_avail.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(vmbus);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 476c685..6fe4dfe 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -891,6 +891,8 @@ struct hv_device {
 
 	/* the device instance id of this device */
 	uuid_le dev_instance;
+	u16 vendor_id;
+	u16 device_id;
 
 	struct device device;
 
-- 
1.7.4.1

