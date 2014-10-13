Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaJMUup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:50:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50936 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaJMUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:50:44 -0400
From: Felipe Balbi <balbi@ti.com>
To: <linus.walleij@linaro.org>
CC: David Cohen <david.a.cohen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] pinctrl: baytrail: add missing module removal support
Date: Mon, 13 Oct 2014 15:50:08 -0500
Message-ID: <1413233408-31923-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl-baytrail driver provides a proper ->remove()
method on its platform_driver definition, however there's
no way, currently, to unload the driver due to missing
module_exit(). This patch adds module_exit().

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e12e5b0..3ece001 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -612,5 +612,10 @@ static int __init byt_gpio_init(void)
 {
 	return platform_driver_register(&byt_gpio_driver);
 }
-
 subsys_initcall(byt_gpio_init);
+
+static void __exit byt_gpio_exit(void)
+{
+	platform_driver_unregister(&byt_gpio_driver);
+}
+module_exit(byt_gpio_exit);
-- 
2.1.0.GIT

