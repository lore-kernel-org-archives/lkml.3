Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3GXWOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:14:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3GXWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 24/36] SCSI: OSD: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:27 -0700
Message-Id: <1374703539-9705-25-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the scsi osd class code to use
the correct field.

Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@tonian.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

James, feel free to take this through your tree, or ACK it and I can
take it through mine.

 drivers/scsi/osd/osd_uld.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 9d86947d..e1d9a4c4 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -107,6 +107,7 @@ static ssize_t osdname_show(struct device *dev, struct device_attribute *attr,
 						   class_dev);
 	return sprintf(buf, "%s\n", ould->odi.osdname);
 }
+static DEVICE_ATTR_RO(osdname);
 
 static ssize_t systemid_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
@@ -117,17 +118,19 @@ static ssize_t systemid_show(struct device *dev, struct device_attribute *attr,
 	memcpy(buf, ould->odi.systemid, ould->odi.systemid_len);
 	return ould->odi.systemid_len;
 }
+static DEVICE_ATTR_RO(systemid);
 
-static struct device_attribute osd_uld_attrs[] = {
-	__ATTR(osdname, S_IRUGO, osdname_show, NULL),
-	__ATTR(systemid, S_IRUGO, systemid_show, NULL),
-	__ATTR_NULL,
+static struct attribute *osd_uld_attrs[] = {
+	&dev_attr_osdname.attr,
+	&dev_attr_systemid.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(osd_uld);
 
 static struct class osd_uld_class = {
 	.owner		= THIS_MODULE,
 	.name		= "scsi_osd",
-	.dev_attrs	= osd_uld_attrs,
+	.dev_groups	= osd_uld_groups,
 };
 
 /*
-- 
1.8.3.rc0.20.gb99dd2e

