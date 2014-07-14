Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaGNQUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:20:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbaGNQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 5/6] xen/pciback: Print out the domain owning the device.
Date: Mon, 14 Jul 2014 12:18:55 -0400
Message-Id: <1405354736-7358-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had been printing it only if the device was built with
debug enabled. But this information is useful in the field
to troubleshoot.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index b3318fd..53e2dda 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -246,7 +246,7 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 	if (err)
 		goto out;
 
-	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
+	dev_info(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
 	if (xen_register_device_domain_owner(dev,
 					     pdev->xdev->otherend_id) != 0) {
 		dev_err(&dev->dev, "Stealing ownership from dom%d.\n",
-- 
1.9.3

