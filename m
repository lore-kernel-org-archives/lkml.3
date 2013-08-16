Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3HPMWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:22:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54912 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab3HPMWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:22:53 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: <akpm@linux-foundation.org>, <khilman@linaro.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>, <a.zummo@towertech.it>,
        <rob@landley.net>, <grant.likely@linaro.org>,
        <rtc-linux@googlegroups.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH v4 1/2] rtc: omap: update of_device_id to reflect latest ip revisions
Date: Fri, 16 Aug 2013 17:51:53 +0530
Message-ID: <1376655714-28947-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1376655714-28947-1-git-send-email-gururaja.hebbar@ti.com>
References: <1376655714-28947-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syntax of compatible property in DT is to mention the Most specific
match to most generic match.

Since AM335x is the platform with latest IP revision, add it 1st in
the device id table.

This way, we can add new matching compatible as 1st and maintain old
compatible string for backwards compatibility.

ex:
	compatible = "ti,am3352-rtc", "ti,da830-rtc";

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
CC: mark.rutland@arm.com
---
Changes in V4:
	- Rebased on latest linux-next (as on 160813).
	- Correct a type AM335X --> AM3352

Changes in v3:
	- new patch

:100644 100644 dc62cc3... 2f0968c... M	drivers/rtc/rtc-omap.c
 drivers/rtc/rtc-omap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index dc62cc3..2f0968c 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -330,12 +330,12 @@ static struct platform_device_id omap_rtc_devtype[] = {
 MODULE_DEVICE_TABLE(platform, omap_rtc_devtype);
 
 static const struct of_device_id omap_rtc_of_match[] = {
-	{	.compatible	= "ti,da830-rtc",
-		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
-	},
 	{	.compatible	= "ti,am3352-rtc",
 		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM3352_IDX],
 	},
+	{	.compatible	= "ti,da830-rtc",
+		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
-- 
1.7.0.4

