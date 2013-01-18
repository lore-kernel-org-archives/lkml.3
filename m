Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ARLlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:41:19 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54318 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3ARLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:41:17 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/4] mfd: dbx500-prcmu: export a9wdog functions
Date: Fri, 18 Jan 2013 12:40:12 +0100
Message-Id: <1358509214-22407-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXPORT_SYMBOL to db500_prcmu_*_a9wdog functions to allow usage from
module.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 268f45d..7a63fa8 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2212,21 +2212,25 @@ int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 			    sleep_auto_off ? A9WDOG_AUTO_OFF_EN :
 			    A9WDOG_AUTO_OFF_DIS);
 }
+EXPORT_SYMBOL(db8500_prcmu_config_a9wdog);
 
 int db8500_prcmu_enable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
 }
+EXPORT_SYMBOL(db8500_prcmu_enable_a9wdog);
 
 int db8500_prcmu_disable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
 }
+EXPORT_SYMBOL(db8500_prcmu_disable_a9wdog);
 
 int db8500_prcmu_kick_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
 }
+EXPORT_SYMBOL(db8500_prcmu_kick_a9wdog);
 
 /*
  * timeout is 28 bit, in ms.
@@ -2244,6 +2248,7 @@ int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 			    (u8)((timeout >> 12) & 0xff),
 			    (u8)((timeout >> 20) & 0xff));
 }
+EXPORT_SYMBOL(db8500_prcmu_load_a9wdog);
 
 /**
  * prcmu_abb_read() - Read register value(s) from the ABB.
-- 
1.7.12.1

