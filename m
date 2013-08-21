Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3HUIa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:30:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3HUIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:30:58 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <notasas@gmail.com>
Subject: [PATCH] power: twl4030-charger: Fix compiler warning with regulator_enable()
Date: Wed, 21 Aug 2013 11:31:37 +0300
Message-ID: <1377073897-5165-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of regulator_enable need to be checked. This patch fixes
the following warning:
drivers/power/twl4030_charger.c: In function ‘twl4030_charger_enable_usb’:
drivers/power/twl4030_charger.c:192:20: warning: ignoring return value of ‘regulator_enable’, declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/power/twl4030_charger.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index be98e70..d98abe9 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -189,7 +189,12 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 
 		/* Need to keep regulator on */
 		if (!bci->usb_enabled) {
-			regulator_enable(bci->usb_reg);
+			ret = regulator_enable(bci->usb_reg);
+			if (ret) {
+				dev_err(bci->dev,
+					"Failed to enable regulator\n");
+				return ret;
+			}
 			bci->usb_enabled = 1;
 		}
 
-- 
1.8.3.2

