Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaLUVRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:17:45 -0500
Received: from sauhun.de ([89.238.76.85]:52947 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaLUVPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:50 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 22/28] watchdog: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:43 +0100
Message-Id: <1419196495-9626-23-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/watchdog/cadence_wdt.c | 1 -
 drivers/watchdog/meson_wdt.c   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/watchdog/cadence_wdt.c b/drivers/watchdog/cadence_wdt.c
index 5927c0a98a74..bcfd2a22208f 100644
--- a/drivers/watchdog/cadence_wdt.c
+++ b/drivers/watchdog/cadence_wdt.c
@@ -503,7 +503,6 @@ static struct platform_driver cdns_wdt_driver = {
 	.shutdown	= cdns_wdt_shutdown,
 	.driver		= {
 		.name	= "cdns-wdt",
-		.owner	= THIS_MODULE,
 		.of_match_table = cdns_wdt_of_match,
 		.pm	= &cdns_wdt_pm_ops,
 	},
diff --git a/drivers/watchdog/meson_wdt.c b/drivers/watchdog/meson_wdt.c
index ef6a298e8c45..1f4155ee3404 100644
--- a/drivers/watchdog/meson_wdt.c
+++ b/drivers/watchdog/meson_wdt.c
@@ -215,7 +215,6 @@ static struct platform_driver meson_wdt_driver = {
 	.remove		= meson_wdt_remove,
 	.shutdown	= meson_wdt_shutdown,
 	.driver		= {
-		.owner		= THIS_MODULE,
 		.name		= DRV_NAME,
 		.of_match_table	= meson_wdt_dt_ids,
 	},
-- 
2.1.3

