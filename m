Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab3CHNsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:48:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11346 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3CHNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:48:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 05:48:23 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv6 5/9] drm: tegra: Move drm to live under host1x
Date: Fri, 8 Mar 2013 15:46:57 +0200
Message-ID: <1362750421-18080-6-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
References: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make drm part of host1x driver.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/Kconfig                        |    2 --
 drivers/gpu/drm/Makefile                       |    1 -
 drivers/gpu/drm/tegra/Makefile                 |    7 -------
 drivers/gpu/host1x/Kconfig                     |    2 ++
 drivers/gpu/host1x/Makefile                    |    5 +++++
 drivers/gpu/{drm/tegra => host1x/drm}/Kconfig  |    0
 drivers/gpu/{drm/tegra => host1x/drm}/dc.c     |    0
 drivers/gpu/{drm/tegra => host1x/drm}/dc.h     |    0
 drivers/gpu/{drm/tegra => host1x/drm}/drm.c    |    0
 drivers/gpu/{drm/tegra => host1x/drm}/drm.h    |    6 +++---
 drivers/gpu/{drm/tegra => host1x/drm}/fb.c     |    0
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c   |    0
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h   |    0
 drivers/gpu/{drm/tegra => host1x/drm}/host1x.c |    0
 drivers/gpu/{drm/tegra => host1x/drm}/output.c |    0
 drivers/gpu/{drm/tegra => host1x/drm}/rgb.c    |    0
 16 files changed, 10 insertions(+), 13 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/Makefile
 rename drivers/gpu/{drm/tegra => host1x/drm}/Kconfig (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.h (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/drm.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/drm.h (98%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/fb.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/host1x.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/output.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/rgb.c (100%)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 1e82882..9031bb7 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -215,8 +215,6 @@ source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
 
-source "drivers/gpu/drm/tegra/Kconfig"
-
 source "drivers/gpu/drm/omapdrm/Kconfig"
 
 source "drivers/gpu/drm/tilcdc/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 0d59b24..847b830 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
-obj-$(CONFIG_DRM_TEGRA) += tegra/
 obj-$(CONFIG_DRM_OMAP)	+= omapdrm/
 obj-$(CONFIG_DRM_TILCDC)	+= tilcdc/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
deleted file mode 100644
index 80f73d1..0000000
--- a/drivers/gpu/drm/tegra/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-ccflags-y := -Iinclude/drm
-ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
-
-tegra-drm-y := drm.o fb.o dc.o host1x.o
-tegra-drm-y += output.o rgb.o hdmi.o
-
-obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
index 00f0859..ee3af1e 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -18,4 +18,6 @@ config TEGRA_HOST1X_FIREWALL
 
 	  If unsure, choose Y.
 
+source "drivers/gpu/host1x/drm/Kconfig"
+
 endif
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index dfc6f35..db4dc25 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -11,4 +11,9 @@ host1x-y = \
 	memmgr.o \
 	hw/host1x01.o
 
+ccflags-y += -Iinclude/drm
+ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
+
+host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o drm/host1x.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/host1x/drm/Kconfig
similarity index 100%
rename from drivers/gpu/drm/tegra/Kconfig
rename to drivers/gpu/host1x/drm/Kconfig
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/host1x/drm/dc.c
similarity index 100%
rename from drivers/gpu/drm/tegra/dc.c
rename to drivers/gpu/host1x/drm/dc.c
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/host1x/drm/dc.h
similarity index 100%
rename from drivers/gpu/drm/tegra/dc.h
rename to drivers/gpu/host1x/drm/dc.h
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/host1x/drm/drm.c
similarity index 100%
rename from drivers/gpu/drm/tegra/drm.c
rename to drivers/gpu/host1x/drm/drm.c
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/host1x/drm/drm.h
similarity index 98%
rename from drivers/gpu/drm/tegra/drm.h
rename to drivers/gpu/host1x/drm/drm.h
index 6dd75a2..a6c011d 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -7,8 +7,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef TEGRA_DRM_H
-#define TEGRA_DRM_H 1
+#ifndef HOST1X_DRM_H
+#define HOST1X_DRM_H 1
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -234,4 +234,4 @@ extern struct platform_driver tegra_hdmi_driver;
 extern struct platform_driver tegra_dc_driver;
 extern struct drm_driver tegra_drm_driver;
 
-#endif /* TEGRA_DRM_H */
+#endif /* HOST1X_DRM_H */
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/host1x/drm/fb.c
similarity index 100%
rename from drivers/gpu/drm/tegra/fb.c
rename to drivers/gpu/host1x/drm/fb.c
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
similarity index 100%
rename from drivers/gpu/drm/tegra/hdmi.c
rename to drivers/gpu/host1x/drm/hdmi.c
diff --git a/drivers/gpu/drm/tegra/hdmi.h b/drivers/gpu/host1x/drm/hdmi.h
similarity index 100%
rename from drivers/gpu/drm/tegra/hdmi.h
rename to drivers/gpu/host1x/drm/hdmi.h
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/host1x/drm/host1x.c
similarity index 100%
rename from drivers/gpu/drm/tegra/host1x.c
rename to drivers/gpu/host1x/drm/host1x.c
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/host1x/drm/output.c
similarity index 100%
rename from drivers/gpu/drm/tegra/output.c
rename to drivers/gpu/host1x/drm/output.c
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/host1x/drm/rgb.c
similarity index 100%
rename from drivers/gpu/drm/tegra/rgb.c
rename to drivers/gpu/host1x/drm/rgb.c
-- 
1.7.9.5

