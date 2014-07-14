Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaGNLNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:13:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19879 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaGNLNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:13:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 Jul 2014 04:06:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rui.zhang@intel.com>, <eduardo.valentin@ti.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] thermal: of: look for sensor driver parent node if device node missing
Date: Mon, 14 Jul 2014 16:42:34 +0530
Message-ID: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some mfd devices which supports junction thermal interrupt
like ams,AS3722. The DT binding of these devices are defined as the
flat and drivers for sub module of such devices are registered as
the mfd_add_devices. In this method, the sub devices registered as
platform driver and these do not have the of_node pointer on their
device structure. In this case, use the parent of_node pointer to
get the required of_node pointer.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/thermal/of-thermal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 04b1be7..85a7d71 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -396,6 +396,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
 		return ERR_PTR(-EINVAL);
 
 	sensor_np = dev->of_node;
+	if (!sensor_np && dev->parent)
+		sensor_np = dev->parent->of_node;
 
 	for_each_child_of_node(np, child) {
 		struct of_phandle_args sensor_specs;
-- 
1.8.1.5

