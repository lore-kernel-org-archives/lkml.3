Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbbAOV7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:59:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57588 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbbAOV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:52 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 09/17] ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage
Date: Thu, 15 Jan 2015 22:58:12 +0100
Message-Id: <1421359100-8930-10-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC_AT91SAM9263 is being removed, stop using it.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm_slowclock.S | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 20018779bae7..556151e85ec4 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -17,15 +17,6 @@
 #include <mach/hardware.h>
 #include <mach/at91_ramc.h>
 
-
-#ifdef CONFIG_SOC_AT91SAM9263
-/*
- * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
- * handle those cases both here and in the Suspend-To-RAM support.
- */
-#warning Assuming EB1 SDRAM controller is *NOT* used
-#endif
-
 /*
  * When SLOWDOWN_MASTER_CLOCK is defined we will also slow down the Master
  * clock during suspend by adjusting its prescalar and divisor.
-- 
2.1.0

