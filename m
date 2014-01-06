Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaAFMyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:54:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40029 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaAFMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:54:44 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 1/1] thermal: remove const flag from .ops of imx thermal
Date: Mon, 6 Jan 2014 08:54:34 -0400
Message-ID: <1389012874-13871-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per previous changes on thermal framework API,
registering a new thermal zone does not require
a const thermal zone ops.

Thus, this patch removes the flag from imx thermal zone ops.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/imx_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 77a962f..43d2f77 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -284,7 +284,7 @@ static int imx_unbind(struct thermal_zone_device *tz,
 	return 0;
 }
 
-static const struct thermal_zone_device_ops imx_tz_ops = {
+static struct thermal_zone_device_ops imx_tz_ops = {
 	.bind = imx_bind,
 	.unbind = imx_unbind,
 	.get_temp = imx_get_temp,
-- 
1.8.2.1.342.gfa7285d

