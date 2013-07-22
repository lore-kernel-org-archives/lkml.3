Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3GVXpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:45:49 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38929 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3GVXps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:45:48 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        xulinuxkernel <xulinuxkernel@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: fix a memleak when freeing maps
Date: Tue, 23 Jul 2013 01:45:39 +0200
Message-Id: <1374536739-18966-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to free the node itself when free:ing a map.

Reported-by: xulinuxkernel <xulinuxkernel@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5b272bf..2a00239 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1193,6 +1193,7 @@ void pinctrl_unregister_map(struct pinctrl_map const *map)
 	list_for_each_entry(maps_node, &pinctrl_maps, node) {
 		if (maps_node->maps == map) {
 			list_del(&maps_node->node);
+			kfree(maps_node);
 			mutex_unlock(&pinctrl_maps_mutex);
 			return;
 		}
-- 
1.8.1.4

