Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3ITUOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3ITUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 34/93] pinctrl: at91: fix get_pullup/down function return
Date: Fri, 20 Sep 2013 13:08:29 -0700
Message-Id: <1379707768-1804-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <b.brezillon@overkiz.com>

commit 05d3534a321d7fe4524b3b83bb20318282f3ec2c upstream.

In PIO_PUSR and PIO_PPDSR register if a given bit is set 1 this means the
pullup/down for this pin (pin is represented as a bit position) is
disabled.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pinctrl/pinctrl-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 471c71f..d3234a6 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -326,7 +326,7 @@ static void at91_mux_disable_interrupt(void __iomem *pio, unsigned mask)
 
 static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
 {
-	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
+	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
 }
 
 static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
@@ -446,7 +446,7 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
 
 static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
 {
-	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
+	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
 }
 
 static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
-- 
1.8.1.2

