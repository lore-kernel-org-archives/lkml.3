Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3EXMHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:07:37 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42024 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3EXMHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:07:36 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 1/3] pinctrl: abx500: fix abx500_config_pull_updown
Date: Fri, 24 May 2013 14:06:29 +0200
Message-Id: <1369397191-16643-2-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Fix abx500_config_pull_updown() to set correct bit in
AB8540_GPIO_PULL_UPDOWN_REG.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index bbada4b..7d2e8d7 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -203,7 +203,7 @@ static int abx500_config_pull_updown(struct abx500_pinctrl *pct,
 		goto out;
 	}
 
-	pos = offset << 1;
+	pos = (offset - pullud->first_pin) << 1;
 
 	ret = abx500_mask_and_set_register_interruptible(pct->dev,
 			AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG,
-- 
1.7.10

