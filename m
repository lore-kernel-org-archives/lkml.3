Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3FFOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:44:34 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36203 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3FFOoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:44:30 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: add pinconf-generic define for a pin-default pull
Date: Thu, 6 Jun 2013 16:44:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306061644.26078.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exist controllers that don't support to set the pull to up or down
separately but instead automatically set the pull direction based on
embedded knowledge inside the controller, for example depending on the
selected mux function of the pin.

Therefore this patch adds another config option to use this default
pull-state for a pin where it is not possible to know or decide if the
pin will be pulled up or down.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
wasn't sure about the line-wrap preference there, as other lines too have
overlength, but the 100 chars length felt like to much

 drivers/pinctrl/pinconf-generic.c       |    2 ++
 include/linux/pinctrl/pinconf-generic.h |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index ba465b3..9a6812b 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -40,6 +40,8 @@ static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_BIAS_BUS_HOLD, "input bias bus hold", NULL),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", NULL),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", NULL),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_PIN_DEFAULT,
+				"input bias pull to pin specific state", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_PUSH_PULL, "output drive push pull", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_DRAIN, "output drive open drain", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_SOURCE, "output drive open source", NULL),
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index ac05b3c..d414a77 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -40,6 +40,10 @@
  * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
  *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
  *	if it is 0, pull-down is disabled.
+ * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
+ *	on embedded knowledge of the controller, like current mux function.
+ *	If the argument is != 0 pull up/down is enabled, if it is 0,
+ *	the pull is disabled.
  * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
  *	low, this is the most typical case and is typically achieved with two
  *	active transistors on the output. Setting this config will enable
@@ -86,6 +90,7 @@ enum pin_config_param {
 	PIN_CONFIG_BIAS_BUS_HOLD,
 	PIN_CONFIG_BIAS_PULL_UP,
 	PIN_CONFIG_BIAS_PULL_DOWN,
+	PIN_CONFIG_BIAS_PULL_PIN_DEFAULT,
 	PIN_CONFIG_DRIVE_PUSH_PULL,
 	PIN_CONFIG_DRIVE_OPEN_DRAIN,
 	PIN_CONFIG_DRIVE_OPEN_SOURCE,
-- 
1.7.2.3

