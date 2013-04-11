Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937693Ab3DKAHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937451Ab3DKAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 12/30] video/exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 02:04:54 +0200
Message-Id: <1365638712-1028578-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:JzK3MnFtHu2Czc2GCp6ChZTfeFrkmXX21TxLtIo0Bh0
 CAJdDOyb0/7weaBtkuyaczab6xQPyOKA0Zfx+RFIZNUthJ9Liy
 oFeCXqXXgoxdcULhNH5RlP1WZw7hIa+XQYvaPD0ez5J60atyMD
 Xd0gb7e+NiUJV/nrS7pMNRJSlktleGQp/jN9KZ2gHqx76PM8L1
 VS+dIpwkkPCcxGeK3LFcKrENwSLHtjp8yKUUSMyLiq0djELPbN
 cHfx4i/XggTmC3ip6Vq+2bZfHXTX8cy9ZfA1v1Enaw0WU2pMTp
 an3g4rBSWLo+ULJ+kRD7qDwO9l7XnnYBHBXQ5kd06D8lJE1YW+
 54jujv9xuVyeXihbqgglVZYckCaAoGDSQHIGT3YDEUMdE610Qg
 1UZLeQ20ozImg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multiplatform configurations, we cannot include headers
provided by only the exynos platform. Fortunately a number
of drivers that include those headers do not actually need
them, so we can just remove the inclusions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fbdev@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/exynos/exynos_mipi_dsi.c          | 2 --
 drivers/video/exynos/exynos_mipi_dsi_common.c   | 2 --
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index fac7df6..3dd43ca 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -35,8 +35,6 @@
 
 #include <video/exynos_mipi_dsim.h>
 
-#include <plat/fb.h>
-
 #include "exynos_mipi_dsi_common.h"
 #include "exynos_mipi_dsi_lowlevel.h"
 
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
index c70cb89..520fc9b 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -31,8 +31,6 @@
 #include <video/mipi_display.h>
 #include <video/exynos_mipi_dsim.h>
 
-#include <mach/map.h>
-
 #include "exynos_mipi_dsi_regs.h"
 #include "exynos_mipi_dsi_lowlevel.h"
 #include "exynos_mipi_dsi_common.h"
diff --git a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
index 95cb99a..15c5abd 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
@@ -26,8 +26,6 @@
 
 #include <video/exynos_mipi_dsim.h>
 
-#include <mach/map.h>
-
 #include "exynos_mipi_dsi_regs.h"
 
 void exynos_mipi_dsi_func_reset(struct mipi_dsim_device *dsim)
-- 
1.8.1.2

