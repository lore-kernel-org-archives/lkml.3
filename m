Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaAVDPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:15:13 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:41501 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaAVDPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:15:09 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm@lists.infradead.org,
        mpa@pengutronix.de, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/2 v2] imx27: pinctrl: fix offset calculation in imx_read_2bit
Date: Wed, 22 Jan 2014 11:14:52 +0800
Message-Id: <1390360492-29126-2-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset for the 2bit register calculate wrong, this patch
fixes the problem. The debugfs printout for oconf, iconfa, iconfb
now shows the real values.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/pinctrl/pinctrl-imx1-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
index 8dfc3dc..59a16b6 100644
--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/pinctrl-imx1-core.c
@@ -139,7 +139,7 @@ static int imx1_read_2bit(struct imx1_pinctrl *ipctl, unsigned int pin_id,
 		u32 reg_offset)
 {
 	void __iomem *reg = imx1_mem(ipctl, pin_id) + reg_offset;
-	int offset = pin_id % 16;
+	int offset = (pin_id % 16) * 2;
 
 	/* Use the next register if the pin's port pin number is >=16 */
 	if (pin_id % 32 >= 16)
-- 
1.7.10.4

