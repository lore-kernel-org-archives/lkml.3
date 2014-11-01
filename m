Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaKADxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 23:53:22 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60023 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaKADxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 23:53:18 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: javier.martinez@collabora.co.uk, Heiko Stuebner <heiko@sntech.de>,
        Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] regulator: of: Add support for parsing microvolts for suspend state
Date: Fri, 31 Oct 2014 20:52:58 -0700
Message-Id: <1414813978-32233-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414813978-32233-1-git-send-email-dianders@chromium.org>
References: <1414813978-32233-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage all the work that was done in (40e20d6 regulator: of: Add
support for parsing regulator_state for suspend state) and throw in
the ability to set suspend microvolts from the device tree.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/regulator/of_regulator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f0d19fc..7fe93c5 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -107,6 +107,10 @@ static void of_get_regulation_constraints(struct device_node *np,
 					"regulator-off-in-suspend"))
 			suspend_state->disabled = true;
 
+		if (!of_property_read_u32(suspend_np,
+					"regulator-suspend-microvolt", &pval))
+			suspend_state->uV = pval;
+
 		of_node_put(suspend_np);
 		suspend_state = NULL;
 		suspend_np = NULL;
-- 
2.1.0.rc2.206.gedb03e5

