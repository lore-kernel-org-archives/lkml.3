Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaLPQ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:26:18 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64932 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaLPQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:26:13 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH 7/8] drivers: watchdog: Fixed missing blank line warning
Date: Tue, 16 Dec 2014 21:55:28 +0530
Message-Id: <1418747129-3766-7-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
References: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations to remove the warning:
'Missing blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/watchdog/at91sam9_wdt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 489729b..794a34a 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -82,6 +82,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 #define to_wdt(wdd) container_of(wdd, struct at91wdt, wdd)
 struct at91wdt {
 	struct watchdog_device wdd;
+
 	void __iomem *base;
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
 	struct timer_list timer;	/* The timer that pings the watchdog */
@@ -121,6 +122,7 @@ static inline void at91_wdt_reset(struct at91wdt *wdt)
 static void at91_ping(unsigned long data)
 {
 	struct at91wdt *wdt = (struct at91wdt *)data;
+
 	if (time_before(jiffies, wdt->next_heartbeat) ||
 	    !watchdog_active(&wdt->wdd)) {
 		at91_wdt_reset(wdt);
@@ -372,6 +374,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
 	struct at91wdt *wdt = platform_get_drvdata(pdev);
+
 	watchdog_unregister_device(&wdt->wdd);
 
 	pr_warn("I quit now, hardware will probably reboot!\n");
-- 
1.7.9.5

