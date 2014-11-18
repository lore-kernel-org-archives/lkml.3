Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaKRM7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:59:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:34558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaKRM66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:58:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="624205579"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: wsa@the-dreams.de, julia.lawall@lip6.fr, dan.carpenter@oracle.com,
        johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 2/4] i2c: dln2: simplify return flow for dln2_i2c_enable
Date: Tue, 18 Nov 2014 14:57:58 +0200
Message-Id: <1416315480-2053-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
References: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following kbuild test robot warning:

>> drivers/i2c/busses/i2c-dln2.c:70:1-4: WARNING: end returns can be simplified if negative or 0 value

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-dln2.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-dln2.c b/drivers/i2c/busses/i2c-dln2.c
index 010a5fa..b3fb86a 100644
--- a/drivers/i2c/busses/i2c-dln2.c
+++ b/drivers/i2c/busses/i2c-dln2.c
@@ -54,7 +54,6 @@ struct dln2_i2c {
 
 static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
 {
-	int ret;
 	u16 cmd;
 	struct {
 		u8 port;
@@ -67,11 +66,7 @@ static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
 	else
 		cmd = DLN2_I2C_DISABLE;
 
-	ret = dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
 }
 
 static int dln2_i2c_write(struct dln2_i2c *dln2, u8 addr,
-- 
1.9.1

