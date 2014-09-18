Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbaIRPbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:31:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20634 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbaIRPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:46 -0400
X-AuditID: cbfee61b-f79f86d00000144c-34-541afaa4838b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 33/33] thermal: exynos: remove exynos_tmu_data.h include
Date: Thu, 18 Sep 2014 17:27:50 +0200
Message-id: <1411054070-25757-34-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd0lv6RCDC68s7ZouBpisXHGelaL
	u88PM1rMv3KN1eJs0xt2izcPNzNaXN41h83ic+8RRosZ5/cxWTx52MfmwOWxc9Zddo/Fe14y
	efRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGyT3t7AV/IytWzGtkbWBc6NfFyMkhIWAiceN7
	CyOELSZx4d56ti5GLg4hgUWMEkc3fWeBcLqYJJ5d/cMGUsUmYCUxsX0VWIeIgJbEiUvbmUCK
	mAVuMUm8vjEZLCEs4CHRuHAbaxcjBweLgKrEl05xkDCvgKfE3hVXmCG2KUp0P5sANpMTKN5w
	axM7iC0E1Nq25S7zBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA+2Z9A7GVQ0W
	hxgFOBiVeHgP8EqFCLEmlhVX5h5ilOBgVhLh/fMRKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	YKt1oJBAemJJanZqakFqEUyWiYNTqoGxoSLWI/tFdeWGJJmeWaIO2+c7S8nd1dJ+ey7+Sqjx
	74KFjZpGN6LCpyUXX6i+nfx4oSvn4yk1q8Re/+urPhHAvCHhOtvh+y4G3nN71qqbTMwJ1+n6
	mri/KTujgVH1y/HpTsYX42ZGu/+Wfbzp6oID3BKbfILPdnH8L9768MmvqzxMa8VuC99TYinO
	SDTUYi4qTgQAlsdJ2DACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no longer need to share defines between exynos_tmu.c
and exynos_tmu_data.c (as they are now only used by the former
file) so move them accordingly.  Then move externs for struct
exynos_tmu_init_data instances to exynos_tmu.h and remove no
longer needed exynos_tmu_data.h include.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  97 +++++++++++++++++++++-
 drivers/thermal/samsung/exynos_tmu.h      |   8 ++
 drivers/thermal/samsung/exynos_tmu_data.c |   1 -
 drivers/thermal/samsung/exynos_tmu_data.h | 130 ------------------------------
 4 files changed, 104 insertions(+), 132 deletions(-)
 delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 104fd7c..9e7f720 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -33,7 +33,102 @@
 
 #include "exynos_thermal_common.h"
 #include "exynos_tmu.h"
