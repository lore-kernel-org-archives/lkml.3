Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3HGIg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:36:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65232 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab3HGIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:36:22 -0400
X-AuditID: cbfee68e-b7f276d000002279-98-52020704d8ef
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com
Subject: [PATCH] thermal: exynos_tmu: fix wrong error check for mapped memory
Date: Wed, 07 Aug 2013 14:01:09 +0530
Message-id: <1375864269-9197-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkTpeFnSnI4NVvGYuGqyEWa/b/ZLLo
	XXCVzeLyrjlsFp97jzBazDi/j8niycM+Ngd2j8V7XjJ59G1Zxehx/MZ2Jo/Pm+QCWKK4bFJS
	czLLUov07RK4Mp68/85asIStom3hAZYGxiWsXYycHBICJhJ925YyQdhiEhfurWfrYuTiEBJY
	yiix8tUuRpiiCxPWs0IkpjNKLJh0nRHC6WGS2HNiDjtIFZuAmcTBRavBbBEBL4lZD6+CjWUW
	KJV4uPMX2DphAV+JNZ2f2UBsFgFViR0PP4PV8Aq4SKzb+hyolwNom4LEnEk2IPMlBL6zSfy4
	cpERol5A4tvkQywQNbISmw4wQxwnKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXr
	JefnbmIEhurpf8/6djDePGB9iDEZaNxEZinR5HxgqOeVxBsamxlZmJqYGhuZW5qRJqwkzqvW
	Yh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTF7zdvGW3eO8zsHxKh8ltq+7up+nZc+JnNn
	a1vEnVYoEU2xSdle3lCWvFuwab6v6t0T+jU/c/e9u8/Vu1pSW+SlFEPb7TULHR7tze9vbnsX
	vqsn5JuCzOlVCuvnLRS/7JIeE/tiW3SgPYvrH4GlNsdbtixflX8v+M9UF7Ynh2ak2TnlBfhl
	9SmxFGckGmoxFxUnAgCNNdzCawIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQV0WdqYgg5X7RCwaroZYrNn/k8mi
	d8FVNovLu+awWXzuPcJoMeP8PiaLJw/72BzYPRbvecnk0bdlFaPH8RvbmTw+b5ILYIlqYLTJ
	SE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpASaEsMacU
	KBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx5P131oIlbBVtCw+wNDAuYe1i5OSQ
	EDCRuDBhPZQtJnHh3nq2LkYuDiGB6YwSCyZdZ4Rwepgk9pyYww5SxSZgJnFw0WowW0TAS2LW
	w6tMIDazQKnEw52/wCYJC/hKrOn8zAZiswioSux4+BmshlfARWLd1udAvRxA2xQk5kyymcDI
	vYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCQ8k97BuKrB4hCjAAejEg9vhRhjkBBr
	YllxZe4hRgkOZiUR3gmsTEFCvCmJlVWpRfnxRaU5qcWHGJOBlk9klhJNzgdGaV5JvKGxibmp
	samliYWJmSVpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MOb9qe/O7fi+ce79+AqtklNN
	/lHStwrf6jMKdP+w4bvwll2h/qCOzLabrJMm/PT9sKsm7Mz0zWXNjRs5n3FbRlXoPz2yUI/V
	74+nnlO6q2GYSMT324IS1qdvLbrap732s+Q3c30D8+sPU17p9TR9k7h8xa6Ke8ksz7kKvyYe
	iHJ1ZrrcmM4voMRSnJFoqMVcVJwIAMng9EvIAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error check is checking for a "base" mapped memory base
instead of "base_common". Fixing the same.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index ec01dfe..a033dbb 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -592,7 +592,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 
 	data->base_common = devm_ioremap(&pdev->dev, res.start,
 					resource_size(&res));
-	if (!data->base) {
+	if (!data->base_common) {
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
 		return -ENOMEM;
 	}
-- 
1.7.9.5

