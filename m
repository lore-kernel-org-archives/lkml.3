Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3IRMwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:52:54 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:55588 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3IRMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:52:53 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: mv64xxx: Do not use writel_relaxed()
Date: Wed, 18 Sep 2013 14:51:40 +0200
Message-Id: <1379508700-30400-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used on PowerPC which don't provide writel_relaxed(). This
breaks the c2k and prpmc2800 default configurations. To fix the build,
turn the calls to writel_relaxed() into writel(). The impacts for ARM
should be minimal.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 7f3a474..5aead74 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -234,9 +234,9 @@ static int mv64xxx_i2c_offload_msg(struct mv64xxx_i2c_data *drv_data)
 		ctrl_reg |= MV64XXX_I2C_BRIDGE_CONTROL_WR |
 		    (msg->len - 1) << MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT;
 
-		writel_relaxed(data_reg_lo,
+		writel(data_reg_lo,
 			drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_LO);
-		writel_relaxed(data_reg_hi,
+		writel(data_reg_hi,
 			drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_HI);
 
 	} else {
-- 
1.8.4

