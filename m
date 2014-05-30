Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaE3KXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:23:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63870 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaE3KXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:23:17 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: sunxi: Fix potential null pointer dereference
Date: Fri, 30 May 2014 15:50:52 +0530
Message-Id: <1401445252-21413-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc can fail. Add a null check to avoid null pointer
dereference error while accessing the pointer later.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index f1ca75e6d7b1..5f38c7f67834 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -211,6 +211,10 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 			configlen++;
 
 		pinconfig = kzalloc(configlen * sizeof(*pinconfig), GFP_KERNEL);
+		if (!pinconfig) {
+			kfree(*map);
+			return -ENOMEM;
+		}
 
 		if (!of_property_read_u32(node, "allwinner,drive", &val)) {
 			u16 strength = (val + 1) * 10;
-- 
1.7.9.5

