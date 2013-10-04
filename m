Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3JDMnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:43:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15763 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3JDMnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:43:11 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-50-524eb757251b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] thermal: TI: always register sensor driver with core
 thermal framework
Date: Fri, 04 Oct 2013 14:40:51 +0200
Message-id: <1466554.jrelSVKzU4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd3w7X5BBtsXGlqs2f+TyeJs0xt2
	i8u75rBZfO49wmjx5GEfmwOrx+I9L5k8+rasYvQ4fmM7k8fnTXIBLFFcNimpOZllqUX6dglc
	Gac2N7IWzJKpWLp7KVMDY6NEFyMHh4SAicTKyUFdjJxAppjEhXvr2boYuTiEBBYxSmxcMo8d
	wmlhknj8aDIrSBWbgJXExPZVjCC2iICexI0XT5hAipgFOhgl7q3fBFYkLBArMWPbQzYQm0VA
	VWL3hUXMIDavgKbExSnbwJpFBTwlPk1aChUXlPgx+R4LiM0sIC+xb/9UVghbS2L9zuNMExj5
	ZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPzmdQOxpUNFocYBTgY
	lXh4BWp9g4RYE8uKK3MPMUpwMCuJ8B6f5BckxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3Wg
	kEB6YklqdmpqQWoRTJaJg1OqgVH8JcOWVSY5fuJ8Yiu865QCP0Sr9gatXGhe9VTgaWXzf4d5
	L+dx+9bkik+S0Dhd0Pq/qvnGb6lnkrpCJSXOk4p7bVaInF39o3zpleI5ERcF5atFslYX/2Bc
	v2dVWyl/vHTgeeYosWcN/1SCs8r+RNwo81p07M3U48cfbpzQZX2LS1cvvfvLTyWW4oxEQy3m
	ouJEAFtH88JIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is little sense in having separate config option for
registering the sensor driver with the core thermal framework.
Fix it by integrating TI_THERMAL config option with TI_SOC_THERMAL
one.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/ti-soc-thermal/Kconfig      | 15 +++-----------
 drivers/thermal/ti-soc-thermal/Makefile     |  2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal.h | 31 -----------------------------
 3 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
index bf5d6e4..c64e78b 100644
--- a/drivers/thermal/ti-soc-thermal/Kconfig
+++ b/drivers/thermal/ti-soc-thermal/Kconfig
@@ -7,18 +7,9 @@ config TI_SOC_THERMAL
 	  OMAP4460+ on die bandgap temperature sensor support. The register
 	  set is part of system control module.
 
-	  This includes alert interrupts generation and also the TSHUT
-	  support.
-
-config TI_THERMAL
-	bool "Texas Instruments SoCs thermal framework support"
-	depends on TI_SOC_THERMAL
-	help
-	  If you say yes here you want to get support for generic thermal
-	  framework for the Texas Instruments on die bandgap temperature sensor.
-
-	  This includes trip points definitions, extrapolation rules and
-	  CPU cooling device bindings.
+	  This includes alert interrupts generation, the TSHUT support,
+	  trip points definitions, extrapolation rules and CPU cooling
+	  device bindings.
 
 config OMAP4_THERMAL
 	bool "Texas Instruments OMAP4 thermal support"
diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
index 1226b24..c75cc91 100644
--- a/drivers/thermal/ti-soc-thermal/Makefile
+++ b/drivers/thermal/ti-soc-thermal/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
 ti-soc-thermal-y			:= ti-bandgap.o
-ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
+ti-soc-thermal-y			+= ti-thermal-common.o
 ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+= dra752-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal.h b/drivers/thermal/ti-soc-thermal/ti-thermal.h
index f8b7ffe..5fb427c 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal.h
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal.h
@@ -83,41 +83,10 @@
 #define ti_thermal_is_valid_trip(trip)				\
 	((trip) >= 0 && (trip) < OMAP_TRIP_NUMBER)
 
-#ifdef CONFIG_TI_THERMAL
 int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain);
 int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id);
 int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id);
 int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id);
 int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id);
-#else
-static inline
-int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain)
-{
-	return 0;
-}
 
-static inline
-int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
-{
-	return 0;
-}
-
-static inline
-int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id)
-{
-	return 0;
-}
-
-static inline
-int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
-{
-	return 0;
-}
-
-static inline
-int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
-{
-	return 0;
-}
-#endif
 #endif
-- 
1.8.2.3


