Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3AOLjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:39:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11712 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3AOLjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:39:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Jan 2013 03:38:22 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5,RESEND 5/8] drm: tegra: Move drm to live under host1x
Date: Tue, 15 Jan 2013 13:44:01 +0200
Message-ID: <1358250244-9678-6-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make drm part of host1x driver.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/Kconfig                        |    2 --
 drivers/gpu/drm/Makefile                       |    1 -
 drivers/gpu/drm/tegra/Makefile                 |    7 -------
 drivers/gpu/host1x/Kconfig                     |    3 +++
 drivers/gpu/host1x/Makefile                    |    6 ++++++
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
 drivers/gpu/host1x/host1x_client.h             |   25 ++++++++++++++++++++++++
 17 files changed, 37 insertions(+), 13 deletions(-)
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
 create mode 100644 drivers/gpu/host1x/host1x_client.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 983201b..18321b68b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -210,5 +210,3 @@ source "drivers/gpu/drm/mgag200/Kconfig"
 source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
-
-source "drivers/gpu/drm/tegra/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 6f58c81..f54c72a 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -49,5 +49,4 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
-obj-$(CONFIG_DRM_TEGRA) += tegra/
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
index 57680a6..558b660 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -1,4 +1,5 @@
 config TEGRA_HOST1X
+	depends on DRM
 	tristate "Tegra host1x driver"
 	help
 	  Driver for the Tegra host1x hardware.
@@ -26,4 +27,6 @@ config TEGRA_HOST1X_FIREWALL
 
 	  If unsure, choose Y.
 
+source "drivers/gpu/host1x/drm/Kconfig"
+
 endif
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 697d49a..ffc8bf1 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -12,4 +12,10 @@ host1x-y = \
 	hw/host1x01.o
 
 host1x-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
+
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
index 741b5dc..e68b4ac 100644
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
@@ -213,4 +213,4 @@ extern struct platform_driver tegra_hdmi_driver;
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
diff --git a/drivers/gpu/host1x/host1x_client.h b/drivers/gpu/host1x/host1x_client.h
new file mode 100644
index 0000000..fdd2920
--- /dev/null
+++ b/drivers/gpu/host1x/host1x_client.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HOST1X_CLIENT_H
+#define HOST1X_CLIENT_H
+
+struct platform_device;
+
+void host1x_set_drm_data(struct platform_device *pdev, void *data);
+void *host1x_get_drm_data(struct platform_device *pdev);
+
+#endif
-- 
1.7.9.5

