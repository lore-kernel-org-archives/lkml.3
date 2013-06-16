Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3FPLLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:11:49 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:50727 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149Ab3FPLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:11:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Heiko=20St=FCbner?= <heiko@sntech.de>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] pinctrl: establish pull-up/pull-down terminology
Date: Sun, 16 Jun 2013 12:45:48 +0200
Message-ID: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

It is counter-intuitive to have "0" mean disable in a boolean
manner for electronic properties of pins such as pull-up and
pull-down. Therefore, define that a pull-up/pull-down argument
of 0 to such a generic option means that the pin is
short-circuited to VDD or GROUND. Pull disablement shall be
done using PIN_CONFIG_BIAS_DISABLE.

Cc: Heiko Stübner <heiko@sntech.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/pinconf-generic.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index d414a77..67780f5 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -36,14 +36,15 @@
  *	tristate. The argument is ignored.
  * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
  *	impedance to VDD). If the argument is != 0 pull-up is enabled,
- *	if it is 0, pull-up is disabled.
+ *	if it is 0, pull-up it total, i.e. the pin is connected to VDD.
  * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
  *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
- *	if it is 0, pull-down is disabled.
+ *	if it is 0, pull-down is total, i.e. the pin is connected to GROUND.
  * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
  *	on embedded knowledge of the controller, like current mux function.
- *	If the argument is != 0 pull up/down is enabled, if it is 0,
- *	the pull is disabled.
+ *	If the argument is != 0 pull up/down is enabled, if it is 0, the
+ *	configuration is ignored. The proper way to disable it is to use
+ *	@PIN_CONFIG_BIAS_DISABLE.
  * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
  *	low, this is the most typical case and is typically achieved with two
  *	active transistors on the output. Setting this config will enable
@@ -72,8 +73,8 @@
  *	supplies, the argument to this parameter (on a custom format) tells
  *	the driver which alternative power source to use.
  * @PIN_CONFIG_SLEW_RATE: if the pin can select slew rate, the argument to
- * 	this parameter (on a custom format) tells the driver which alternative
- * 	slew rate to use.
+ *	this parameter (on a custom format) tells the driver which alternative
+ *	slew rate to use.
  * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
  *	operation, if several modes of operation are supported these can be
  *	passed in the argument on a custom form, else just use argument 1
-- 
1.7.11.3