-#include "exynos_tmu_data.h"
+
+/* Exynos generic registers */
+#define EXYNOS_TMU_REG_TRIMINFO		0x0
+#define EXYNOS_TMU_REG_CONTROL		0x20
+#define EXYNOS_TMU_REG_STATUS		0x28
+#define EXYNOS_TMU_REG_CURRENT_TEMP	0x40
+#define EXYNOS_TMU_REG_INTEN		0x70
+#define EXYNOS_TMU_REG_INTSTAT		0x74
+#define EXYNOS_TMU_REG_INTCLEAR		0x78
+
+#define EXYNOS_TMU_TEMP_MASK		0xff
+#define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
+#define EXYNOS_TMU_REF_VOLTAGE_MASK	0x1f
+#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
+#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
+#define EXYNOS_TMU_CORE_EN_SHIFT	0
+
+/* Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
+/* Exynos4210 specific registers */
+#define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
+#define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
+
+#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
+
+/* Exynos5250, Exynos4412, Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
+#define EXYNOS_THD_TEMP_RISE		0x50
+#define EXYNOS_THD_TEMP_FALL		0x54
+#define EXYNOS_EMUL_CON		0x80
+
+#define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
+#define EXYNOS_TRIMINFO_25_SHIFT	0
+#define EXYNOS_TRIMINFO_85_SHIFT	8
+#define EXYNOS_TMU_RISE_INT_MASK	0x111
+#define EXYNOS_TMU_RISE_INT_SHIFT	0
+#define EXYNOS_TMU_FALL_INT_MASK	0x111
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT	16
+#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
+#define EXYNOS_TMU_TRIP_MODE_SHIFT	13
+#define EXYNOS_TMU_TRIP_MODE_MASK	0x7
+#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
+
+#define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
+#define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
+#define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
+#define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
+#define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
+
+#define EXYNOS_EMUL_TIME	0x57F0
+#define EXYNOS_EMUL_TIME_MASK	0xffff
+#define EXYNOS_EMUL_TIME_SHIFT	16
+#define EXYNOS_EMUL_DATA_SHIFT	8
+#define EXYNOS_EMUL_DATA_MASK	0xFF
+#define EXYNOS_EMUL_ENABLE	0x1
+
+/* Exynos5260 specific */
+#define EXYNOS5260_TMU_REG_INTEN		0xC0
+#define EXYNOS5260_TMU_REG_INTSTAT		0xC4
+#define EXYNOS5260_TMU_REG_INTCLEAR		0xC8
+#define EXYNOS5260_TMU_CLEAR_RISE_INT		0x1111
+#define EXYNOS5260_TMU_CLEAR_FALL_INT		(0x1111 << 16)
+#define EXYNOS5260_TMU_RISE_INT_MASK		0x1111
+#define EXYNOS5260_TMU_FALL_INT_MASK		0x1111
+#define EXYNOS5260_EMUL_CON			0x100
+
+/* Exynos4412 specific */
+#define EXYNOS4412_MUX_ADDR_VALUE          6
+#define EXYNOS4412_MUX_ADDR_SHIFT          20
+
+/*exynos5440 specific registers*/
+#define EXYNOS5440_TMU_S0_7_TRIM		0x000
+#define EXYNOS5440_TMU_S0_7_CTRL		0x020
+#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
+#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
+#define EXYNOS5440_TMU_S0_7_TH0			0x110
+#define EXYNOS5440_TMU_S0_7_TH1			0x130
+#define EXYNOS5440_TMU_S0_7_TH2			0x150
+#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
+#define EXYNOS5440_TMU_S0_7_IRQ			0x230
+/* exynos5440 common registers */
+#define EXYNOS5440_TMU_IRQ_STATUS		0x000
+#define EXYNOS5440_TMU_PMIN			0x004
+
+#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
+#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
+#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
+#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
+#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
+#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
+#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
+#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
+#define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
+#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
 
 /**
  * struct exynos_tmu_data : A structure to hold the private data of the TMU
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 8de0f82..da3009b 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -133,4 +133,12 @@ struct exynos_tmu_init_data {
 	struct exynos_tmu_platform_data tmu_data[];
 };
 
+extern struct exynos_tmu_init_data const exynos3250_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos4412_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos5260_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos5420_default_tmu_data;
+extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
+
 #endif /* _EXYNOS_TMU_H */
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 592c470..b239100 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -22,7 +22,6 @@
 
 #include "exynos_thermal_common.h"
 #include "exynos_tmu.h"
