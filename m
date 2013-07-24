Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3GXWQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:16:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3GXWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 09/36] ISDN: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:12 -0700
Message-Id: <1374703539-9705-10-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the mISDN class code to use the
correct field.

Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Karsten, feel free to apply this to your tree, or ACK it and I can take it
through mine.

 drivers/isdn/mISDN/core.c | 64 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index da30c5cb..faf50546 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -37,8 +37,8 @@ static void mISDN_dev_release(struct device *dev)
 	/* nothing to do: the device is part of its parent's data structure */
 }
 
-static ssize_t _show_id(struct device *dev,
-			struct device_attribute *attr, char *buf)
+static ssize_t id_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 
@@ -46,9 +46,10 @@ static ssize_t _show_id(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%d\n", mdev->id);
 }
+static DEVICE_ATTR_RO(id);
 
-static ssize_t _show_nrbchan(struct device *dev,
-			     struct device_attribute *attr, char *buf)
+static ssize_t nrbchan_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 
@@ -56,9 +57,10 @@ static ssize_t _show_nrbchan(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%d\n", mdev->nrbchan);
 }
+static DEVICE_ATTR_RO(nrbchan);
 
-static ssize_t _show_d_protocols(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static ssize_t d_protocols_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 
@@ -66,9 +68,10 @@ static ssize_t _show_d_protocols(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%d\n", mdev->Dprotocols);
 }
+static DEVICE_ATTR_RO(d_protocols);
 
-static ssize_t _show_b_protocols(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static ssize_t b_protocols_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 
@@ -76,9 +79,10 @@ static ssize_t _show_b_protocols(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%d\n", mdev->Bprotocols | get_all_Bprotocols());
 }
+static DEVICE_ATTR_RO(b_protocols);
 
-static ssize_t _show_protocol(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t protocol_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 
@@ -86,17 +90,19 @@ static ssize_t _show_protocol(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%d\n", mdev->D.protocol);
 }
+static DEVICE_ATTR_RO(protocol);
 
-static ssize_t _show_name(struct device *dev,
-			  struct device_attribute *attr, char *buf)
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	strcpy(buf, dev_name(dev));
 	return strlen(buf);
 }
+static DEVICE_ATTR_RO(name);
 
 #if 0 /* hangs */
-static ssize_t _set_name(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t count)
+static ssize_t name_set(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
 {
 	int err = 0;
 	char *out = kmalloc(count + 1, GFP_KERNEL);
@@ -113,10 +119,11 @@ static ssize_t _set_name(struct device *dev, struct device_attribute *attr,
 
 	return (err < 0) ? err : count;
 }
+static DEVICE_ATTR_RW(name);
 #endif
 
-static ssize_t _show_channelmap(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t channelmap_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct mISDNdevice *mdev = dev_to_mISDN(dev);
 	char *bp = buf;
@@ -127,18 +134,19 @@ static ssize_t _show_channelmap(struct device *dev,
 
 	return bp - buf;
 }
-
-static struct device_attribute mISDN_dev_attrs[] = {
-	__ATTR(id,          S_IRUGO,         _show_id,          NULL),
-	__ATTR(d_protocols, S_IRUGO,         _show_d_protocols, NULL),
-	__ATTR(b_protocols, S_IRUGO,         _show_b_protocols, NULL),
-	__ATTR(protocol,    S_IRUGO,         _show_protocol,    NULL),
-	__ATTR(channelmap,  S_IRUGO,         _show_channelmap,  NULL),
-	__ATTR(nrbchan,     S_IRUGO,         _show_nrbchan,     NULL),
-	__ATTR(name,        S_IRUGO,         _show_name,        NULL),
-/*	__ATTR(name,        S_IRUGO | S_IWUSR, _show_name,      _set_name), */
-	{}
+static DEVICE_ATTR_RO(channelmap);
+
+static struct attribute *mISDN_attrs[] = {
+	&dev_attr_id.attr,
+	&dev_attr_d_protocols.attr,
+	&dev_attr_b_protocols.attr,
+	&dev_attr_protocol.attr,
+	&dev_attr_channelmap.attr,
+	&dev_attr_nrbchan.attr,
+	&dev_attr_name.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(mISDN);
 
 static int mISDN_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -162,7 +170,7 @@ static struct class mISDN_class = {
 	.name = "mISDN",
 	.owner = THIS_MODULE,
 	.dev_uevent = mISDN_uevent,
-	.dev_attrs = mISDN_dev_attrs,
+	.dev_groups = mISDN_groups,
 	.dev_release = mISDN_dev_release,
 	.class_release = mISDN_class_release,
 };
-- 
1.8.3.rc0.20.gb99dd2e

