Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaHTDMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:12:09 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:36241 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaHTDMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:12:07 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org (open list:WATCHDOG DEVICE D...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] booke_wdt: Fix build failure as a module
Date: Tue, 19 Aug 2014 23:12:07 -0400
Message-Id: <1408504328-11324-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building booke_wdt fails when trying to build as a module as there is no
early_param() in module. Fix by enclosing within MODULE check.

Also remove notrace attribute as it is implicit in the __init attribute.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/watchdog/booke_wdt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 08a7853..8a26b54 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -41,8 +41,9 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
+#ifndef MODULE
 /* Checks wdt=x and wdt_period=xx command-line option */
-notrace int __init early_parse_wdt(char *p)
+int __init early_parse_wdt(char *p)
 {
 	if (p && strncmp(p, "0", 1) != 0)
 		booke_wdt_enabled = 1;
@@ -63,6 +64,8 @@ int __init early_parse_wdt_period(char *p)
 }
 early_param("wdt_period", early_parse_wdt_period);
 
+#endif /* #ifndef MODULE */
+
 #ifdef CONFIG_PPC_FSL_BOOK3E
 
 /* For the specified period, determine the number of seconds
-- 
1.9.1

