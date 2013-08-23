Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3HWVY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:24:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab3HWVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 06/15] SCSI: fcoe: convert bus code to use bus_groups
Date: Fri, 23 Aug 2013 14:24:32 -0700
Message-Id: <1377293081-10957-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the fcoe bus code to use the
correct field.

Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index c9382d6e..8189b96e 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -553,16 +553,20 @@ static struct device_type fcoe_fcf_device_type = {
 	.release = fcoe_fcf_device_release,
 };
 
-static struct bus_attribute fcoe_bus_attr_group[] = {
-	__ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store),
-	__ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store),
-	__ATTR_NULL
+static BUS_ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store);
+static BUS_ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store);
+
+static struct attribute *fcoe_bus_attrs[] = {
+	&bus_attr_ctlr_create.attr,
+	&bus_attr_ctrl_destroy.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(fcoe_bus);
 
 static struct bus_type fcoe_bus_type = {
 	.name = "fcoe",
 	.match = &fcoe_bus_match,
-	.bus_attrs = fcoe_bus_attr_group,
+	.bus_groups = fcoe_bus_groups,
 };
 
 /**
-- 
1.8.3.rc0.20.gb99dd2e

