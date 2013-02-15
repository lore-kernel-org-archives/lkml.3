Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3BOTcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:32:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:54096 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3BOTcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:32:52 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19M1ilOKRZMejSOL52Cn+JLQ4pblCN6/liBgkOkRf
	xG1ae2lJlVAjzY
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging/xgifb: Remove code without effect
Date: Fri, 15 Feb 2013 20:37:11 +0100
Message-Id: <1360957033-11876-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tempal variable is assigned and then immediately overwritten.
-> remove everything without effect.

The inb is kept for possible side effects.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index f5a9bb2..a602d43 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1778,14 +1778,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		}
 	} /* {End of VB} */
 
-	tempal = inb((pVBInfo->P3ca + 0x02));
-	tempal = tempal >> 2;
-	tempal &= 0x03;
-
-	/* for Dot8 Scaling LCD */
-	if ((pVBInfo->LCDInfo & EnableScalingLCD) && (modeflag & Charx8Dot))
-		tempal = tempal ^ tempal; /* ; set to VCLK25MHz always */
-
+	inb((pVBInfo->P3ca + 0x02));
 	tempal = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
 	return tempal;
 }
-- 
1.7.8.6

