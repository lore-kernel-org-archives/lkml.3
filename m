Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3AYP3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:29:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3AYP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:28:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Clark <rob@ti.com>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH 5/5] drm/exynos: don't include plat/gpio-cfg.h
Date: Fri, 25 Jan 2013 15:28:31 +0000
Message-Id: <1359127711-19070-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359127711-19070-1-git-send-email-arnd@arndb.de>
References: <1359127711-19070-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hbDG/s5McfUJYu/PPAqiv+41KYagYAv7EskBOGSxIJC
 sCP94DfZn+zASsWJzzQReYpiTyRPgiR2xq0CgqDPh8PgZ5yVcb
 ColoYwmYUv4Rbc8oFM8q3YptKcc/uSAy2/gpfd5FkAmz3YUNG4
 ffOsbebIxpxZPL7nA8ixKBwFRCqpUn1ymke4cMOG4oN5BuSgTs
 NuKHLCvCTC5teMsz1YO1bw0gB43eALURUpVfjX9VCbNd4EqfWl
 N7mVoWkIYDrUOcJUo9n9i1HV4fZhikMM4jCzfeAcLggOYEWZ3d
 1dvrZpEPcO2gwwutHaiLB9wbMbdtsCHqdqCCRremD2TfONnflA
 Z23TdfCGdeG1svKfJhoYJQ72Wzsk0pJnIggH4Q4BZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch  9eb3e9e6f3 "drm/exynos: add support for ARCH_MULTIPLATFORM"
allowed building the exynos hdmi driver on non-samsung platforms,
which unfortunately broke compilation in combination with 22c4f42897
"drm: exynos: hdmi: add support for exynos5 hdmi", which added
an inclusion of the samsung-specific plat/gpio-cfg.h header file.

Fortunately, that header file is not required any more here, so
we can simply revert the inclusion in order to build the ARM
allyesconfig again without getting this error:

drivers/gpu/drm/exynos/exynos_hdmi.c:37:27: fatal error: plat/gpio-cfg.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <rob@ti.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 41ff79d..b5f5119 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -34,7 +34,6 @@
 #include <linux/regulator/consumer.h>
 #include <linux/io.h>
 #include <linux/of_gpio.h>
-#include <plat/gpio-cfg.h>
 
 #include <drm/exynos_drm.h>
 
-- 
1.8.0

