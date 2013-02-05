Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3BETt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:28 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:50482 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab3BETtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:22 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/14] mfd: ab8500: ensure new AB8500 pinctrl driver is probed correctly
Date: Tue, 5 Feb 2013 20:48:24 +0100
Message-ID: <1360093715-6348-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

The old, BROKEN AB8500 GPIO driver has been revamped as a shiny
new pinctrl driver and has been renamed as such. So, if we would
like to make use of it, we need to register it via its new name.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, it'd be nice if you could ACK these first four patches,
the series basically simplifies things a lot by not cascading
the AB8500 IRQs and duplicate code in the pinctrl driver.
---
 drivers/mfd/ab8500-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index aa5937e..bad3fe2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1080,7 +1080,7 @@ static struct mfd_cell ab8500_bm_devs[] = {
 
 static struct mfd_cell ab8500_devs[] = {
 	{
-		.name = "ab8500-gpio",
+		.name = "pinctrl-ab8500",
 		.of_compatible = "stericsson,ab8500-gpio",
 	},
 	{
-- 
1.7.11.3

