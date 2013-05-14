Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3ENPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:00:26 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44811 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3ENPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:00:24 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: John Crispin <blogic@openwrt.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl/lantiq: Free mapping configs for both pin and groups
Date: Tue, 14 May 2013 17:00:38 +0200
Message-Id: <1368543638-3299-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating mappings from DT both pin config and group config mappings
are allocated. Free them both when destroying the mappings.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/pinctrl-lantiq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
index 615c500..d22ca25 100644
--- a/drivers/pinctrl/pinctrl-lantiq.c
+++ b/drivers/pinctrl/pinctrl-lantiq.c
@@ -52,7 +52,8 @@ static void ltq_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
 	int i;
 
 	for (i = 0; i < num_maps; i++)
-		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN ||
+		    map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
 			kfree(map[i].data.configs.configs);
 	kfree(map);
 }
-- 
Regards,

Laurent Pinchart

