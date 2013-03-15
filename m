Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3COATy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:19:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55259 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3COATw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:19:52 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] power: lp8788: use PAGE_SIZE for the sysfs read operation
Thread-Topic: [PATCH] power: lp8788: use PAGE_SIZE for the sysfs read
 operation
Thread-Index: Ac4hEsHU4ytgQ+43T52sjcveEsnCwQ==
Date: Fri, 15 Mar 2013 00:19:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E48A0E@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs allocates PAGE_SIZE. It is used by each R/W operation method.
Use it instead of another buffer size.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 6d1f452..ed49b50 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -49,7 +49,6 @@
 #define LP8788_CHG_START		0x11
 #define LP8788_CHG_END			0x1C
 
-#define LP8788_BUF_SIZE			40
 #define LP8788_ISEL_MAX			23
 #define LP8788_ISEL_STEP		50
 #define LP8788_VTERM_MIN		4100
@@ -633,7 +632,7 @@ static ssize_t lp8788_show_charger_status(struct device *dev,
 	lp8788_read_byte(pchg->lp, LP8788_CHG_STATUS, &data);
 	state = (data & LP8788_CHG_STATE_M) >> LP8788_CHG_STATE_S;
 
-	return scnprintf(buf, LP8788_BUF_SIZE, "%s\n", desc[state]);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", desc[state]);
 }
 
 static ssize_t lp8788_show_eoc_time(struct device *dev,
@@ -647,7 +646,7 @@ static ssize_t lp8788_show_eoc_time(struct device *dev,
 	lp8788_read_byte(pchg->lp, LP8788_CHG_EOC, &val);
 	val = (val & LP8788_CHG_EOC_TIME_M) >> LP8788_CHG_EOC_TIME_S;
 
-	return scnprintf(buf, LP8788_BUF_SIZE, "End Of Charge Time: %s\n",
+	return scnprintf(buf, PAGE_SIZE, "End Of Charge Time: %s\n",
 			stime[val]);
 }
 
@@ -667,8 +666,7 @@ static ssize_t lp8788_show_eoc_level(struct device *dev,
 	val = (val & LP8788_CHG_EOC_LEVEL_M) >> LP8788_CHG_EOC_LEVEL_S;
 	level = mode ? abs_level[val] : relative_level[val];
 
-	return scnprintf(buf, LP8788_BUF_SIZE, "End Of Charge Level: %s\n",
-			level);
+	return scnprintf(buf, PAGE_SIZE, "End Of Charge Level: %s\n", level);
 }
 
 static DEVICE_ATTR(charger_status, S_IRUSR, lp8788_show_charger_status, NULL);
-- 
1.7.9.5


Best Regards,
Milo


