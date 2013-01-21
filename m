Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3AURU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:20:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3AURRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH 07/15] drm/exynos: don't include plat/gpio-cfg.h
Date: Mon, 21 Jan 2013 17:16:00 +0000
Message-Id: <1358788568-11137-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BFtiBXXVtGzO7N4XFgfhRjcH2w6fF1t8SM1oYuZPioR
 OyF+DHJSGJKTPekXejgyDI5V1tWz1D0nc5JnD6ap2uPyuL7NQj
 E3rilpBFDolA+yg9tj1rJftnCfkBVC7FezvY5ytzNts8KKtbu1
 h8bCW+2VmOzcyPwbQdD34hgtZKUqZMBQsYd0lK05TsxAjYDOB9
 gTBoXCYMvJv5ne58p0m/0pqQOjETXKG7ye4ptL6AKHFegTiHEc
 lscJw3m24tmuuZzLpK73pmzJR8aCD0DBGsLoZiWGKJGQuLyf5j
 GKxezeNIwRuL/XGyo4PdqqQi62SAkJdJt6x2bY7/UVGON1KquW
 ZNTcaLC6J4SnPvtMrhTEjqsSk/ON7nP24jNLct9Dj
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
 drivers/gpu/drm/exynos/exynos_hdmi.c |    1 -
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
1.7.10.4

