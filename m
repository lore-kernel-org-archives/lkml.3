Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3LGNJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:09:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701Ab3LGNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:09:06 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
Date: Sat,  7 Dec 2013 14:08:53 +0100
Message-Id: <1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When passing a not initialized config parameter, at91_pinconf_get() would return
a bogus value. Fix that by initializing it to zero before using it.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinctrl-at91.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 6446dc804aa7..b0b78f3468ae 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -722,7 +722,8 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
 	unsigned pin;
 	int div;
 
-	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, *config);
+	*config = 0;
+	dev_dbg(info->dev, "%s:%d, pin_id=%d", __func__, __LINE__, pin_id);
 	pio = pin_to_controller(info, pin_to_bank(pin_id));
 	pin = pin_id % MAX_NB_GPIO_PER_BANK;
 
-- 
1.8.3.2

