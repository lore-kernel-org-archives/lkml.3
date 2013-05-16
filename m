Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3EPGbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3EPGbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:31:17 -0400
Date: Thu, 16 May 2013 14:31:30 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org, caiqian@redhat.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] print sysfs attribute name when warning about bogus
 permissions
Message-ID: <51947d42.10bQDPr2BKkJl5ZS%dyoung@redhat.com>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make it obvious to see what attribute is using bogus permissions.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -572,9 +572,11 @@ int device_create_file(struct device *de
 
 	if (dev) {
 		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
-				"Write permission without 'store'\n");
+			"Attribute %s: write permission without 'store'\n",
+			attr->attr.name);
 		WARN(((attr->attr.mode & S_IRUGO) && !attr->show),
-				"Read permission without 'show'\n");
+			"Attribute %s: read permission without 'show'\n",
+			attr->attr.name);
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
 	}
 
