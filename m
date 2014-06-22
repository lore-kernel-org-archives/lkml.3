Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaFVPdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 11:33:40 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34001 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaFVPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 11:33:24 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 2/5] regulator: act8865: set correct number of regulators in pdata
Date: Sun, 22 Jun 2014 17:31:42 +0200
Message-Id: <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform data is populated from DT all the regulators are
instantiated and the value of num_regulators should be the number of
all available regulators rather than the number of matched ones.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/regulator/act8865-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index fe2c038..b03a0e8 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -230,7 +230,7 @@ static int act8865_pdata_from_dt(struct device *dev,
 	if (!pdata->regulators)
 		return -ENOMEM;
 
-	pdata->num_regulators = matched;
+	pdata->num_regulators = ARRAY_SIZE(act8865_matches);
 	regulator = pdata->regulators;
 
 	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
-- 
1.7.10.4

