Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3EJRqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:46:09 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:49751 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3EJRqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:46:07 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] pinctrl: vt8500: Fix incorrect data in WM8750 pinctrl table
Date: Sat, 11 May 2013 05:45:56 +1200
Message-Id: <1368207956-32220-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WMT_PIN_WAKEUP1 should be declared as WMT_PIN(0, 17) rather than
WMT_PIN(0, 16). This currently generates a runtime warning because
WMT_PIN_WAKEUP0 is already defined as WMT_PIN(0, 16).

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/pinctrl/vt8500/pinctrl-wm8750.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8750.c b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
index b964cc5..de43262 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wm8750.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
@@ -53,7 +53,7 @@ static const struct wmt_pinctrl_bank_registers wm8750_banks[] = {
 #define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
 #define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
 #define WMT_PIN_WAKEUP0		WMT_PIN(0, 16)
-#define WMT_PIN_WAKEUP1		WMT_PIN(0, 16)
+#define WMT_PIN_WAKEUP1		WMT_PIN(0, 17)
 #define WMT_PIN_SD0CD		WMT_PIN(0, 28)
 #define WMT_PIN_VDOUT0		WMT_PIN(1, 0)
 #define WMT_PIN_VDOUT1		WMT_PIN(1, 1)
-- 
1.7.9.5

