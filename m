Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3A3TkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:40:25 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:35749 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792Ab3A3TkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:40:20 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] pinctrl/abx500: replace incorrect return value
Date: Wed, 30 Jan 2013 20:40:06 +0100
Message-ID: <1359574806-15661-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Currently in the empty abx500_pin_config_get() function, we're
returning -EINVAL, with a comment stating that the reason for the
failure is that the function isn't implemented yet. Well there's
a proper return code for that. If we use it, we can do away with
the comment too, as it would be implied.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 539c9bb..305a9cb 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -971,8 +971,7 @@ int abx500_pin_config_get(struct pinctrl_dev *pctldev,
 		       unsigned pin,
 		       unsigned long *config)
 {
-	/* Not implemented */
-	return -EINVAL;
+	return -ENOSYS;
 }
 
 int abx500_pin_config_set(struct pinctrl_dev *pctldev,
-- 
1.7.11.3