-#include "exynos_tmu_data.h"
 
 struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 	.tmu_data = {
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
deleted file mode 100644
index 4f7e201..0000000
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ /dev/null
@@ -1,130 +0,0 @@
-/*
- * exynos_tmu_data.h - Samsung EXYNOS tmu data header file
- *
- *  Copyright (C) 2013 Samsung Electronics
- *  Amit Daniel Kachhap <amit.daniel@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#ifndef _EXYNOS_TMU_DATA_H
-#define _EXYNOS_TMU_DATA_H
-
-/* Exynos generic registers */
-#define EXYNOS_TMU_REG_TRIMINFO		0x0
-#define EXYNOS_TMU_REG_CONTROL		0x20
-#define EXYNOS_TMU_REG_STATUS		0x28
-#define EXYNOS_TMU_REG_CURRENT_TEMP	0x40
-#define EXYNOS_TMU_REG_INTEN		0x70
-#define EXYNOS_TMU_REG_INTSTAT		0x74
-#define EXYNOS_TMU_REG_INTCLEAR		0x78
-
-#define EXYNOS_TMU_TEMP_MASK		0xff
-#define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
-#define EXYNOS_TMU_REF_VOLTAGE_MASK	0x1f
-#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
-#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
-#define EXYNOS_TMU_CORE_EN_SHIFT	0
-
-/* Exynos3250 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON1	0x10
-
-/* Exynos4210 specific registers */
-#define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
-#define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
-
-#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
-
-/* Exynos5250, Exynos4412, Exynos3250 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON2	0x14
-#define EXYNOS_THD_TEMP_RISE		0x50
-#define EXYNOS_THD_TEMP_FALL		0x54
-#define EXYNOS_EMUL_CON		0x80
-
-#define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
-#define EXYNOS_TRIMINFO_25_SHIFT	0
-#define EXYNOS_TRIMINFO_85_SHIFT	8
-#define EXYNOS_TMU_RISE_INT_MASK	0x111
-#define EXYNOS_TMU_RISE_INT_SHIFT	0
-#define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
-#define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT	16
-#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
-#define EXYNOS_TMU_TRIP_MODE_SHIFT	13
-#define EXYNOS_TMU_TRIP_MODE_MASK	0x7
-#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-
-#define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
-#define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
-#define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
-#define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
-#define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
-
-#define EXYNOS_EMUL_TIME	0x57F0
-#define EXYNOS_EMUL_TIME_MASK	0xffff
-#define EXYNOS_EMUL_TIME_SHIFT	16
-#define EXYNOS_EMUL_DATA_SHIFT	8
-#define EXYNOS_EMUL_DATA_MASK	0xFF
-#define EXYNOS_EMUL_ENABLE	0x1
-
-/* Exynos5260 specific */
-#define EXYNOS5260_TMU_REG_INTEN		0xC0
-#define EXYNOS5260_TMU_REG_INTSTAT		0xC4
-#define EXYNOS5260_TMU_REG_INTCLEAR		0xC8
-#define EXYNOS5260_TMU_CLEAR_RISE_INT		0x1111
-#define EXYNOS5260_TMU_CLEAR_FALL_INT		(0x1111 << 16)
-#define EXYNOS5260_TMU_RISE_INT_MASK		0x1111
-#define EXYNOS5260_TMU_FALL_INT_MASK		0x1111
-#define EXYNOS5260_EMUL_CON			0x100
-
-/* Exynos4412 specific */
-#define EXYNOS4412_MUX_ADDR_VALUE          6
-#define EXYNOS4412_MUX_ADDR_SHIFT          20
-
-/*exynos5440 specific registers*/
-#define EXYNOS5440_TMU_S0_7_TRIM		0x000
-#define EXYNOS5440_TMU_S0_7_CTRL		0x020
-#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
-#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
-#define EXYNOS5440_TMU_S0_7_TH0			0x110
-#define EXYNOS5440_TMU_S0_7_TH1			0x130
-#define EXYNOS5440_TMU_S0_7_TH2			0x150
-#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
-#define EXYNOS5440_TMU_S0_7_IRQ			0x230
-/* exynos5440 common registers */
-#define EXYNOS5440_TMU_IRQ_STATUS		0x000
-#define EXYNOS5440_TMU_PMIN			0x004
-
-#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
-#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
-#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
-#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
-#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
-#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
-#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
-#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
-#define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
-#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
-
-extern struct exynos_tmu_init_data const exynos3250_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos4412_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos5260_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos5420_default_tmu_data;
-extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
-
-#endif /*_EXYNOS_TMU_DATA_H*/
-- 
1.8.2.3

