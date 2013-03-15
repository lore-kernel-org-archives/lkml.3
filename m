Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3CONDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:03:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3CONDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:03:35 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 06/50] staging: omap-thermal: fix error checking
Date: Fri, 15 Mar 2013 08:59:54 -0400
Message-ID: <1363352438-15935-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap_bandgap_get_sensor_data() function returns ERR_PTR(),
but it can also return NULL, in case of initilization, so we need to use
IS_ERR_OR_NULL() rather than only IS_ERR().

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-thermal-common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
index 79a55aa..8aebc6a 100644
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/omap-thermal/omap-thermal-common.c
@@ -260,7 +260,7 @@ int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
 
 	data = omap_bandgap_get_sensor_data(bg_ptr, id);
 
-	if (IS_ERR(data))
+	if (IS_ERR_OR_NULL(data))
 		data = omap_thermal_build_data(bg_ptr, id);
 
 	if (!data)
@@ -309,7 +309,7 @@ int omap_thermal_register_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
 	struct omap_thermal_data *data;
 
 	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-	if (IS_ERR(data))
+	if (IS_ERR_OR_NULL(data))
 		data = omap_thermal_build_data(bg_ptr, id);
 
 	if (!data)
-- 
1.7.7.1.488.ge8e1c

