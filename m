Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaBWOVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:21:55 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:37668 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaBWOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:31 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 14/16] pinctrl: mvebu: remove MPP_REG_CTRL macro
Date: Sun, 23 Feb 2014 15:21:12 +0100
Message-Id: <1393165274-32492-15-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Now that each per-SoC pinctrl driver must implement its own get/set
functions, there is no point in keeping the MPP_REG_CTRL macro, whose
purpose was to let the core pinctrl mvebu driver use default get/set
functions. While at it also update the comment about mvebu_mpp_ctrl.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.h | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index c73f4eea62ac..65a98e6f7265 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -28,10 +28,9 @@
  * between two or more different settings, e.g. assign mpp pin 13 to
  * uart1 or sata.
  *
- * If optional mpp_get/_set functions are set these are used to get/set
- * a specific mode. Otherwise it is assumed that the mpp control is based
- * on 4-bit groups in subsequent registers. The optional mpp_gpio_req/_dir
- * functions can be used to allow pin settings with varying gpio pins.
+ * The mpp_get/_set functions are mandatory and are used to get/set a
+ * specific mode. The optional mpp_gpio_req/_dir functions can be used
+ * to allow pin settings with varying gpio pins.
  */
 struct mvebu_mpp_ctrl {
 	const char *name;
@@ -114,18 +113,6 @@ struct mvebu_pinctrl_soc_info {
 	int ngpioranges;
 };
 
-#define MPP_REG_CTRL(_idl, _idh)				\
-	{							\
-		.name = NULL,					\
-		.pid = _idl,					\
-		.npins = _idh - _idl + 1,			\
-		.pins = (unsigned[_idh - _idl + 1]) { },	\
-		.mpp_get = NULL,				\
-		.mpp_set = NULL,				\
-		.mpp_gpio_req = NULL,				\
-		.mpp_gpio_dir = NULL,				\
-	}
-
 #define MPP_FUNC_CTRL(_idl, _idh, _name, _func)			\
 	{							\
 		.name = _name,					\
-- 
1.8.5.3

