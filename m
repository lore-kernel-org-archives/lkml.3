Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3HSCGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:06:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57636 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3HSCGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:06:35 -0400
Message-ID: <1376877989.10251.2.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: core: Remove unnecessary test for desc->name
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 10:06:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in pinctrl_register_one_pin() ensures pindesc->name is always
not NULL before insert the pindesc to radix tree.
If the desc return from pin_desc_get is not NULL, desc->name is always not NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4adef2f..53c40d9 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -153,9 +153,7 @@ int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name)
 		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
 		/* Pin space may be sparse */
-		if (desc == NULL)
-			continue;
-		if (desc->name && !strcmp(name, desc->name))
+		if (desc && !strcmp(name, desc->name))
 			return pin;
 	}
 
-- 
1.8.1.2



