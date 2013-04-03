Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3DCUP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:15:59 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:58734 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762579Ab3DCUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:15:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/abx500: fix ab9540 alternate function
Date: Wed, 3 Apr 2013 22:15:44 +0200
Message-ID: <1365020144-28781-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

This fix allows to correctly select default and
alternate pin mode.

By default for all ABx500 family chip, pin default
mode is selected by clearing corresponding bit in
GPIOSELx register except for pins which support
alternate function, in this case, corresponding bit
must be set.

But, due to an unlogical hardware implementation,
for one particular pin (GPIO11) reverse setting
must be done. For that, update the alternate function
array by declaring that this pin supports alternate
function.
Same issue has been fixed in pinctrl-ab8505.c

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-ab9540.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
index 7610bd0..80f3173 100644
--- a/drivers/pinctrl/pinctrl-ab9540.c
+++ b/drivers/pinctrl/pinctrl-ab9540.c
@@ -393,7 +393,7 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
 	/* GPIOSEL2 - bits 0 and 3 are reserved */
 	ALTERNATE_FUNCTIONS(9, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO9 */
 	ALTERNATE_FUNCTIONS(10,      1,      0, UNUSED, 1, 0, 0), /* GPIO10, altA and altB controlled by bit 0 */
-	ALTERNATE_FUNCTIONS(11,      2, UNUSED, UNUSED, 0, 0, 0), /* GPIO11, altA controlled by bit 1 */
+	ALTERNATE_FUNCTIONS(11,      2,	     1, UNUSED, 0, 0, 0), /* GPIO11, altA controlled by bit 1 */
 	ALTERNATE_FUNCTIONS(12, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO12 */
 	ALTERNATE_FUNCTIONS(13,      4,      3,      4, 1, 0, 2), /* GPIO13, altA altB and altC controlled by bit 3 and 4 */
 	ALTERNATE_FUNCTIONS(14,      5, UNUSED, UNUSED, 0, 0, 0), /* GPIO14, altA controlled by bit 5 */
-- 
1.7.11.3

