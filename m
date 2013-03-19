Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3CSO4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:56:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56731 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab3CSO4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:56:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit <b-cousson@ti.com>, Nishanth Menon <nm@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 03/12] staging: rename omap-thermal driver to ti-soc-thermal
Date: Tue, 19 Mar 2013 10:54:19 -0400
Message-ID: <1363704868-11843-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because this driver will support also OMAP derivatives,
this patch does a big rename inside this driver, so it
better fits its usage.

This patch only renames the directory, file names,
includes, Makefiles and Kconfig includes.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit <b-cousson@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/omap-thermal/Makefile              |    5 -----
 .../{omap-thermal => ti-soc-thermal}/Kconfig       |    6 ++++--
 drivers/staging/ti-soc-thermal/Makefile            |    5 +++++
 .../staging/{omap-thermal => ti-soc-thermal}/TODO  |    4 ++--
 .../omap4-thermal-data.c                           |    4 ++--
 .../omap4xxx-bandgap.h                             |    0
 .../omap5-thermal-data.c                           |    4 ++--
 .../omap5xxx-bandgap.h                             |    0
 .../omap-bandgap.c => ti-soc-thermal/ti-bandgap.c} |    2 +-
 .../omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} |    0
 .../ti-thermal-common.c}                           |    4 ++--
 .../omap-thermal.h => ti-soc-thermal/ti-thermal.h} |    2 +-
 .../ti_soc_thermal.txt}                            |    0
 15 files changed, 21 insertions(+), 19 deletions(-)
 delete mode 100644 drivers/staging/omap-thermal/Makefile
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (88%)
 create mode 100644 drivers/staging/ti-soc-thermal/Makefile
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/TODO (90%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4-thermal-data.c (99%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5-thermal-data.c (99%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal/omap-bandgap.c => ti-soc-thermal/ti-bandgap.c} (99%)
 rename drivers/staging/{omap-thermal/omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} (100%)
 rename drivers/staging/{omap-thermal/omap-thermal-common.c => ti-soc-thermal/ti-thermal-common.c} (99%)
 rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (99%)
 rename drivers/staging/{omap-thermal/omap_bandgap.txt => ti-soc-thermal/ti_soc_thermal.txt} (100%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index d4775a5..5e62d00 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -120,7 +120,7 @@ source "drivers/staging/gdm72xx/Kconfig"
 
 source "drivers/staging/csr/Kconfig"
 
-source "drivers/staging/omap-thermal/Kconfig"
+source "drivers/staging/ti-soc-thermal/Kconfig"
 
 source "drivers/staging/silicom/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e1ed6ad..284624c 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
-obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal/
+obj-$(CONFIG_OMAP_BANDGAP)	+= ti-soc-thermal/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
diff --git a/drivers/staging/omap-thermal/Makefile b/drivers/staging/omap-thermal/Makefile
deleted file mode 100644
index fbd14d1..0000000
--- a/drivers/staging/omap-thermal/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal.o
-omap-thermal-y			:= omap-bandgap.o
-omap-thermal-$(CONFIG_OMAP_THERMAL)	+= omap-thermal-common.o
-omap-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
-omap-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/omap-thermal/Kconfig b/drivers/staging/ti-soc-thermal/Kconfig
similarity index 88%
rename from drivers/staging/omap-thermal/Kconfig
rename to drivers/staging/ti-soc-thermal/Kconfig
index 52170bf..6b3f3db 100644
--- a/drivers/staging/omap-thermal/Kconfig
+++ b/drivers/staging/ti-soc-thermal/Kconfig
@@ -16,8 +16,10 @@ config OMAP_THERMAL
 	depends on CPU_THERMAL
 	help
 	  If you say yes here you want to get support for generic thermal
-	  framework for the Texas Instruments OMAP4460+ on die bandgap
-	  temperature sensor.
+	  framework for the Texas Instruments on die bandgap temperature sensor.
+
+	  This includes trip points definitions, extrapolation rules and
+	  CPU cooling device bindings.
 
 config OMAP4_THERMAL
 	bool "Texas Instruments OMAP4 thermal support"
diff --git a/drivers/staging/ti-soc-thermal/Makefile b/drivers/staging/ti-soc-thermal/Makefile
new file mode 100644
index 0000000..3539474
--- /dev/null
+++ b/drivers/staging/ti-soc-thermal/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_OMAP_BANDGAP)		+= ti-soc-thermal.o
+ti-soc-thermal-y			:= ti-bandgap.o
+ti-soc-thermal-$(CONFIG_OMAP_THERMAL)	+= ti-thermal-common.o
+ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
+ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/omap-thermal/TODO b/drivers/staging/ti-soc-thermal/TODO
similarity index 90%
rename from drivers/staging/omap-thermal/TODO
rename to drivers/staging/ti-soc-thermal/TODO
index d45f556..9b4c841 100644
--- a/drivers/staging/omap-thermal/TODO
+++ b/drivers/staging/ti-soc-thermal/TODO
@@ -1,13 +1,13 @@
 List of TODOs (by Eduardo Valentin)
 
-on omap-bandgap.c:
+on ti-bandgap.c:
 - Test every exposed API to userland
 - Add support to hwmon
 - Revisit PM support
 - Revisit data structures and simplify them
 - Once SCM-core api settles, update this driver accordingly
 
-on omap-thermal-common.c/omap-thermal.h:
+on ti-thermal-common.c/ti-thermal.h:
 - Revisit extrapolation constants for O4/O5
 - Revisit need for locking
 - Revisit trips and its definitions
diff --git a/drivers/staging/omap-thermal/omap4-thermal-data.c b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
similarity index 99%
rename from drivers/staging/omap-thermal/omap4-thermal-data.c
rename to drivers/staging/ti-soc-thermal/omap4-thermal-data.c
index 88ed014..97544f7 100644
--- a/drivers/staging/omap-thermal/omap4-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
@@ -16,8 +16,8 @@
  *
  */
 
-#include "omap-thermal.h"
-#include "omap-bandgap.h"
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
 #include "omap4xxx-bandgap.h"
 
 /*
diff --git a/drivers/staging/omap-thermal/omap4xxx-bandgap.h b/drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
similarity index 100%
rename from drivers/staging/omap-thermal/omap4xxx-bandgap.h
rename to drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
diff --git a/drivers/staging/omap-thermal/omap5-thermal-data.c b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
similarity index 99%
rename from drivers/staging/omap-thermal/omap5-thermal-data.c
rename to drivers/staging/ti-soc-thermal/omap5-thermal-data.c
index a48c286..172b4ad 100644
--- a/drivers/staging/omap-thermal/omap5-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
@@ -16,9 +16,9 @@
  *
  */
 
-#include "omap-bandgap.h"
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
 #include "omap5xxx-bandgap.h"
-#include "omap-thermal.h"
 
 /*
  * OMAP5430 has three instances of thermal sensor for MPU, GPU & CORE,
diff --git a/drivers/staging/omap-thermal/omap5xxx-bandgap.h b/drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
similarity index 100%
rename from drivers/staging/omap-thermal/omap5xxx-bandgap.h
rename to drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
similarity index 99%
rename from drivers/staging/omap-thermal/omap-bandgap.c
rename to drivers/staging/ti-soc-thermal/ti-bandgap.c
index 1189ca7..5a8ae9c 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -40,7 +40,7 @@
 #include <linux/of_irq.h>
 #include <linux/io.h>
 
-#include "omap-bandgap.h"
+#include "ti-bandgap.h"
 
 /***   Helper functions to access registers and their bitfields   ***/
 
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
similarity index 100%
rename from drivers/staging/omap-thermal/omap-bandgap.h
rename to drivers/staging/ti-soc-thermal/ti-bandgap.h
diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
similarity index 99%
rename from drivers/staging/omap-thermal/omap-thermal-common.c
rename to drivers/staging/ti-soc-thermal/ti-thermal-common.c
index 9f7a77b..feab2f4 100644
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -32,8 +32,8 @@
 #include <linux/cpumask.h>
 #include <linux/cpu_cooling.h>
 
-#include "omap-thermal.h"
-#include "omap-bandgap.h"
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
 
 /* common data structures */
 struct omap_thermal_data {
diff --git a/drivers/staging/omap-thermal/omap-thermal.h b/drivers/staging/ti-soc-thermal/ti-thermal.h
similarity index 99%
rename from drivers/staging/omap-thermal/omap-thermal.h
rename to drivers/staging/ti-soc-thermal/ti-thermal.h
index 26cfc8d..6fed8ac 100644
--- a/drivers/staging/omap-thermal/omap-thermal.h
+++ b/drivers/staging/ti-soc-thermal/ti-thermal.h
@@ -23,7 +23,7 @@
 #ifndef __OMAP_THERMAL_H
 #define __OMAP_THERMAL_H
 
-#include "omap-bandgap.h"
+#include "ti-bandgap.h"
 
 /* sensors gradient and offsets */
 #define OMAP_GRADIENT_SLOPE_4460				348
diff --git a/drivers/staging/omap-thermal/omap_bandgap.txt b/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
similarity index 100%
rename from drivers/staging/omap-thermal/omap_bandgap.txt
rename to drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
-- 
1.7.7.1.488.ge8e1c

