Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbbAFPaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:30:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbAFPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:30:51 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] mfd: syscon: fix syscon probing from dt
Date: Tue,  6 Jan 2015 16:30:36 +0100
Message-Id: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
breaks probing pure syscon devices from device tree, such as anatop and
iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
"syscon" compatible device tree nodes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/mfd/syscon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 176bf0f..70b8654 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -174,6 +174,11 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
 
+static const struct of_device_id of_syscon_match[] = {
+	{ .compatible = "syscon", },
+	{ },
+};
+
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -219,6 +224,7 @@ static const struct platform_device_id syscon_ids[] = {
 static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
+		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
 	.id_table	= syscon_ids,
-- 
2.1.4

