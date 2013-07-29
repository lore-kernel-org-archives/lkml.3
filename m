Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3G2If5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:35:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40476 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3G2If4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:35:56 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/1] pinctrl: sunxi: Fix incorrect NULL check
Date: Mon, 29 Jul 2013 13:49:32 +0530
Message-Id: <1375085972-657-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*map should be tested for NULL instead of map as kmalloc pointer
is assigned to it. This also fixes a potential null pointer dereference
bug later in the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index c47fd1e..3655a5a 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -175,7 +175,7 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	}
 
 	*map = kmalloc(nmaps * sizeof(struct pinctrl_map), GFP_KERNEL);
-	if (!map)
+	if (!*map)
 		return -ENOMEM;
 
 	of_property_for_each_string(node, "allwinner,pins", prop, group) {
-- 
1.7.9.5

