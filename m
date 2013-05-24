Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3EXQW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:22:26 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59985 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab3EXQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:24 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 5/9] pinconf-generic: add BIAS_BUS_HOLD pinconf
Date: Fri, 24 May 2013 17:21:12 +0100
Message-ID: <1369412476-14245-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new PIN_CONFIG_BIAS_BUS_HOLD pin configuration for a bus holder
pin mode (also known as bus keeper, or repeater). This is a weak latch
which drives the last value on a tristate bus. Another device on the bus
can drive the bus high or low before going tristate to change the value
driven by the pin.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
Changes in v2:
 - add BIAS_BUS_HOLD generic pinconf (patch 5)

 drivers/pinctrl/pinconf-generic.c       | 1 +
 include/linux/pinctrl/pinconf-generic.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 33a5392..ba465b3 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -37,6 +37,7 @@ struct pin_config_item {
 static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL),
 	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL),
+	PCONFDUMP(PIN_CONFIG_BIAS_BUS_HOLD, "input bias bus hold", NULL),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", NULL),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_PUSH_PULL, "output drive push pull", NULL),
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 6aa2380..ac05b3c 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -29,6 +29,11 @@
  *	if for example some other pin is going to drive the signal connected
  *	to it for a while. Pins used for input are usually always high
  *	impedance.
+ * @PIN_CONFIG_BIAS_BUS_HOLD: the pin will be set to weakly latch so that it
+ *	weakly drives the last value on a tristate bus, also known as a "bus
+ *	holder", "bus keeper" or "repeater". This allows another device on the
+ *	bus to change the value by driving the bus high or low and switching to
+ *	tristate. The argument is ignored.
  * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
  *	impedance to VDD). If the argument is != 0 pull-up is enabled,
  *	if it is 0, pull-up is disabled.
@@ -78,6 +83,7 @@
 enum pin_config_param {
 	PIN_CONFIG_BIAS_DISABLE,
 	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
+	PIN_CONFIG_BIAS_BUS_HOLD,
 	PIN_CONFIG_BIAS_PULL_UP,
 	PIN_CONFIG_BIAS_PULL_DOWN,
 	PIN_CONFIG_DRIVE_PUSH_PULL,
-- 
1.8.1.2


