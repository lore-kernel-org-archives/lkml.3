Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaFBVYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:24:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56291 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaFBVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:24:39 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] thermal: ti-soc-thermal: ti-bandgap.c:  Cleaning up wrong address is checked
Date: Mon,  2 Jun 2014 23:25:30 +0200
Message-Id: <1401744330-25966-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong address is checked after memory allocation.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 3ab12ee..43c0f83 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1155,7 +1155,7 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	/* register shadow for context save and restore */
 	bgp->regval = devm_kzalloc(&pdev->dev, sizeof(*bgp->regval) *
 				   bgp->conf->sensor_count, GFP_KERNEL);
-	if (!bgp) {
+	if (!bgp->regval) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.7.10.4

