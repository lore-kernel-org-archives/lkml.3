Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3JDMkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:40:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29250 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3JDMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:40:37 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-84-524eb71374b2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] thermal: TI: remove TI_THERMAL dependency on CPU_THERMAL
Date: Fri, 04 Oct 2013 14:39:43 +0200
Message-id: <1412622.ASunnW5zzY@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQV2R7X5BBm1HmSzW7P/JZHG26Q27
	xeVdc9gsPvceYbR48rCPzYHVY/Gel0wefVtWMXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSu
	jH23zrIXvOCv+HNtKlsD43beLkZODgkBE4lVW94xQthiEhfurWfrYuTiEBKYzijR+mIeO4TT
	wiQx+egNdpAqNgEriYntq8A6RAT0JG68eMIEUsQs0MEocW/9JlaQhLCAr8SGmRuZQGwWAVWJ
	tpUvwBp4BTQl2j/2gMVFBTwlPk1aygwRF5T4MfkeC4jNLCAvsW//VFYIW0ti/c7jTBMY+WYh
	KZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJD85n0DsZVDRaHGAU4GJV4
	eDcU+wYJsSaWFVfmHmKU4GBWEuE9PskvSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB
	9MSS1OzU1ILUIpgsEwenVANj+jaZnw7LpDukj0XvSHzgU5bBs4lT8dffoHW1rH5F16rLZ6yO
	M17Btkov+udH4bjcigNvPl3Y/Gr2wzb9iXf0pe9GH2fIs5hgXF60NubAMt3Yf9tUCn6uqnaw
	VPiZskqicpnchUwnN5PsqQJHMhwLOeVvbr3/pfS0yCWZS7dsWUKkNddceb5biaU4I9FQi7mo
	OBEAjSS1ckkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cover cpufreq_get_current_driver() call in ti-thermal-common.c with
CPU_FREQ ifdefs and remove no longer needed CPU_THERMAL dependency
from TI_THERMAL config option (stubs for other cpufreq functions for
CPU_THERMAL=n case are already available).

Please note that this enables TI_THERMAL config option in the final
config derived from omap2plus_defconfig (which enables CPU_THERMAL
config option but without CPU_FREQ one so TI_THERMAL config option
was not enabled previously in the final config).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/ti-soc-thermal/Kconfig             | 1 -
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
index bd4c7be..bf5d6e4 100644
--- a/drivers/thermal/ti-soc-thermal/Kconfig
+++ b/drivers/thermal/ti-soc-thermal/Kconfig
@@ -13,7 +13,6 @@ config TI_SOC_THERMAL
 config TI_THERMAL
 	bool "Texas Instruments SoCs thermal framework support"
 	depends on TI_SOC_THERMAL
-	depends on CPU_THERMAL
 	help
 	  If you say yes here you want to get support for generic thermal
 	  framework for the Texas Instruments on die bandgap temperature sensor.
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 4f8b9af..94d91af 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -357,10 +357,12 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 	if (!data)
 		return -EINVAL;
 
+#ifdef CONFIG_CPU_FREQ
 	if (!cpufreq_get_current_driver()) {
 		dev_dbg(bgp->dev, "no cpufreq driver yet\n");
 		return -EPROBE_DEFER;
 	}
+#endif
 
 	/* Register cooling device */
 	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
-- 
1.8.2.3


