Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaIWOtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:49:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58560 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932275AbaIWOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:48:51 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Acked-by: Arnd Bergmann" <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v9 02/10] rtc: at91sam9: use standard readl/writel functions instead of raw versions
Date: Tue, 23 Sep 2014 16:48:37 +0200
Message-Id: <1411483725-31532-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411483725-31532-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411483725-31532-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raw versions of writel and writel should not be directly used and should
be replaced by their relaxed versions (readl/writel_relaxed), which take
endianness conversion into account.

In this driver we prefer the standard readl/writel function which add the
appropriate memory barrier around the access (the performance penalty is
negligible for this kind of application).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Johan Hovold <johan@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
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

