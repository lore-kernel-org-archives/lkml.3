Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3HUC25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:28:57 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56665 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3HUC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:28:55 -0400
Message-ID: <1377052130.20078.0.camel@phoenix>
Subject: [PATCH] pinctrl: rockchip: Simplify for loop iteration
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Aug 2013 10:28:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just return once a match found makes the code simpler and shorter.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c22457d..64ad0c0 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -167,18 +167,14 @@ static const inline struct rockchip_pin_group *pinctrl_name_to_group(
 					const struct rockchip_pinctrl *info,
 					const char *name)
 {
-	const struct rockchip_pin_group *grp = NULL;
 	int i;
 
 	for (i = 0; i < info->ngroups; i++) {
-		if (strcmp(info->groups[i].name, name))
-			continue;
-
-		grp = &info->groups[i];
-		break;
+		if (!strcmp(info->groups[i].name, name))
+			return &info->groups[i];
 	}
 
-	return grp;
+	return NULL;
 }
 
 /*
@@ -204,17 +200,12 @@ static struct rockchip_pin_bank *bank_num_to_bank(
 	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
 	int i;
 
-	for (i = 0; i < info->ctrl->nr_banks; i++) {
+	for (i = 0; i < info->ctrl->nr_banks; i++, b++) {
 		if (b->bank_num == num)
-			break;
-
-		b++;
+			return b;
 	}
 
-	if (b->bank_num != num)
-		return ERR_PTR(-EINVAL);
-
-	return b;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
-- 
1.8.1.2



