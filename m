Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaBWOZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:25:18 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58838 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaBWOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:27 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/16] pinctrl: mvebu: armada-38x: provide generic mpp callbacks
Date: Sun, 23 Feb 2014 15:21:09 +0100
Message-Id: <1393165274-32492-12-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks that use generic mpp pins helper
and will be used later.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- also take care of new Armada 38x pinctrl driver
- use generic mpp helpers (Suggested by Thomas Petazzoni)

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
index b3aa85e39a22..8b0455777a94 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
@@ -22,6 +22,18 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
+static int armada_38x_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	return default_mpp_ctrl_get(mpp_base, pid, config);
+}
+
+static int armada_38x_mpp_ctrl_set(unsigned pid, unsigned long config)
+{
+	return default_mpp_ctrl_set(mpp_base, pid, config);
+}
+
 enum {
 	V_88F6810 = BIT(0),
 	V_88F6820 = BIT(1),
-- 
1.8.5.3

