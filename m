Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3FRKdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:33:53 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17518 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3FRKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:33:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Jun 2013 03:33:48 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <broonie@kernel.org>, <wsa@the-dreams.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linus.walleij@linaro.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] regulator: tps51632: Get regulator name from i2c_client
Date: Tue, 18 Jun 2013 13:30:13 +0300
Message-ID: <1371551413-12346-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "i2c: core: make it possible to match a pure device tree driver"
changed semantics of the i2c probing for device tree devices.
Device tree probed devices now get a NULL i2c_device_id pointer.
This causes the regulator name to be set to NULL and the regulator
registration to fail.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/regulator/tps51632-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 6e67be7..87c37f8 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -305,7 +305,7 @@ static int tps51632_probe(struct i2c_client *client,
 	}
 
 	tps->dev = &client->dev;
-	tps->desc.name = id->name;
+	tps->desc.name = client->name;
 	tps->desc.id = 0;
 	tps->desc.ramp_delay = TPS51632_DEFAULT_RAMP_DELAY;
 	tps->desc.min_uV = TPS51632_MIN_VOLATGE;
-- 
1.8.1.5

