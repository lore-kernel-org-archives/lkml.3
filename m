Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaJHNpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:45:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52424 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaJHNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:45:53 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse support
Date: Wed,  8 Oct 2014 15:44:03 +0200
Message-Id: <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core allows boards to define an initial operating mode to
be used as a default for regulators. With board files and platform data,
it is possible to fill a struct regulation_constraints .initial_mode to
set an initial mode for each regulator.

But currently there isn't a way to do the same with DeviceTrees. Argubly
the operating modes are Linux-specific so that information should not be
in the DT which should be used to only describe hardware. But regulators
having different operating modes is also a hardware property since many
PMICs have support to set different modes for their regulators.

So, the generic REGULATOR_MODE_{FAST,NORMAL,IDLE,STANDBY} modes can be
used to describe different level of power efficiency required for each
regulator and drivers can map those levels to the real modes supported
by the hardware as stated on their data-sheet.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/of_regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 18236be..a076b7f 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -93,6 +93,9 @@ static void of_get_regulation_constraints(struct device_node *np,
 		};
 	}
 
+	if (!of_property_read_u32(np, "regulator-initial-mode", &pval))
+		constraints->initial_mode = pval;
+
 	for (i = 0; i < ARRAY_SIZE(regulator_states); i++) {
 		switch (i) {
 		case PM_SUSPEND_MEM:
-- 
2.1.0

