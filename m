Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaHFEpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:45:55 -0400
Received: from s87.loopia.se ([194.9.94.112]:34198 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbaHFEnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 09/15] pinctrl: pinctrl-at91.c: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:43:16 -0700
Message-Id: <1407300196-32708-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/pinctrl/pinctrl-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index af1ba4f..60464a2 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -497,10 +497,10 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
 static void at91_pin_dbg(const struct device *dev, const struct at91_pmx_pin *pin)
 {
 	if (pin->mux) {
-		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lu\n",
+		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lx\n",
 			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A', pin->conf);
 	} else {
-		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lu\n",
+		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lx\n",
 			pin->bank + 'A', pin->pin, pin->conf);
 	}
 }
-- 
2.0.0.526.g5318336

