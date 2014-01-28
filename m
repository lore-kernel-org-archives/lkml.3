Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaA1Fse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 00:48:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:17358 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaA1Fsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 00:48:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,734,1384329600"; 
   d="scan'208";a="471847422"
Message-ID: <52E744AC.2050606@intel.com>
Date: Tue, 28 Jan 2014 13:48:28 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-i2c@vger.kernel.org, wsa@the-dreams.de,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: [PATCH] i2c-designware-pcidrv: fix the incorrect return of idle callback
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xinhui.pan" <xinhuix.pan@intel.com>

i2c_dw_pci_runtime_idle should return -EBUSY rather than zero if it do success.
Otherwise rpm_idle will call pm_suspend again and that may cause pm_schedule_suspend delay invalidate.
	
Signed-off-by: bo.he <bo.he@intel.com>
Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c..96e81f6 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -190,8 +190,8 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
 	int err = pm_schedule_suspend(dev, 500);
 	dev_dbg(dev, "runtime_idle called\n");
 
-	if (err != 0)
-		return 0;
+	if (err)
+		return err;
 	return -EBUSY;
 }
 
-- 
1.7.9.5
