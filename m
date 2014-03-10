Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaCJRm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:42:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51542 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaCJRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:42:24 -0400
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Mon, 10 Mar 2014 17:42:14 +0000
Message-Id: <1394473334-22049-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm5102: Mark register write sequencer control 3 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

During init the core checks if the wm5102 has finished starting by reading
register 0x19 and looking at the value. This read always fails since this
is not a readable register, mark it as being one. While we're at it provide
a constant for the register name (as supplied by Charles Keepax).

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/arizona-core.c            | 3 ++-
 drivers/mfd/wm5102-tables.c           | 1 +
 include/linux/mfd/arizona/registers.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1c3ae57082ed..d4919fa2797a 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -745,7 +745,8 @@ int arizona_dev_init(struct arizona *arizona)
 	/* Ensure device startup is complete */
 	switch (arizona->type) {
 	case WM5102:
-		ret = regmap_read(arizona->regmap, 0x19, &val);
+		ret = regmap_read(arizona->regmap,
+				  ARIZONA_WRITE_SEQUENCER_CTRL_3, &val);
 		if (ret != 0)
 			dev_err(dev,
 				"Failed to check write sequencer state: %d\n",
diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index f4668d39e542..e32736c3ab57 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1016,6 +1016,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
 	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
 	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
+	case ARIZONA_WRITE_SEQUENCER_CTRL_3:
 	case ARIZONA_WRITE_SEQUENCER_PROM:
 	case ARIZONA_TONE_GENERATOR_1:
 	case ARIZONA_TONE_GENERATOR_2:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 90d57aec34e7..f6ad81e923ac 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -27,6 +27,7 @@
 #define ARIZONA_WRITE_SEQUENCER_CTRL_0           0x16
 #define ARIZONA_WRITE_SEQUENCER_CTRL_1           0x17
 #define ARIZONA_WRITE_SEQUENCER_CTRL_2           0x18
+#define ARIZONA_WRITE_SEQUENCER_CTRL_3           0x19
 #define ARIZONA_WRITE_SEQUENCER_PROM             0x1A
 #define ARIZONA_TONE_GENERATOR_1                 0x20
 #define ARIZONA_TONE_GENERATOR_2                 0x21
-- 
1.9.0

