Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab3EOPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:47:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46351 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473Ab3EOPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:46:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>, <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        J Keerthy <j-keerthy@ti.com>, Radhesh Fadnis <radhesh.fadnis@ti.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH 1/2] thermal: introduce TI SoC thermal driver
Date: Wed, 15 May 2013 11:46:00 -0400
Message-ID: <1368632761-10528-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the ti-soc-thermal driver out of
the staging tree to the thermal tree.

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: J Keerthy <j-keerthy@ti.com>
Cc: Radhesh Fadnis <radhesh.fadnis@ti.com>
Cc: Cyril Roelandt <tipecaml@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-pm@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 .../devicetree/bindings/thermal}/ti_soc_thermal.txt                    | 0
 drivers/staging/Kconfig                                                | 2 --
 drivers/staging/Makefile                                               | 1 -
 drivers/thermal/Kconfig                                                | 3 +++
 drivers/thermal/Makefile                                               | 2 +-
 drivers/{staging => thermal}/ti-soc-thermal/Kconfig                    | 0
 drivers/{staging => thermal}/ti-soc-thermal/Makefile                   | 0
 drivers/{staging => thermal}/ti-soc-thermal/TODO                       | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c       | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h         | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c       | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h         | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c               | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h               | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c        | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h               | 0
 16 files changed, 4 insertions(+), 4 deletions(-)
 rename {drivers/staging/ti-soc-thermal => Documentation/devicetree/bindings/thermal}/ti_soc_thermal.txt (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/Kconfig (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/Makefile (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/TODO (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h (100%)

diff --git a/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
similarity index 100%
rename from drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
rename to Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index c39fe78..e0b3495 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -118,8 +118,6 @@ source "drivers/staging/gdm72xx/Kconfig"
 
 source "drivers/staging/csr/Kconfig"
 
-source "drivers/staging/ti-soc-thermal/Kconfig"
-
 source "drivers/staging/silicom/Kconfig"
 
 source "drivers/staging/ced1401/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 110c597..8b3d86e 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
-obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 5e3c025..7205c70 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -169,4 +169,7 @@ config INTEL_POWERCLAMP
 	  enforce idle time which results in more package C-state residency. The
 	  user interface is exposed via generic thermal framework.
 
+menu "Texas Instruments thermal drivers"
+source "drivers/thermal/ti-soc-thermal/Kconfig"
+endmenu
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index c054d41..8569394 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -23,4 +23,4 @@ obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
 obj-$(CONFIG_ARMADA_THERMAL)	+= armada_thermal.o
 obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
 obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
-
+obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
diff --git a/drivers/staging/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
similarity index 100%
rename from drivers/staging/ti-soc-thermal/Kconfig
rename to drivers/thermal/ti-soc-thermal/Kconfig
diff --git a/drivers/staging/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
similarity index 100%
rename from drivers/staging/ti-soc-thermal/Makefile
rename to drivers/thermal/ti-soc-thermal/Makefile
diff --git a/drivers/staging/ti-soc-thermal/TODO b/drivers/thermal/ti-soc-thermal/TODO
similarity index 100%
rename from drivers/staging/ti-soc-thermal/TODO
rename to drivers/thermal/ti-soc-thermal/TODO
diff --git a/drivers/staging/ti-soc-thermal/omap4-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap4-thermal-data.c
similarity index 100%
rename from drivers/staging/ti-soc-thermal/omap4-thermal-data.c
rename to drivers/thermal/ti-soc-thermal/omap4-thermal-data.c
diff --git a/drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h b/drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h
similarity index 100%
rename from drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
rename to drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h
diff --git a/drivers/staging/ti-soc-thermal/omap5-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap5-thermal-data.c
similarity index 100%
rename from drivers/staging/ti-soc-thermal/omap5-thermal-data.c
rename to drivers/thermal/ti-soc-thermal/omap5-thermal-data.c
diff --git a/drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h b/drivers/thermal/ti-soc-thermal/omap5xxx-bandgap.h
similarity index 100%
rename from drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
rename to drivers/thermal/ti-soc-thermal/omap5xxx-bandgap.h
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
similarity index 100%
rename from drivers/staging/ti-soc-thermal/ti-bandgap.c
rename to drivers/thermal/ti-soc-thermal/ti-bandgap.c
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
similarity index 100%
rename from drivers/staging/ti-soc-thermal/ti-bandgap.h
rename to drivers/thermal/ti-soc-thermal/ti-bandgap.h
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
similarity index 100%
rename from drivers/staging/ti-soc-thermal/ti-thermal-common.c
rename to drivers/thermal/ti-soc-thermal/ti-thermal-common.c
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal.h b/drivers/thermal/ti-soc-thermal/ti-thermal.h
similarity index 100%
rename from drivers/staging/ti-soc-thermal/ti-thermal.h
rename to drivers/thermal/ti-soc-thermal/ti-thermal.h
-- 
1.8.2.1.342.gfa7285d

