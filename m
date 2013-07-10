Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3GJQSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:18:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50004 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3GJQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:18:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/6] ARM: OMAP3: Enable Hardware Save and Restore for USB Host
Date: Wed, 10 Jul 2013 19:17:56 +0300
Message-ID: <1373473081-27181-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373473081-27181-1-git-send-email-rogerq@ti.com>
References: <1373473081-27181-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure hardware context is restored while resuming from
OFF mode we need to enable the Hardware SAR bit for the
USB Host power domain.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/powerdomains3xxx_data.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
index e2d4bd8..7b44d1f 100644
--- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
@@ -289,13 +289,7 @@ static struct powerdomain usbhost_pwrdm = {
 	.prcm_offs	  = OMAP3430ES2_USBHOST_MOD,
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.pwrsts_logic_ret = PWRSTS_RET,
-	/*
-	 * REVISIT: Enabling usb host save and restore mechanism seems to
-	 * leave the usb host domain permanently in ACTIVE mode after
-	 * changing the usb host power domain state from OFF to active once.
-	 * Disabling for now.
-	 */
-	/*.flags	  = PWRDM_HAS_HDWR_SAR,*/ /* for USBHOST ctrlr only */
+	.flags		  = PWRDM_HAS_HDWR_SAR, /* for USBHOST ctrlr only */
 	.banks		  = 1,
 	.pwrsts_mem_ret	  = {
 		[0] = PWRSTS_RET, /* MEMRETSTATE */
-- 
1.7.4.1

