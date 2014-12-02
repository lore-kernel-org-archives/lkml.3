Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaLBRNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:13:22 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60854 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbaLBRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:12:17 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net,
        arnd@arndb.de, sre@kernel.org, fkan@apm.com, mark.rutland@arm.com
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v3 1/3] power: reset: adjust priority of simple syscon reboot driver
Date: Tue,  2 Dec 2014 18:11:58 +0100
Message-Id: <1417540320-2385-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417540320-2385-1-git-send-email-stefan@agner.ch>
References: <1417540320-2385-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all restart handler use the priority 128, including
watchdogs. Probably most SoC have a watchdog, and some of them
register it also as a restart handler. But if a SoC specifies
a dedicated reboot capability using this syscon driver, this is
usually the preferred reboot method. Hence, raise the priority
of this driver to 192.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/power/reset/syscon-reboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
index 815b901..c4049f4 100644
--- a/drivers/power/reset/syscon-reboot.c
+++ b/drivers/power/reset/syscon-reboot.c
@@ -68,7 +68,7 @@ static int syscon_reboot_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	ctx->restart_handler.notifier_call = syscon_restart_handle;
-	ctx->restart_handler.priority = 128;
+	ctx->restart_handler.priority = 192;
 	err = register_restart_handler(&ctx->restart_handler);
 	if (err)
 		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
-- 
2.1.3

