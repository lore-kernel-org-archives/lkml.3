Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3IYAQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3IYAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 056/110] pinctrl: at91: fix get_pullup/down function return
Date: Tue, 24 Sep 2013 17:14:54 -0700
Message-Id: <20130925001329.479106483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <b.brezillon@overkiz.com>

commit 05d3534a321d7fe4524b3b83bb20318282f3ec2c upstream.

In PIO_PUSR and PIO_PPDSR register if a given bit is set 1 this means the
pullup/down for this pin (pin is represented as a bit position) is
disabled.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -325,7 +325,7 @@ static void at91_mux_disable_interrupt(v
 
 static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
 {
-	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
+	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
 }
 
 static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
@@ -445,7 +445,7 @@ static void at91_mux_pio3_set_debounce(v
 
 static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
 {
-	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
+	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
 }
 
 static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)


