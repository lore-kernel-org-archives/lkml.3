Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJIT7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:59:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58290 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:59:19 -0400
From: Carlo Caione <carlo@caione.org>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@roeck-us.net, b.galvani@gmail.com
Cc: Carlo Caione <carlo@caione.org>
Subject: [PATCH] ARM: meson: watchdog: remove magic value for reboot
Date: Thu,  9 Oct 2014 21:59:16 +0200
Message-Id: <1412884756-20943-1-git-send-email-carlo@caione.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the magic value used for rebooting the board. This
value is useless and leads to a static checker warning as reported by
Dan Carpenter.

Signed-off-by: Carlo Caione <carlo@caione.org>
---
 drivers/watchdog/meson_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/meson_wdt.c b/drivers/watchdog/meson_wdt.c
index 37f9f5ec..ef6a298 100644
--- a/drivers/watchdog/meson_wdt.c
+++ b/drivers/watchdog/meson_wdt.c
@@ -51,7 +51,7 @@ struct meson_wdt_dev {
 static int meson_restart_handle(struct notifier_block *this, unsigned long mode,
 				void *cmd)
 {
-	u32 tc_reboot = MESON_WDT_DC_RESET | MESON_WDT_TC_EN | 100;
+	u32 tc_reboot = MESON_WDT_DC_RESET | MESON_WDT_TC_EN;
 	struct meson_wdt_dev *meson_wdt = container_of(this,
 						       struct meson_wdt_dev,
 						       restart_handler);
-- 
1.9.1

