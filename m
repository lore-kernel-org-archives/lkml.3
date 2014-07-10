Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaGJLrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:47:41 -0400
Received: from sauhun.de ([89.238.76.85]:57122 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbaGJLrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:47:06 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] i2c: i2c-tegra: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:35 +0200
Message-Id: <1404992799-3705-16-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been flagged to drop class based instantiation. The removal
improves boot-up time and is unneeded for embedded controllers. Users have been
warned to switch for some time now, so we can actually do the removal. Keep the
DEPRECATED flag, so the core can inform users that the behaviour finally
changed now. After another transition period, this flag can go, too.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index f1bb2fc06791..87d0371cebb7 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -792,7 +792,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
 	i2c_dev->adapter.owner = THIS_MODULE;
-	i2c_dev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
+	i2c_dev->adapter.class = I2C_CLASS_DEPRECATED;
 	strlcpy(i2c_dev->adapter.name, "Tegra I2C adapter",
 		sizeof(i2c_dev->adapter.name));
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
-- 
2.0.0

