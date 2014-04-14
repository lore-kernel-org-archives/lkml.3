Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaDNRDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:03:08 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:38797 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDNRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:03:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] thermal: rcar: Use pm_runtime_put() i.s.o. pm_runtime_put_sync()
Date: Mon, 14 Apr 2014 19:02:55 +0200
Message-Id: <1397494975-22489-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

There's no need for this to be synchronous

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/thermal/rcar_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 5a37940b02c9..a8ed0e0265ae 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -470,7 +470,7 @@ error_unregister:
 			rcar_thermal_irq_disable(priv);
 	}
 
-	pm_runtime_put_sync(dev);
+	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
 
 	return ret;
@@ -488,7 +488,7 @@ static int rcar_thermal_remove(struct platform_device *pdev)
 			rcar_thermal_irq_disable(priv);
 	}
 
-	pm_runtime_put_sync(dev);
+	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
 
 	return 0;
-- 
1.7.9.5

