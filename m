Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3C1L4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:56:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56920 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3C1L4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:56:04 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/3] pinctrl: use dev_info instead of pr_info in pinctrl_select_state_locked
Date: Thu, 28 Mar 2013 12:55:46 +0100
Message-Id: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove superfluous brackets.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
If it's not too late, it can be squashed with commit:
3102a76cfbf9ac4ae0cf54c7452f7ba4292a4760
"pinctrl: disable and free setting in select_state in case of error"

 drivers/pinctrl/core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 9b505acc..b98a275 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -912,9 +912,8 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 			break;
 		}
 
-		if (ret < 0) {
+		if (ret < 0)
 			goto unapply_new_state;
-		}
 	}
 
 	p->state = state;
@@ -922,7 +921,7 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 	return 0;
 
 unapply_new_state:
-	pr_info("Error applying setting, reverse things back\n");
+	dev_err(p->dev, "Error applying setting, reverse things back\n");
 
 	/*
 	 * If the loop stopped on the 1st entry, nothing has been enabled,
-- 
1.7.2.5

