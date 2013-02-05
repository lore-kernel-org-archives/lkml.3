Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3BETte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:34 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:35997 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756753Ab3BETtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:24 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, <arm@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 13/14] ARM: ux500: enable AB8500 GPIO for HREF
Date: Tue, 5 Feb 2013 20:48:34 +0100
Message-ID: <1360093715-6348-14-git-send-email-linus.walleij@stericsson.com>
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
when booting HREF with Device Tree enabled.

Cc: arm@kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting an ACK from the ARM SoC maintainers on this patch.
---
 arch/arm/boot/dts/hrefprev60.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
index eec29c4..0c2b975 100644
--- a/arch/arm/boot/dts/hrefprev60.dts
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -25,6 +25,14 @@
 	};
 
 	soc-u9500 {
+		prcmu@80157000 {
+			ab8500@5 {
+				ab8500-gpio {
+					compatible = "stericsson,ab8500-gpio";
+				};
+			};
+		};
+
 		i2c@80004000 {
 			tps61052@33 {
 				compatible = "tps61052";
-- 
1.7.11.3

