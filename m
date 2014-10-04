Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaJDJeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:34:05 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44470 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaJDJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:34:03 -0400
Message-ID: <542FC064.1030604@gmail.com>
Date: Sat, 04 Oct 2014 17:39:48 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/watchdog/Kconfig: Let XILINX_WATCHDOG and TEGRA_WATCHDOG
 depend on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They need HAS_IOMEM, so let them depend on it, the related error (with
allmodconfig under um):

    MODPOST 1205 modules
  ERROR: "syscall" [fs/hostfs/hostfs.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/watchdog/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index a51ccf3..d0ddf90 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -132,6 +132,7 @@ config WM8350_WATCHDOG
 
 config XILINX_WATCHDOG
 	tristate "Xilinx Watchdog timer"
+	depends on HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Watchdog driver for the xps_timebase_wdt ip core.
@@ -472,7 +473,7 @@ config SIRFSOC_WATCHDOG
 
 config TEGRA_WATCHDOG
 	tristate "Tegra watchdog"
-	depends on ARCH_TEGRA || COMPILE_TEST
+	depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Say Y here to include support for the watchdog timer
-- 
1.9.3
