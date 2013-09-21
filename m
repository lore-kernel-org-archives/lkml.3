Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3IUW2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:28:30 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62970 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3IUW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:28:29 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux@maxim.org.za
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 01/19] arm: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:33 +0200
Message-Id: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable pll_overclock is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/mach-at91/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 6b2630a..936480d 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -749,7 +749,7 @@ static int __init at91_pmc_init(unsigned long main_clock)
 {
 	unsigned tmp, freq, mckr;
 	int i;
-	int pll_overclock = false;
+	bool pll_overclock = false;
 
 	/*
 	 * When the bootloader initialized the main oscillator correctly,
-- 
1.8.3.1

