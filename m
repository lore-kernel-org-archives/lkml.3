Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3JHCQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:16:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3JHCQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:16:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        <industrypack-devel@lists.sourceforge.net>
Subject: [PATCH 2/8] ipack: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:36 -0700
Message-Id: <1381195662-28009-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the ipack bus code to use the
correct field.

Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: <industrypack-devel@lists.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Samuel and Jens, I can take this through my driver-core tree if you
don't want to take it through yours, just let me know what works best
for you.

 drivers/ipack/ipack.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 6e066c5..d0016ba 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -180,20 +180,28 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 ipack_device_attr(id_format, "0x%hhu\n");
 
-static struct device_attribute ipack_dev_attrs[] = {
-	__ATTR_RO(id),
-	__ATTR_RO(id_device),
-	__ATTR_RO(id_format),
-	__ATTR_RO(id_vendor),
-	__ATTR_RO(modalias),
+static DEVICE_ATTR_RO(id);
+static DEVICE_ATTR_RO(id_device);
+static DEVICE_ATTR_RO(id_format);
+static DEVICE_ATTR_RO(id_vendor);
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *ipack_attrs[] = {
+	&dev_attr_id.attr,
+	&dev_attr_id_device.attr,
+	&dev_attr_id_format.attr,
+	&dev_attr_id_vendor.attr,
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(ipack);
 
 static struct bus_type ipack_bus_type = {
 	.name      = "ipack",
 	.probe     = ipack_bus_probe,
 	.match     = ipack_bus_match,
 	.remove    = ipack_bus_remove,
-	.dev_attrs = ipack_dev_attrs,
+	.dev_groups = ipack_groups,
 	.uevent	   = ipack_uevent,
 };
 
-- 
1.8.4.6.g82e253f.dirty

