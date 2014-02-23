Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaBWOV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:21:28 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56932 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaBWOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:25 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/16] pinctrl: mvebu: remove obsolete per-control name buffer allocation
Date: Sun, 23 Feb 2014 15:21:00 +0100
Message-Id: <1393165274-32492-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of a global name buffer, we can now remove
the allocation and preparation of per-control name buffers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index d47650fc5119..c0e27e4f8953 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -636,7 +636,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 	pctl->desc.npins = 0;
 	for (n = 0; n < soc->ncontrols; n++) {
 		struct mvebu_mpp_ctrl *ctrl = &soc->controls[n];
-		char *names;
 
 		pctl->desc.npins += ctrl->npins;
 		/* initial control pins */
@@ -654,14 +653,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		}
 
 		/* generic mvebu register control */
-		names = devm_kzalloc(&pdev->dev, ctrl->npins * 8, GFP_KERNEL);
-		if (!names) {
-			dev_err(&pdev->dev, "failed to alloc mpp names\n");
-			return -ENOMEM;
-		}
-		for (k = 0; k < ctrl->npins; k++)
-			sprintf(names + 8*k, "mpp%d", ctrl->pid+k);
-		ctrl->name = names;
 		pctl->num_groups += ctrl->npins;
 		noname += ctrl->npins;
 	}
-- 
1.8.5.3

