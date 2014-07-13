Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaGMDCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:02:53 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36371 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaGMDCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:02:47 -0400
Message-ID: <53C1F6D6.4020607@gmail.com>
Date: Sun, 13 Jul 2014 11:02:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: a.zummo@towertech.it
CC: rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers/rtc/Kconfig: Let several drivers depend on HAS_IOMEM
 to avoid compiling issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers need 'devm_ioremap_resource' or 'devm_ioremap' which need
HAS_IOMEM, so let them depend on it.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-xgene.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-stk17ta8.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1742.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1553.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1511.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1286.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-rp5c01.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-msm6242.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t59.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t35.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-bq4802.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/rtc/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a672dd1..d707092 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -724,6 +724,7 @@ config RTC_DRV_DS1216
 
 config RTC_DRV_DS1286
 	tristate "Dallas DS1286"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Dallas DS1286 RTC chips.
 
@@ -735,6 +736,7 @@ config RTC_DRV_DS1302
 
 config RTC_DRV_DS1511
 	tristate "Dallas DS1511"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1511 timekeeping/watchdog chip.
@@ -744,6 +746,7 @@ config RTC_DRV_DS1511
 
 config RTC_DRV_DS1553
 	tristate "Maxim/Dallas DS1553"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Maxim/Dallas DS1553 timekeeping chip.
@@ -753,6 +756,7 @@ config RTC_DRV_DS1553
 
 config RTC_DRV_DS1742
 	tristate "Maxim/Dallas DS1742/1743"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Maxim/Dallas DS1742/1743 timekeeping chip.
@@ -808,6 +812,7 @@ config RTC_DRV_EFI
 
 config RTC_DRV_STK17TA8
 	tristate "Simtek STK17TA8"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Simtek STK17TA8 timekeeping chip.
@@ -826,6 +831,7 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T35
 	tristate "ST M48T35"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the
 	  ST M48T35 RTC chip.
@@ -835,6 +841,7 @@ config RTC_DRV_M48T35
 
 config RTC_DRV_M48T59
 	tristate "ST M48T59/M48T08/M48T02"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the
 	  ST M48T59 RTC chip and compatible ST M48T08 and M48T02.
@@ -847,6 +854,7 @@ config RTC_DRV_M48T59
 
 config RTC_DRV_MSM6242
 	tristate "Oki MSM6242"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Oki MSM6242
 	  timekeeping chip. It is used in some Amiga models (e.g. A2000).
@@ -856,6 +864,7 @@ config RTC_DRV_MSM6242
 
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the TI
 	  BQ4802 RTC chip.
@@ -865,6 +874,7 @@ config RTC_DRV_BQ4802
 
 config RTC_DRV_RP5C01
 	tristate "Ricoh RP5C01"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Ricoh RP5C01
 	  timekeeping chip. It is used in some Amiga models (e.g. A3000
@@ -1359,6 +1369,7 @@ config RTC_DRV_MOXART
 
 config RTC_DRV_XGENE
 	tristate "APM X-Gene RTC"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the APM X-Gene SoC real time
 	  clock.
-- 
1.7.11.7
