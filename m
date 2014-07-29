Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaG2LQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:16:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63920 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaG2LQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:16:22 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging/nvec: Do not pass resource to mfd_add_devices()
Date: Tue, 29 Jul 2014 13:16:14 +0200
Message-Id: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The mfd_add_devices() function takes a struct resource * as fifth
argument, but the nvec driver passes in a void __iomem *. The driver
gets away with it because none of the subdevices ever directly access
the registers.

Since subdevices never need to access the registers we can simply pass
NULL instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/nvec/nvec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 0a5c84ad3f41..815065837ce7 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -893,7 +893,7 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
-			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
+			      ARRAY_SIZE(nvec_devices), NULL, 0, NULL);
 	if (ret)
 		dev_err(nvec->dev, "error adding subdevices\n");
 
-- 
2.0.2

