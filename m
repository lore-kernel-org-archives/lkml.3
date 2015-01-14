Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbbANVIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:08:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbANVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:08:08 -0500
Date: Thu, 15 Jan 2015 00:08:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [patch] mcb: request_mem_region() returns NULL on error
Message-ID: <20150114210840.GG23203@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code here is checking for IS_ERR() when request_mem_region() only
returns NULL on error and never an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
index 5e1bd5d..2d6524a 100644
--- a/drivers/mcb/mcb-pci.c
+++ b/drivers/mcb/mcb-pci.c
@@ -56,9 +56,9 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	res = request_mem_region(priv->mapbase, CHAM_HEADER_SIZE,
 				 KBUILD_MODNAME);
-	if (IS_ERR(res)) {
+	if (!res) {
 		dev_err(&pdev->dev, "Failed to request PCI memory\n");
-		ret = PTR_ERR(res);
+		ret = -EBUSY;
 		goto err_start;
 	}
 
