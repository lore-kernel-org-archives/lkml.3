Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3BLReW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:34:22 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:35252 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BLReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:34:19 -0500
Date: Tue, 12 Feb 2013 09:34:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Wolfram Sang <w.sang@pengutronix.de>, akpm@linux-foundation.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH -mm] i2c: style cleanups after idr_alloc() conversion
Message-ID: <20130212173414.GD7348@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
 <20130207163958.GY4720@opensource.wolfsonmicro.com>
 <20130207165547.GO2875@htj.dyndns.org>
 <20130210114729.GB5472@nekote.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130210114729.GB5472@nekote.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style cleanups suggested by Wolfram.

* s/res/id/ in i2c_add_numbered_adapter() so that it matches
  i2c_add_adapter().

* Add a blank line before return in i2c_add_numbered_adapter().

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/i2c/i2c-core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -935,16 +935,17 @@ out_list:
  */
 int i2c_add_adapter(struct i2c_adapter *adapter)
 {
-	int res;
+	int id;
 
 	mutex_lock(&core_lock);
-	res = idr_alloc(&i2c_adapter_idr, adapter,
-			__i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
+	id = idr_alloc(&i2c_adapter_idr, adapter,
+		       __i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
 	mutex_unlock(&core_lock);
-	if (res < 0)
-		return res;
+	if (id < 0)
+		return id;
+
+	adapter->nr = id;
 
-	adapter->nr = res;
 	return i2c_register_adapter(adapter);
 }
 EXPORT_SYMBOL(i2c_add_adapter);
