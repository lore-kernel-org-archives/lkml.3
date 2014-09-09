Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaIIJcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:32:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55343 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756094AbaIIJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:30:46 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 2/6] rtc: at91sam9: use standard readl/writel functions instead of raw versions
Date: Tue,  9 Sep 2014 11:30:31 +0200
Message-Id: <1410255035-26775-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410255035-26775-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410255035-26775-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/rtc/rtc-at91sam9.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 51f0038..74a9ca0 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -77,14 +77,14 @@ struct sam9_rtc {
 };
 
 #define rtt_readl(rtc, field) \
-	__raw_readl((rtc)->rtt + AT91_RTT_ ## field)
+	readl((rtc)->rtt + AT91_RTT_ ## field)
 #define rtt_writel(rtc, field, val) \
-	__raw_writel((val), (rtc)->rtt + AT91_RTT_ ## field)
+	writel((val), (rtc)->rtt + AT91_RTT_ ## field)
 
 #define gpbr_readl(rtc) \
-	__raw_readl((rtc)->gpbr)
+	readl((rtc)->gpbr)
 #define gpbr_writel(rtc, val) \
-	__raw_writel((val), (rtc)->gpbr)
+	writel((val), (rtc)->gpbr)
 
 /*
  * Read current time and date in RTC
-- 
1.9.1

