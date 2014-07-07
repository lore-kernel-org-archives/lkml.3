Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaGGXyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaGGXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aybuke Ozdemir <aybuke.147@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 3.15 101/122] staging: tidspbridge: fix an erroneous removal of parentheses
Date: Mon,  7 Jul 2014 16:57:43 -0700
Message-Id: <20140707235737.277677310@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit ff4f58f0ca5dee33a80a72393dd195de9284702b upstream.

Commit 4a9fdbb (staging: core: tiomap3430.c Fix line over 80 characters.)
erroneously removed the parentheses around the function pointer leading
to the following build error (when enabling the build of TI DSP/Bridge
driver):

drivers/staging/tidspbridge/core/tiomap3430.c: In function 'bridge_brd_monitor':
drivers/staging/tidspbridge/core/tiomap3430.c:283:10: error: invalid type argument of unary '*' (have 'u32')
make[3]: *** [drivers/staging/tidspbridge/core/tiomap3430.o] Error 1

Fix this build error properly.

Fixes: 4a9fdbb (staging: core: tiomap3430.c Fix line over 80 characters.)
Cc: Aybuke Ozdemir <aybuke.147@gmail.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/tidspbridge/core/tiomap3430.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -280,8 +280,10 @@ static int bridge_brd_monitor(struct bri
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 
 		/* Wait until the state has moved to ON */
-		while (*pdata->dsp_prm_read(OMAP3430_IVA2_MOD, OMAP2_PM_PWSTST)&
-					OMAP_INTRANSITION_MASK);
+		while ((*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
+					      OMAP2_PM_PWSTST) &
+						OMAP_INTRANSITION_MASK)
+			;
 		/* Disable Automatic transition */
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_DISABLE_AUTO,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);


