Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab3CSO45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:56:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56757 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab3CSO4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:56:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit <b-cousson@ti.com>, Nishanth Menon <nm@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 04/12] staging: ti-soc-thermal: rename Kconfig options
Date: Tue, 19 Mar 2013 10:54:20 -0400
Message-ID: <1363704868-11843-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the Kconfig options to cope with
the new naming convention.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit <b-cousson@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/Makefile                    |    2 +-
 drivers/staging/ti-soc-thermal/Kconfig      |   14 +++++++-------
 drivers/staging/ti-soc-thermal/Makefile     |    4 ++--
 drivers/staging/ti-soc-thermal/ti-thermal.h |    6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 284624c..b6d15ec 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
-obj-$(CONFIG_OMAP_BANDGAP)	+= ti-soc-thermal/
+obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
diff --git a/drivers/staging/ti-soc-thermal/Kconfig b/drivers/staging/ti-soc-thermal/Kconfig
index 6b3f3db..e81375f 100644
--- a/drivers/staging/ti-soc-thermal/Kconfig
+++ b/drivers/staging/ti-soc-thermal/Kconfig
@@ -1,5 +1,5 @@
-config OMAP_BANDGAP
-	tristate "Texas Instruments OMAP4+ temperature sensor driver"
+config TI_SOC_THERMAL
+	tristate "Texas Instruments SoCs temperature sensor driver"
 	depends on THERMAL
 	depends on ARCH_HAS_BANDGAP
 	help
@@ -10,9 +10,9 @@ config OMAP_BANDGAP
 	  This includes alert interrupts generation and also the TSHUT
 	  support.
 
-config OMAP_THERMAL
-	bool "Texas Instruments OMAP4+ thermal framework support"
-	depends on OMAP_BANDGAP
+config TI_THERMAL
+	bool "Texas Instruments SoCs thermal framework support"
+	depends on TI_SOC_THERMAL
 	depends on CPU_THERMAL
 	help
 	  If you say yes here you want to get support for generic thermal
@@ -23,7 +23,7 @@ config OMAP_THERMAL
 
 config OMAP4_THERMAL
 	bool "Texas Instruments OMAP4 thermal support"
-	depends on OMAP_BANDGAP
+	depends on TI_SOC_THERMAL
 	depends on ARCH_OMAP4
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
@@ -37,7 +37,7 @@ config OMAP4_THERMAL
 
 config OMAP5_THERMAL
 	bool "Texas Instruments OMAP5 thermal support"
-	depends on OMAP_BANDGAP
+	depends on TI_SOC_THERMAL
 	depends on SOC_OMAP5
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
diff --git a/drivers/staging/ti-soc-thermal/Makefile b/drivers/staging/ti-soc-thermal/Makefile
index 3539474..0ca034f 100644
--- a/drivers/staging/ti-soc-thermal/Makefile
+++ b/drivers/staging/ti-soc-thermal/Makefile
@@ -1,5 +1,5 @@
-obj-$(CONFIG_OMAP_BANDGAP)		+= ti-soc-thermal.o
+obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
 ti-soc-thermal-y			:= ti-bandgap.o
-ti-soc-thermal-$(CONFIG_OMAP_THERMAL)	+= ti-thermal-common.o
+ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
 ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal.h b/drivers/staging/ti-soc-thermal/ti-thermal.h
index 6fed8ac..3ed4adb 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal.h
+++ b/drivers/staging/ti-soc-thermal/ti-thermal.h
@@ -20,8 +20,8 @@
  * 02110-1301 USA
  *
  */
-#ifndef __OMAP_THERMAL_H
-#define __OMAP_THERMAL_H
+#ifndef __TI_THERMAL_H
+#define __TI_THERMAL_H
 
 #include "ti-bandgap.h"
 
@@ -73,7 +73,7 @@
 #define omap_thermal_is_valid_trip(trip)				\
 	((trip) >= 0 && (trip) < OMAP_TRIP_NUMBER)
 
-#ifdef CONFIG_OMAP_THERMAL
+#ifdef CONFIG_TI_THERMAL
 int omap_thermal_expose_sensor(struct omap_bandgap *bgp, int id,
 			       char *domain);
 int omap_thermal_remove_sensor(struct omap_bandgap *bgp, int id);
-- 
1.7.7.1.488.ge8e1c

