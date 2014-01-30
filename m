Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaA3S5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:57:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33034 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaA3S5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:57:31 -0500
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu, 30 Jan 2014 18:57:20 +0000
Message-Id: <1391108240-16161-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.rc1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] pinctrl: Quiet logging about missing DT nodes when not using DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

On systems which were not booted using DT it is entirely unsurprising that
device nodes don't have any DT information and this is going to happen for
every single device in the system. Make pinctrl be less chatty about this
situation by only logging in the case where we have DT.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/pinctrl/devicetree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 340fb4e6c600..eda13de2e7c0 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -186,7 +186,9 @@ int pinctrl_dt_to_map(struct pinctrl *p)
 
 	/* CONFIG_OF enabled, p->dev not instantiated from DT */
 	if (!np) {
-		dev_dbg(p->dev, "no of_node; not parsing pinctrl DT\n");
+		if (of_have_populated_dt())
+			dev_dbg(p->dev,
+				"no of_node; not parsing pinctrl DT\n");
 		return 0;
 	}
 
-- 
1.9.rc1

