Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3JEOUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 10:20:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50023 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239Ab3JEOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 10:20:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: wim@iguana.be
Cc: linux-arm-kernel@lists.infradead.org, carlo.caione@gmail.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] wdt: sunxi: Fix section mismatch
Date: Sat,  5 Oct 2013 16:20:17 +0200
Message-Id: <1380982817-10234-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has a section mismatch, for probe and remove functions,
leading to the following warning during the compilation.

WARNING: drivers/watchdog/built-in.o(.data+0x24): Section mismatch in
reference from the variable sunxi_wdt_driver to the function
.init.text:sunxi_wdt_probe()
The variable sunxi_wdt_driver references
the function __init sunxi_wdt_probe()

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/watchdog/sunxi_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 1f94b42..f6caa77 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -146,7 +146,7 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
-static int __init sunxi_wdt_probe(struct platform_device *pdev)
+static int sunxi_wdt_probe(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt;
 	struct resource *res;
@@ -187,7 +187,7 @@ static int __init sunxi_wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit sunxi_wdt_remove(struct platform_device *pdev)
+static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-- 
1.8.4

