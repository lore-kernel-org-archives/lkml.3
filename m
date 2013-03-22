Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423166Ab3CVVOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:14:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44052 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423058Ab3CVVOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:14:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 2/2] staging: ti-soc-thermal: remove external heat while extrapolating hotspot
Date: Fri, 22 Mar 2013 17:13:07 -0400
Message-ID: <1363986787-28147-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For boards that provide a PCB sensor close to SoC junction
temperature, it is possible to remove the cumulative heat
reported by the SoC temperature sensor.

This patch changes the extrapolation computation to consider
an external sensor in the extrapolation equations.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
index 231c549..52d3c1b 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -92,10 +92,9 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
 	if (ret)
 		return ret;
 
-	pcb_temp = 0;
-	/* TODO: Introduce pcb temperature lookup */
+	ret = thermal_zone_lookup_temperature("pcb", &pcb_temp);
 	/* In case pcb zone is available, use the extrapolation rule with it */
-	if (pcb_temp) {
+	if (!ret) {
 		tmp -= pcb_temp;
 		slope = s->slope_pcb;
 		constant = s->constant_pcb;
-- 
1.7.7.1.488.ge8e1c

