Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaBYN2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:28:54 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:41119 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaBYN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:28:43 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 2/2] mfd: twl6040: Remove duplicate register write
Date: Tue, 25 Feb 2014 14:28:20 +0100
Message-Id: <1393334900-29740-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
References: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When probing, regmap_register_patch() will bypass the cache and perform
i2c writes for the given patches. It is thus unnecessary to manually set
the TWL6040_REG_ACCCTL register just before, as it will be done when
registering the twl6040_patch.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/mfd/twl6040.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 67e524e..0bd5a18 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -710,7 +710,6 @@ static int twl6040_probe(struct i2c_client *client,
 	}
 
 	/* dual-access registers controlled by I2C only */
-	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
 	regmap_register_patch(twl6040->regmap, twl6040_patch,
 			      ARRAY_SIZE(twl6040_patch));
 
-- 
1.8.1.2

