Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3AMRpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab3AMRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:44 -0500
Message-Id: <20130113174301.845221826@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Prisk <linux@prisktech.co.nz>, Edgar Toernig <froese@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 29/49] drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit 532db570e5181abc8f4f7bfa6c77c69ec2240198 upstream.

Control register bitfield for 12H/24H mode is handled incorrectly.
Setting CR_24H actually enables 12H mode.  This patch renames the define
and changes the initialization code to correctly set 24H mode.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Edgar Toernig <froese@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-vt8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index fd14187..737addf 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -70,7 +70,7 @@
 				| ALARM_SEC_BIT)
 
 #define VT8500_RTC_CR_ENABLE	(1 << 0)	/* Enable RTC */
-#define VT8500_RTC_CR_24H	(1 << 1)	/* 24h time format */
+#define VT8500_RTC_CR_12H	(1 << 1)	/* 12h time format */
 #define VT8500_RTC_CR_SM_ENABLE	(1 << 2)	/* Enable periodic irqs */
 #define VT8500_RTC_CR_SM_SEC	(1 << 3)	/* 0: 1Hz/60, 1: 1Hz */
 #define VT8500_RTC_CR_CALIB	(1 << 4)	/* Enable calibration */
@@ -247,7 +247,7 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
-	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H,
+	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
 	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,


