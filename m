Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaKUWSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:18:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34046 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaKUWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:18:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v4 4/7] xen/pciback: Print out the domain owning the device.
Date: Fri, 21 Nov 2014 17:17:48 -0500
Message-Id: <1416608271-18931-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had been printing it only if the device was built with
debug enabled. But this information is useful in the field
to troubleshoot.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/xen-pciback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index eeee499..fe17c80 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -247,7 +247,7 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 	if (err)
 		goto out;
 
-	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
+	dev_info(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
 	if (xen_register_device_domain_owner(dev,
 					     pdev->xdev->otherend_id) != 0) {
 		dev_err(&dev->dev, "Stealing ownership from dom%d.\n",
-- 
1.9.3

