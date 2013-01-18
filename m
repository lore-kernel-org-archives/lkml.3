Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3ARVar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:30:47 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:47041 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:30:46 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] pinctrl: pinconf-generic: add drive strength parameter
Date: Fri, 18 Jan 2013 22:30:33 +0100
Message-Id: <1358544639-14761-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some pin configurations IP allows to set the current output to the pin.
This patch adds such a parameter to the pinconf-generic mechanism.

This parameter takes as argument the drive strength in mA.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 include/linux/pinctrl/pinconf-generic.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 47a1bdd..c533789 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -46,6 +46,8 @@
  * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open source
  *	(open emitter). Sending this config will enabale open drain mode, the
  *	argument is ignored.
+ * @PIN_CONFIG_DRIVE_STRENGTH: the pin will output the current passed as
+ * 	argument. The argument is in mA.
  * @PIN_CONFIG_INPUT_SCHMITT_DISABLE: disable schmitt-trigger mode on the pin.
  * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
  *	schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
@@ -74,6 +76,7 @@ enum pin_config_param {
 	PIN_CONFIG_DRIVE_PUSH_PULL,
 	PIN_CONFIG_DRIVE_OPEN_DRAIN,
 	PIN_CONFIG_DRIVE_OPEN_SOURCE,
+	PIN_CONFIG_DRIVE_STRENGTH,
 	PIN_CONFIG_INPUT_SCHMITT_DISABLE,
 	PIN_CONFIG_INPUT_SCHMITT,
 	PIN_CONFIG_INPUT_DEBOUNCE,
-- 
1.7.10.4

