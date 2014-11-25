Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaKYLiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:38:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40719 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaKYLiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:38:00 -0500
From: Juergen Borleis <jbe@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 2/2] RTC/i.MX/DryIce: add more known register bits
Date: Tue, 25 Nov 2014 12:37:48 +0100
Message-Id: <1416915468-20552-2-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416915468-20552-1-git-send-email-jbe@pengutronix.de>
References: <1416915468-20552-1-git-send-email-jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intended for monitoring and controlling the security features. These bits are
required to bring this unit back to live after a security violation event was
detected. The code to bring it back to live will follow after a vendor
clearance.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/rtc/rtc-imxdi.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index a2544f0..4e39f89 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -50,22 +50,58 @@
 #define DCAMR_UNSET  0xFFFFFFFF  /* doomsday - 1 sec */
 
 #define DCR       0x10           /* Control Reg */
+#define DCR_TDCHL (1 << 30)      /* Tamper-detect configuration hard lock */
+#define DCR_TDCSL (1 << 29)      /* Tamper-detect configuration soft lock */
+#define DCR_KSSL  (1 << 27)      /* Key-select soft lock */
+#define DCR_MCHL  (1 << 20)      /* Monotonic-counter hard lock */
+#define DCR_MCSL  (1 << 19)      /* Monotonic-counter soft lock */
+#define DCR_TCHL  (1 << 18)      /* Timer-counter hard lock */
+#define DCR_TCSL  (1 << 17)      /* Timer-counter soft lock */
+#define DCR_FSHL  (1 << 16)      /* Failure state hard lock */
 #define DCR_TCE   (1 << 3)       /* Time Counter Enable */
+#define DCR_MCE   (1 << 2)       /* Monotonic Counter Enable */
 
 #define DSR       0x14           /* Status Reg */
-#define DSR_WBF   (1 << 10)      /* Write Busy Flag */
-#define DSR_WNF   (1 << 9)       /* Write Next Flag */
-#define DSR_WCF   (1 << 8)       /* Write Complete Flag */
+#define DSR_WTD   (1 << 23)      /* Wire-mesh tamper detected */
+#define DSR_ETBD  (1 << 22)      /* External tamper B detected */
+#define DSR_ETAD  (1 << 21)      /* External tamper A detected */
+#define DSR_EBD   (1 << 20)      /* External boot detected */
+#define DSR_SAD   (1 << 19)      /* SCC alarm detected */
+#define DSR_TTD   (1 << 18)      /* Temperatur tamper detected */
+#define DSR_CTD   (1 << 17)      /* Clock tamper detected */
+#define DSR_VTD   (1 << 16)      /* Voltage tamper detected */
+#define DSR_WBF   (1 << 10)      /* Write Busy Flag (synchronous) */
+#define DSR_WNF   (1 << 9)       /* Write Next Flag (synchronous) */
+#define DSR_WCF   (1 << 8)       /* Write Complete Flag (synchronous)*/
 #define DSR_WEF   (1 << 7)       /* Write Error Flag */
 #define DSR_CAF   (1 << 4)       /* Clock Alarm Flag */
+#define DSR_MCO   (1 << 3)       /* monotonic counter overflow */
+#define DSR_TCO   (1 << 2)       /* time counter overflow */
 #define DSR_NVF   (1 << 1)       /* Non-Valid Flag */
 #define DSR_SVF   (1 << 0)       /* Security Violation Flag */
 
-#define DIER      0x18           /* Interrupt Enable Reg */
+#define DIER      0x18           /* Interrupt Enable Reg (synchronous) */
 #define DIER_WNIE (1 << 9)       /* Write Next Interrupt Enable */
 #define DIER_WCIE (1 << 8)       /* Write Complete Interrupt Enable */
 #define DIER_WEIE (1 << 7)       /* Write Error Interrupt Enable */
 #define DIER_CAIE (1 << 4)       /* Clock Alarm Interrupt Enable */
+#define DIER_SVIE (1 << 0)       /* Security-violation Interrupt Enable */
+
+#define DMCR      0x1c           /* DryIce Monotonic Counter Reg */
+
+#define DTCR      0x28           /* DryIce Tamper Configuration Reg */
+#define DTCR_MOE  (1 << 9)       /* monotonic overflow enabled */
+#define DTCR_TOE  (1 << 8)       /* time overflow enabled */
+#define DTCR_WTE  (1 << 7)       /* wire-mesh tamper enabled */
+#define DTCR_ETBE (1 << 6)       /* external B tamper enabled */
+#define DTCR_ETAE (1 << 5)       /* external A tamper enabled */
+#define DTCR_EBE  (1 << 4)       /* external boot tamper enabled */
+#define DTCR_SAIE (1 << 3)       /* SCC enabled */
+#define DTCR_TTE  (1 << 2)       /* temperature tamper enabled */
+#define DTCR_CTE  (1 << 1)       /* clock tamper enabled */
+#define DTCR_VTE  (1 << 0)       /* voltage tamper enabled */
+
+#define DGPR      0x3c           /* DryIce General Purpose Reg */
 
 /**
  * struct imxdi_dev - private imxdi rtc data
-- 
2.1.3

