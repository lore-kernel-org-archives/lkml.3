Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaLVSoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:44:04 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36040 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbaLVSoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:44:02 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [PATCH v2 2/6] dgnc/dgnc_sysfs.c: checkpatch: Use of dev_err ? instead of printk
Date: Mon, 22 Dec 2014 19:43:56 +0100
Message-Id: <1419273836-11192-1-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141222020039.GA2489@kroah.com>
References: <20141222020039.GA2489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally wanted to replace both of  the  printk cals in this file with dev_err().
But in the function dgnc_create_driver_sysfiles only the struct pci_driver was given,
sadly I coudn't figure out a way to get a struct device when only a struct pci_driver is given.

Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dgnc_sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 2fd34ca..8be3b51 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -360,7 +360,8 @@ void dgnc_create_ports_sysfiles(struct dgnc_board *bd)
 	rc |= device_create_file(&(bd->pdev->dev), &dev_attr_vpd);
 	rc |= device_create_file(&(bd->pdev->dev), &dev_attr_serial_number);
 	if (rc)
-		printk(KERN_ERR "DGNC: sysfs device_create_file failed!\n");
+		dev_err(&(bd->pdev->dev),
+			"DGNC: sysfs device_create_file failed!\n");
 }
 
 
-- 
1.9.1

