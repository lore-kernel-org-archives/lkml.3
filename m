Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaDXNui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:50:38 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37951 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbaDXNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:50:36 -0400
Message-ID: <5359165F.5040102@icomera.com>
Date: Thu, 24 Apr 2014 15:49:19 +0200
From: gundberg <per.gundberg@icomera.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: kempld-wdt: Use the correct value when configuring
 the prescaler with the watchdog
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the prescaler index, rather than its value, to configure the watchdog.
This will prevent a mismatch with the prescaler used to calculate the cycles.

Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
---
 drivers/watchdog/kempld_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- src/drivers/watchdog/kempld_wdt.c.orig	2014-04-24 07:32:08.463745055 +0000
+++ src/drivers/watchdog/kempld_wdt.c	2014-04-24 07:34:09.839739808 +0000
@@ -163,7 +163,7 @@ static int kempld_wdt_set_stage_timeout(
 	kempld_get_mutex(pld);
 	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
 	stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
-	stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
+	stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
 	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
 	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
 			stage_timeout);
