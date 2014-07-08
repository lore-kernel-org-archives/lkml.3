Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaGHR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:54886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbaGHR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:08 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 6/7] xen/pciback: Print out the domain owning the device.
Date: Tue,  8 Jul 2014 14:58:28 -0400
Message-Id: <1404845909-13563-7-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

We had been printing it only if the device was built with
debug enabled. But this information is usuable in the field
to troubleshoot.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/xenbus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 81d5068..f18174a 100644
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
1.7.7.6

