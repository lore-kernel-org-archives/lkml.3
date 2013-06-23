Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3FWAsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 20:48:41 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47162 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3FWAsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 20:48:39 -0400
Message-ID: <1371948514.9509.1.camel@phoenix>
Subject: [PATCH] pinctrl: rockchip: Add missing irq_gc_unlock() call before
 return error
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Jun 2013 08:48:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 427564f..1eb5a2e 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1035,6 +1035,7 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 		polarity &= ~mask;
 		break;
 	default:
+		irq_gc_unlock(gc);
 		return -EINVAL;
 	}
 
-- 
1.8.1.2



