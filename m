Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab3DKQhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:37:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48896 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3DKQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:37:18 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-46-5166e6bc59bc
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        devicetree-discuss@lists.ozlabs.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] regulator: wm8994: Use GPIO parsed from DT when registering
 regulators
Date: Thu, 11 Apr 2013 18:36:57 +0200
Message-id: <1365698217-17771-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20130411162315.GF9243@opensource.wolfsonmicro.com>
References: <20130411162315.GF9243@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e+xoO6eZ2mBBl+3KFj8m32KzeLA7Ies
	Fmeb3rBbXN41h83i8Jt2VgdWj/MzFjJ6vJz4m82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mt7OnMFc0M9R8eG4WgPje7YuRk4OCQETiclzXrJC2GISF+6tB4pzcQgJTGeUuNJ1mQXC6WCS
	uPl1LjNIFZuAoUTv0T7GLkYODhEBdYmtx3VAapgFJjJK7Dr7lBGkRlggUuLh4R/sIDUsAqoS
	N8/zgoR5BdwkvrZ8BGuVEFCQmDPJBiTMKeAgsaJ3CROILSRgLzFz1kzGCYy8CxgZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEh8wzqR2MKxssDjEKcDAq8fCeaEgNFGJNLCuuzD3EKMHB
	rCTCG7M3LVCINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD
	48X6fXnJz7knRZ/o+lVw7sFS1bizbzZ5x7RdPfrgRuWKF7t+33+sEhWwQGqKjuKKdSeunRC3
	Tu5Ueqe5bMEtsZSLK6Xaf1y4dUtg8nVlt6Rv7Vsn1r7z4vty8OhMU9kDz3MKmtOn7j5lycO9
	YA9foPnbNQHNzF+W1CkdcTt2feMhC7WeExJdN94rsRRnJBpqMRcVJwIAd1T43xUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the regulators are registered with a GPIO parsed from the device
tree when available.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/regulator/wm8994-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 086be66..dab41ae 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -149,9 +149,11 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	config.init_data = &ldo->init_data;
 	if (pdata)
 		config.ena_gpio = pdata->ldo[id].enable;
+	else if (wm8994->dev->of_node)
+		config.ena_gpio = wm8994->pdata.ldo[id].enable;
 
 	/* Use default constraints if none set up */
-	if (!pdata || !pdata->ldo[id].init_data) {
+	if (!pdata || !pdata->ldo[id].init_data || wm8994->dev->of_node) {
 		dev_dbg(wm8994->dev, "Using default init data, supply %s %s\n",
 			ldo->supply.dev_name, ldo->supply.supply);
 
-- 
1.7.9.5

