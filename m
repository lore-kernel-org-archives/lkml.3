Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3FKMyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:54:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35040 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3FKMyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:54:11 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V5 03/30] thermal: exynos: Remove CPU_THERMAL dependency for using TMU driver
Date: Tue, 11 Jun 2013 18:23:13 +0530
Message-Id: <1370955220-2949-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dependency on CPU_THERMAL for compiling TMU driver.
This is useful for cases when only TMU controller needs to be initialised
without cpu cooling action.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
index 145a55d..b5ab971 100644
--- a/drivers/thermal/samsung/Kconfig
+++ b/drivers/thermal/samsung/Kconfig
@@ -4,7 +4,6 @@ config ARCH_HAS_TMU
 config EXYNOS_THERMAL
 	tristate "Temperature sensor on Samsung EXYNOS"
 	depends on ARCH_HAS_TMU
-	depends on CPU_THERMAL
 	help
 	  If you say yes here you get support for TMU (Thermal Management
 	  Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
-- 
1.7.1

