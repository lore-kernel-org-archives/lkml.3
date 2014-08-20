Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaHTEYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:24:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26971 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTEYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:24:38 -0400
X-AuditID: cbfee690-b7f526d000003627-81-53f423032638
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, amit.daniel@samsung.com
Cc: kgene.kim@samsung.com, b.zolnierkie@samsung.com, t.figa@samsung.com,
        l.majewski@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH] thermal: exynos: Remove duplicate code when reading triminfo
 register of Exynos5440
Date: Wed, 20 Aug 2014 13:24:33 +0900
Message-id: <1408508673-3173-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
References: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUJdZ+UuwQdMDCYuGqyEWG2esZ7W4
	+/wwo8X1L89ZLeYfOcdqsWb/TyaL+VeusVr0LrjKZnG26Q27xZuHmxktNj0Gil3eNYfN4nPv
	EUaLGef3MVk8edjHZrF+xmsWBwGPnbPusnss3vOSyWPzknqPvi2rGD2O39jO5PF5k1wAWxSX
	TUpqTmZZapG+XQJXRt/MLqaCaZwVG2cvYGtgPMbexcjBISFgInHrYGIXIyeQKSZx4d56ti5G
	Lg4hgaWMEkdXn2SCSJhIHDl5kxkiMZ1R4uetc4wQThOTROux2YwgVWwCWhL7X9xgA7FFBDwl
	5kw/wQJiMwu0MUtMmpkAYgsLpEncvzqbGcRmEVCVWDz1BiPIFbwCLhLn7phALJOT+LDnETuI
	zSngKtH+7SDYSCGgks+XFrOD7JUQuMcu8eXqDjaIOQIS3yYfYoH4RlZi0wFmiDmSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgFJ3+92zCDsZ7B6wPMSYDjZvILCWa
	nA+MwrySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YDSNf2bclWx84fHNyaqRYb1fv01bqhLdLLgk6uqVogD5hdxbZJlF/f4vlImbZNH37pHIx+u3
	1yy9F/a3s9L7otesc+v9fspLXMwy+7gz7M2+7tMaye23XyxhPZ+xVcHGO6Nc72Rzf7Nx/vLQ
	010TWZ5X+f4qCLld6F+WfviQAqOnmuPz+/0lP5VYijMSDbWYi4oTAaaZn824AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQV1m5S/BBvuP8Vs0XA2x2DhjPavF
	3eeHGS2uf3nOajH/yDlWizX7fzJZzL9yjdWid8FVNouzTW/YLd483MxosekxUOzyrjlsFp97
	jzBazDi/j8niycM+Nov1M16zOAh47Jx1l91j8Z6XTB6bl9R79G1Zxehx/MZ2Jo/Pm+QC2KIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgO5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb0zexiKpjGWbFx9gK2BsZj7F2M
	nBwSAiYSR07eZIawxSQu3FvP1sXIxSEkMJ1R4uetc4wQThOTROux2YwgVWwCWhL7X9xgA7FF
	BDwl5kw/wQJiMwu0MUtMmpkAYgsLpEncvzobbCqLgKrE4qk3gHo5OHgFXCTO3TGBWCYn8WHP
	I7AjOAVcJdq/HQQbKQRU8vnSYvYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH
	6TOpHYwrGywOMQpwMCrx8Cpkfw4WYk0sK67MPcQowcGsJMIbyvElWIg3JbGyKrUoP76oNCe1
	+BCjKdBRE5mlRJPzgQkkryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMH
	p1QD42ZZuTLFOIk5euezwipftq2fnP+TycCwM8jxR3fntKxtwm7qXS8El2y0iDnQppTOMuPm
	Rnl3xmKNE/8Odhy9GfH28s7Xy66nHcj/P4u9MaXj6cGFiQY/8loanQ5tizoWnWpy0flkm+o2
	I5Wvk9UFS5ICdJbM3f3LJG2Jas8XZZu9Lnuu/jU0VmIpzkg01GIuKk4EAEN6iRroAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove simply duplicate code when reading triminfo register of Exynos5440.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index ed01606..13c2e01 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -181,15 +181,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		 */
 		switch (data->id) {
 		case 0:
+		case 2:
 			trim_info = readl(data->base +
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 			break;
 		case 1:
 			trim_info = readl(data->base + reg->triminfo_data);
 			break;
-		case 2:
-			trim_info = readl(data->base -
-			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
 		/* On exynos5420 the triminfo register is in the shared space */
-- 
1.8.0

