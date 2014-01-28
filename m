Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaA1Alw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:41:52 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36106 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaA1Ajp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:39:45 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/21] pinctrl: mvebu: remove checks for mpp_get/set
Date: Tue, 28 Jan 2014 01:39:20 +0100
Message-Id: <1390869573-27624-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, that name generation has been moved, we can identify generic mpp
ranges by NULL name. To allow further redesign, remove checks for SoC
specific callbacks mpp_get/set and use NULL name instead.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 375666b0abc3..2bec4ef30b48 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -637,18 +637,11 @@ int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base)
 		for (k = 0; k < ctrl->npins; k++)
 			ctrl->pins[k] = ctrl->pid + k;
 
-		/* special soc specific control */
-		if (ctrl->mpp_get || ctrl->mpp_set) {
-			if (!ctrl->name || !ctrl->mpp_get || !ctrl->mpp_set) {
-				dev_err(&pdev->dev, "wrong soc control info\n");
-				return -EINVAL;
-			}
+		/* generic mvebu register groups have no name passed */
+		if (!ctrl->name)
+			pctl->num_groups += ctrl->npins;
+		else
 			pctl->num_groups += 1;
-			continue;
-		}
-
-		/* generic mvebu register control */
-		pctl->num_groups += ctrl->npins;
 	}
 
 	pdesc = devm_kzalloc(&pdev->dev, pctl->desc.npins *
-- 
1.8.5.2

