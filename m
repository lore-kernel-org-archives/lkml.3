Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031286AbaGDWV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:21:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031145AbaGDWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Per Gundberg <per.gundberg@icomera.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <michael.brunner@kontron.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 3.14 20/59] watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog
Date: Fri,  4 Jul 2014 15:19:09 -0700
Message-Id: <20140704221540.507915386@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gundberg <per.gundberg@icomera.com>

commit a9e0436b303e94ba57d3bd4b1fcbeaa744b7ebeb upstream.

Use the prescaler index, rather than its value, to configure the watchdog.
This will prevent a mismatch with the prescaler used to calculate the cycles.

Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
Tested-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/kempld_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -162,7 +162,7 @@ static int kempld_wdt_set_stage_timeout(
 	kempld_get_mutex(pld);
 	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
 	stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
-	stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
+	stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
 	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
 	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
 			stage_timeout);


