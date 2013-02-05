Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3BETty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:54 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42311 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab3BETte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, <arm@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/14] ARM: ux500: allow Snowball access to the AB8500 GPIO pins
Date: Tue, 5 Feb 2013 20:48:35 +0100
Message-ID: <1360093715-6348-15-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

The AB8500 GPIO driver has been un-BROKEN and rewritten as a pinctrl
driver. Now that it's back in use, let's ensure that it's available
when booting Snowball with Device Tree enabled.

Cc: arm@kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting an ACK from the ARM SoC maintainers on this patch.
---
 arch/arm/boot/dts/snowball.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 27f31a5..b095e85 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -299,6 +299,10 @@
 			};
 
 			ab8500@5 {
+				ab8500-gpio {
+					compatible = "stericsson,ab8500-gpio";
+				};
+
 				ab8500-regulators {
 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
 						regulator-name = "V-DISPLAY";
-- 
1.7.11.3

