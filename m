Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaBYG6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:58:01 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2423 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBYG6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:58:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Feb 2014 22:54:23 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Markus Pargmann <mpa@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] regulator: core: allow enabling without enable op
Date: Tue, 25 Feb 2014 15:57:50 +0900
Message-ID: <1393311470-11526-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14c32a3ce6676265d7a27ea64a4d406e6dbad111 replaced direct uses of
ops->enable by calls to _regulator_do_enable. This prevents a fixed
regulators without a GPIO from being probed, since the former code
checked the existence of ops->enable and continued if it did not exist,
while _regulator_do_enable return -EINVAL in that case.

This patch fixes this by allowing _regulator_do_enable to go through
without error if ops->enable is not defined, similarly to what
_regulator_do_disable already does.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/regulator/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bdb12659dd41..4306422cee5d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1763,8 +1763,6 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0)
 			return ret;
-	} else {
-		return -EINVAL;
 	}
 
 	/* Allow the regulator to ramp; it would be useful to extend
-- 
1.9.0

