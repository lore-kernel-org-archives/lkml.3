Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3KFLdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:33:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45809 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3KFLdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:33:04 -0500
Message-ID: <527A28CE.2070802@ti.com>
Date: Wed, 6 Nov 2013 13:32:30 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Fwd: [PATCH 4/8] watchdog: davinci: add GET_STATUS option support
References: <1383680783-12114-5-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1383680783-12114-5-git-send-email-ivan.khoronzhuk@ti.com>
X-Forwarded-Message-Id: <1383680783-12114-5-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When watchdog timer is expired we can know about it thought
GET_STATUS ioctl option.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/watchdog/davinci_wdt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 6cbf2e1..a371b2d 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -144,6 +144,18 @@ static unsigned int davinci_wdt_get_timeleft(struct watchdog_device *wdd)
 	return wdd->timeout - timer_counter;
 }
 
+static unsigned int davinci_wdt_status(struct watchdog_device *wdd)
+{
+	u32 val;
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
+
+	val = ioread32(davinci_wdt->base + WDTCR);
+	if (val & WDFLAG)
+		return WDIOF_CARDRESET;
+
+	return 0;
+}
+
 static const struct watchdog_info davinci_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
@@ -155,6 +167,7 @@ static const struct watchdog_ops davinci_wdt_ops = {
 	.stop		= davinci_wdt_ping,
 	.ping		= davinci_wdt_ping,
 	.get_timeleft	= davinci_wdt_get_timeleft,
+	.status		= davinci_wdt_status,
 };
 
 static int davinci_wdt_probe(struct platform_device *pdev)
-- 
1.7.9.5



