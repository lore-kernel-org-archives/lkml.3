Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3H2CFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:05:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35303 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H2CFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:05:12 -0400
Message-ID: <1377741906.16018.1.camel@phoenix>
Subject: [PATCH] pinctrl: pinconf-generic: Remove ti prefix in dev_err
 messages
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Aug 2013 10:05:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to show ti prefix in pinconf_generic_dt_subnode_to_map()
dev_err messages.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinconf-generic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 2c62225..55a0ebe 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -256,8 +256,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	if (ret < 0) {
 		/* EINVAL=missing, which is fine since it's optional */
 		if (ret != -EINVAL)
-			dev_err(dev,
-				"could not parse property ti,function\n");
+			dev_err(dev, "could not parse property function\n");
 		function = NULL;
 	}
 
@@ -274,7 +273,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		reserve++;
 	ret = of_property_count_strings(np, "pins");
 	if (ret < 0) {
-		dev_err(dev, "could not parse property ti,pins\n");
+		dev_err(dev, "could not parse property pins\n");
 		goto exit;
 	}
 	reserve *= ret;
-- 
1.8.1.2



