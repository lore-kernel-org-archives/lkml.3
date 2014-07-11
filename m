Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaGKTH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:07:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:46763 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbaGKTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:07:25 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v4 4/5] xen/pciback: Print out the domain owning the device.
Date: Fri, 11 Jul 2014 16:08:51 -0400
Message-Id: <1405109332-31659-5-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1405109332-31659-1-git-send-email-konrad@kernel.org>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

We had been printing it only if the device was built with
debug enabled. But this information is useful in the field
to troubleshoot.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/xenbus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 065aae8..0f80760 100644
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

