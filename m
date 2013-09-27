Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3I0NZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:25:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab3I0NZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:25:21 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] regulator: ti-abb: skip optional parameter for ldo-address
Date: Fri, 27 Sep 2013 08:25:13 -0500
Message-ID: <1380288314-24064-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380288314-24064-1-git-send-email-nm@ti.com>
References: <1380288314-24064-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms like OMAP4460, LDO override is never used. Even though
efuse determines the ABB bias mode to operate at, ABB voltage is
preconfigured in internal efuse registers without the need for
LDO override for bias voltage. So skip optional parameter if
property is not present.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/ti-abb-regulator.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index d8e3e12..1e02805 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -765,6 +765,11 @@ static int ti_abb_probe(struct platform_device *pdev)
 
 	pname = "ldo-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+	if (!res) {
+		dev_dbg(dev, "Missing '%s' IO resource\n", pname);
+		ret = -ENODEV;
+		goto skip_opt;
+	}
 	abb->ldo_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(abb->ldo_base)) {
 		ret = PTR_ERR(abb->ldo_base);
-- 
1.7.9.5

