Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937715Ab3DKALd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:11:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937471Ab3DKAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 11/30] [media] exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 02:04:53 +0200
Message-Id: <1365638712-1028578-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:klIC1H4EYbyRX8ybdz/08lHouQ9ShozcxU5NRwsJWSd
 DW7+ofutIdqja6BphFM/66BHKbUtuuuE2fmKF2tsuBevJfoP35
 IlL49KfhCjfVWw5MLSZUbgTlYdBkY8NlMTKLuOl05TVb8sXUad
 oK5JkfGlVX1POl5+O+V3QEfXZ6mxY9Yqw/OXGgcQVMUCnUxPfU
 Ayjj1gqtsMadbXy/WERZ4wpauSB+JaQVdf38a4HtX4ewTUlJyq
 H6qzDrCf7xyEbhITclixuf53FtbwGBbEyT8gby2LVIOwMFhHHE
 UF+i8fybn6Nzo+Pt90PSir13ANpPlkQSx34UYG5FouFArB2VBt
 OavQtAD1ICsKbUFWX0/jypx0E+QeBW2LGSMcgp66tOE0N4rtv1
 6fOrIOb7wnsXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multiplatform configurations, we cannot include headers
provided by only the exynos platform. Fortunately a number
of drivers that include those headers do not actually need
them, so we can just remove the inclusions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/exynos-gsc/gsc-regs.c | 1 -
 drivers/media/platform/s5p-tv/sii9234_drv.c  | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
index 6f5b5a4..e22d147 100644
--- a/drivers/media/platform/exynos-gsc/gsc-regs.c
+++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
@@ -12,7 +12,6 @@
 
 #include <linux/io.h>
 #include <linux/delay.h>
-#include <mach/map.h>
 
 #include "gsc-core.h"
 
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index d90d228..39b77d2 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -23,9 +23,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/slab.h>
 
-#include <mach/gpio.h>
-#include <plat/gpio-cfg.h>
-
 #include <media/sii9234.h>
 #include <media/v4l2-subdev.h>
 
-- 
1.8.1.2

