Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3CUMIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:08:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:55767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3CUMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282699984"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/7] i2c-designware-pci: use dev_err() instead of printk()
Date: Thu, 21 Mar 2013 14:09:55 +0200
Message-Id: <1363867800-23861-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

With dev_err() we can get the device instance printed as well and is pretty
much standard to use dev_* macros in drivers anyway. In addition correct
indentation of probe() arguments.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 7c5e383..eed149d 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -208,7 +208,7 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 }
 
 static int i2c_dw_pci_probe(struct pci_dev *pdev,
-const struct pci_device_id *id)
+			    const struct pci_device_id *id)
 {
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
@@ -218,7 +218,7 @@ const struct pci_device_id *id)
 	struct  dw_pci_controller *controller;
 
 	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers)) {
-		printk(KERN_ERR "dw_i2c_pci_probe: invalid driver data %ld\n",
+		dev_err(&pdev->dev, "%s: invalid driver data %ld\n", __func__,
 			id->driver_data);
 		return -EINVAL;
 	}
-- 
1.7.10.4

