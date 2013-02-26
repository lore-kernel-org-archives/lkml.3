Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab3BZW70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:59:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51048 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3BZW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:59:24 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 15/15] staging: omap-thermal: update clock prepare count
Date: Tue, 26 Feb 2013 18:53:38 -0400
Message-ID: <1361919218-9788-16-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the clock management code to also update
the clock prepare counter, this way we won't skip the enable/disable
operation due to prepare dependencies.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 83f74f4..d4a3788 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -943,7 +943,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 
 	bg_ptr->clk_rate = clk_rate;
 	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_enable(bg_ptr->fclock);
+		clk_prepare_enable(bg_ptr->fclock);
 
 
 	mutex_init(&bg_ptr->bg_mutex);
@@ -1013,7 +1013,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 
 disable_clk:
 	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable(bg_ptr->fclock);
+		clk_disable_unprepare(bg_ptr->fclock);
 put_clks:
 	clk_put(bg_ptr->fclock);
 	clk_put(bg_ptr->div_clk);
@@ -1044,7 +1044,7 @@ int omap_bandgap_remove(struct platform_device *pdev)
 	omap_bandgap_power(bg_ptr, false);
 
 	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable(bg_ptr->fclock);
+		clk_disable_unprepare(bg_ptr->fclock);
 	clk_put(bg_ptr->fclock);
 	clk_put(bg_ptr->div_clk);
 
@@ -1143,7 +1143,7 @@ static int omap_bandgap_suspend(struct device *dev)
 	omap_bandgap_power(bg_ptr, false);
 
 	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable(bg_ptr->fclock);
+		clk_disable_unprepare(bg_ptr->fclock);
 
 	return err;
 }
@@ -1153,7 +1153,7 @@ static int omap_bandgap_resume(struct device *dev)
 	struct omap_bandgap *bg_ptr = dev_get_drvdata(dev);
 
 	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_enable(bg_ptr->fclock);
+		clk_prepare_enable(bg_ptr->fclock);
 
 	omap_bandgap_power(bg_ptr, true);
 
-- 
1.7.7.1.488.ge8e1c

