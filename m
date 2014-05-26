Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaEZPUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:20:48 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57372 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaEZPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:20:46 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: benoit.taine@lip6.fr, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 18/18] pinctrl: pinconf-generic: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:27 +0200
Message-Id: <1401117687-28911-19-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Not compile tested, due incompatible architecture.

 drivers/pinctrl/pinconf-generic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 3d9a999..2457ca9 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -228,13 +228,12 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 	 * Now limit the number of configs to the real number of
 	 * found properties.
 	 */
-	*configs = kzalloc(ncfg * sizeof(unsigned long), GFP_KERNEL);
+	*configs = kmemdup(cfg, ncfg * sizeof(unsigned long), GFP_KERNEL);
 	if (!*configs) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(*configs, cfg, ncfg * sizeof(unsigned long));
 	*nconfigs = ncfg;
 
 out:

