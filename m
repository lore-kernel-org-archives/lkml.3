Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3CONEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:04:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59844 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3CONEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:04:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 09/50] staging: omap-thermal: make a omap_bandgap_power with only one exit point
Date: Fri, 15 Mar 2013 08:59:57 -0400
Message-ID: <1363352438-15935-10-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the way the omap_bandgap_power is written so that it has only
one exit entry (Documentation/CodingStyle).

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index a8d63a2..ec79ec1 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -91,12 +91,13 @@ static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
 	int i;
 
 	if (!OMAP_BANDGAP_HAS(bg_ptr, POWER_SWITCH))
-		return 0;
+		goto exit;
 
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++)
 		/* active on 0 */
 		RMW_BITS(bg_ptr, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
 
+exit:
 	return 0;
 }
 
-- 
1.7.7.1.488.ge8e1c

