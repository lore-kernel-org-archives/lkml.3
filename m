Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab3BNMlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:41:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4194 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3BNMli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:41:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 04:41:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>
CC: <swarren@nvidia.com>, <khali@linux-fr.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: remove warning dump if timeout happen in transfer
Date: Thu, 14 Feb 2013 18:11:07 +0530
Message-ID: <1360845667-11276-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If timeout error occurs in the i2c transfer then it was dumping warning
of call stack.

Remove the warning dump as there is may be possibility that some slave
devices are busy and not responding the i2c communication.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The patch is generated based on discussion happen between Stephena and
Wolfram on the patch:
 i2c: add bcm2835 driver

 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index ae2e027..36704e3 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -587,7 +587,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	ret = wait_for_completion_timeout(&i2c_dev->msg_complete, TEGRA_I2C_TIMEOUT);
 	tegra_i2c_mask_irq(i2c_dev, int_mask);
 
-	if (WARN_ON(ret == 0)) {
+	if (ret == 0) {
 		dev_err(i2c_dev->dev, "i2c transfer timed out\n");
 
 		tegra_i2c_init(i2c_dev);
-- 
1.7.1.1

